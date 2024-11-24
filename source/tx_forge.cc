/*
        Fractal forgery generator for the PPM toolkit

    Originally  designed  and  implemented  in December of 1989 by
    John Walker as a stand-alone program for the  Sun  and  MS-DOS
    under  Turbo C.  Adapted in September of 1991 for use with Jef
    Poskanzer's raster toolkit.

    References cited in the comments are:

        Foley, J. D., and Van Dam, A., Fundamentals of Interactive
        Computer  Graphics,  Reading,  Massachusetts:  Addison
        Wesley, 1984.

        Peitgen, H.-O., and Saupe, D. eds., The Science Of Fractal
        Images, New York: Springer Verlag, 1988.

        Press, W. H., Flannery, B. P., Teukolsky, S. A., Vetterling,
        W. T., Numerical Recipes In C, New Rochelle: Cambridge
        University Press, 1988.

    Author:
        John Walker
        http://www.fourmilab.ch/

    Permission  to  use, copy, modify, and distribute this software and
    its documentation  for  any  purpose  and  without  fee  is  hereby
    granted,  without any conditions or restrictions.  This software is
    provided "as is" without express or implied warranty.

*/

/* Ripped apart to use in OBLIGE by Andrew Apted, October 2008 */

#include "tx_forge.h"

#include <string.h>

#include "lib_util.h"
#include "main.h"
#include "sys_assert.h"
#include "sys_macro.h"
#include "sys_xoshiro.h"

/* Definitions used to address FORGE_REAL and imaginary parts in a two-dimensional
   array of complex numbers as stored by fourn(). */

static float *mesh_a;
static int    meshsize;

#define FORGE_REAL(x, y) mesh_a[1 + (((x) * meshsize) + (y)) * 2]
#define FORGE_IMAG(x, y) mesh_a[2 + (((x) * meshsize) + (y)) * 2]

static void create_mesh(int width)
{
    meshsize = width;

    int total_elem = (meshsize * meshsize + 1) * 2;

    mesh_a = new float[total_elem];

    // clear it to zeros
    memset(mesh_a, 0, total_elem * sizeof(float));
}

static void free_mesh(void)
{
    delete[] mesh_a;
    mesh_a = NULL;
}

/*  FOURN  --  Multi-dimensional fast Fourier transform

    Called with arguments:

       data   A  one-dimensional  array  of  floats  (NOTE!!!  NOT
              DOUBLES!!), indexed from one (NOTE!!! NOT  ZERO!!),
              containing  pairs of numbers representing the complex
              valued samples.  The Fourier transformed results  are
              returned in the same array.

       nn     An  array specifying the edge size in each dimension.
              THIS ARRAY IS INDEXED FROM  ONE,  AND  ALL  THE  EDGE
              SIZES MUST BE POWERS OF TWO!!!

       ndim   Number of dimensions of FFT to perform.  Set to 2 for
              two dimensional FFT.

       isign  If 1, a Fourier transform is done; if -1 the  inverse
              transformation is performed.

    This function is essentially as given in Press et al., "Numerical
    Recipes In C", Section 12.11, pp. 467-470.
*/

static void fourn(float data[], int nn[], int ndim, int isign)
{
    int    i1, i2, i3;
    int    i2rev, i3rev, ip1, ip2, ip3, ifp1, ifp2;
    int    ibit, idim, k1, k2, n, nprev, nrem, ntot;
    float  tempi, tempr;
    double theta, wi, wpi, wpr, wr, wtemp;

#define FORGE_FN_SWAP(a, b)                                                                                            \
    tempr = (a);                                                                                                       \
    (a)   = (b);                                                                                                       \
    (b)   = tempr

    ntot = 1;
    for (idim = 1; idim <= ndim; idim++)
    {
        ntot *= nn[idim];
    }
    nprev = 1;
    for (idim = ndim; idim >= 1; idim--)
    {
        n     = nn[idim];
        nrem  = ntot / (n * nprev);
        ip1   = nprev << 1;
        ip2   = ip1 * n;
        ip3   = ip2 * nrem;
        i2rev = 1;
        for (i2 = 1; i2 <= ip2; i2 += ip1)
        {
            if (i2 < i2rev)
            {
                for (i1 = i2; i1 <= i2 + ip1 - 2; i1 += 2)
                {
                    for (i3 = i1; i3 <= ip3; i3 += ip2)
                    {
                        i3rev = i2rev + i3 - i2;
                        FORGE_FN_SWAP(data[i3], data[i3rev]);
                        FORGE_FN_SWAP(data[i3 + 1], data[i3rev + 1]);
                    }
                }
            }
            ibit = ip2 >> 1;
            while (ibit >= ip1 && i2rev > ibit)
            {
                i2rev -= ibit;
                ibit >>= 1;
            }
            i2rev += ibit;
        }
        ifp1 = ip1;
        while (ifp1 < ip2)
        {
            ifp2  = ifp1 << 1;
            theta = isign * (OBSIDIAN_PI * 2) / (ifp2 / ip1);
            wtemp = sin(0.5 * theta);
            wpr   = -2.0 * wtemp * wtemp;
            wpi   = sin(theta);
            wr    = 1.0;
            wi    = 0.0;
            for (i3 = 1; i3 <= ifp1; i3 += ip1)
            {
                for (i1 = i3; i1 <= i3 + ip1 - 2; i1 += 2)
                {
                    for (i2 = i1; i2 <= ip3; i2 += ifp2)
                    {
                        k1           = i2;
                        k2           = k1 + ifp1;
                        tempr        = wr * data[k2] - wi * data[k2 + 1];
                        tempi        = wr * data[k2 + 1] + wi * data[k2];
                        data[k2]     = data[k1] - tempr;
                        data[k2 + 1] = data[k1 + 1] - tempi;
                        data[k1] += tempr;
                        data[k1 + 1] += tempi;
                    }
                }
                wr = (wtemp = wr) * wpr - wi * wpi + wr;
                wi = wi * wpr + wtemp * wpi + wi;
            }
            ifp1 = ifp2;
        }
        nprev *= n;
    }
}
#undef FORGE_FN_SWAP

/*  INITGAUSS  --  Initialize random number generators.  As given in
                   Peitgen & Saupe, page 77.
*/
static constexpr uint8_t NRAND = 4; /* Gauss() sample count */

static double gauss_add, gauss_mul; /* Gaussian random parameters */

static void init_gauss(void)
{
    /* Range of random generator */
    gauss_add = sqrt(3.0 * NRAND);
    gauss_mul = 2 * gauss_add / (NRAND * double(0xFFFF));
}

/*  GAUSS  --  Return a Gaussian random number.  As given in Peitgen
               & Saupe, page 77. */
static double rand_gauss(void)
{
    double sum = 0.0;

    for (int i = 0; i < NRAND; i++)
    {
        sum += (xoshiro_UInt() & 0xFFFF);
    }

    return sum * gauss_mul - gauss_add;
}

static double rand_phase(void)
{
    return 2 * OBSIDIAN_PI * xoshiro_Double();
}

/*  SPECTRALSYNTH  --  Spectrally  synthesized  fractal  motion in two
                       dimensions.  This algorithm is given under  the
                       name   SpectralSynthesisFM2D  on  page  108  of
                       Peitgen & Saupe.
*/
static void spectral_synth(int n, double h)
{
    int i, j;

    for (i = 0; i <= n / 2; i++)
    {
        for (j = 0; j <= n / 2; j++)
        {
            double phase = rand_phase();
            double rad;

            if (i == 0 && j == 0)
            {
                rad = 0;
            }
            else
            {
                rad = pow((double)(i * i + j * j), -(h + 1) / 2) * rand_gauss();
            }

            double rcos = rad * cos(phase);
            double rsin = rad * sin(phase);

            int i0 = (i == 0) ? 0 : n - i;
            int j0 = (j == 0) ? 0 : n - j;

            FORGE_REAL(i, j)   = rcos;
            FORGE_IMAG(i, j)   = rsin;
            FORGE_REAL(i0, j0) = rcos;
            FORGE_IMAG(i0, j0) = -rsin;
        }
    }

    FORGE_IMAG(n / 2, 0)     = 0;
    FORGE_IMAG(0, n / 2)     = 0;
    FORGE_IMAG(n / 2, n / 2) = 0;

    for (i = 1; i <= n / 2 - 1; i++)
    {
        for (j = 1; j <= n / 2 - 1; j++)
        {
            double phase = rand_phase();
            double rad   = pow((double)(i * i + j * j), -(h + 1) / 2) * rand_gauss();

            double rcos = rad * cos(phase);
            double rsin = rad * sin(phase);

            FORGE_REAL(i, n - j) = rcos;
            FORGE_IMAG(i, n - j) = rsin;
            FORGE_REAL(n - i, j) = rcos;
            FORGE_IMAG(n - i, j) = -rsin;
        }
    }

    int nsize[3];

    nsize[0] = 0;
    nsize[1] = nsize[2] = n;     /* Dimension of frequency domain array */

    fourn(mesh_a, nsize, 2, -1); /* Take inverse 2D Fourier transform */
}

static void copy_and_scale(float *buf)
{
    /* Compute extrema for autoscaling. */
    double rmin = 1e30;
    double rmax = -1e30;

    int i, j;

    for (i = 0; i < meshsize; i++)
    {
        for (j = 0; j < meshsize; j++)
        {
            double r = FORGE_REAL(i, j);

            rmin = OBSIDIAN_MIN(rmin, r);
            rmax = OBSIDIAN_MAX(rmax, r);
        }
    }

    //  fprintf(stderr, "MESH RANGE : %1.5f .. %1.5f\n", rmin, rmax);

    double range = (rmax - rmin);

    if (fabs(range) < 0.0001)
    {
        range = 0.0001;
    }

    for (i = 0; i < meshsize; i++)
    {
        for (j = 0; j < meshsize; j++)
        {
            *buf++ = (FORGE_REAL(i, j) - rmin) / range;
        }
    }
}

static void power_law_scale(float *buf, double powscale)
{
    /* Apply power law scaling if non-unity scale is requested. */

    float *buf_end = buf + (meshsize * meshsize);

    for (; buf < buf_end; buf++)
    {
        *buf = pow(*buf, powscale);
    }
}

void TX_SpectralSynth(unsigned long long seed, float *buf, int width, double fracdim, double powscale)
{
    SYS_ASSERT(width > 0 && (width & 1) == 0);
    SYS_ASSERT(0 < fracdim && fracdim < 4.0);
    SYS_ASSERT(powscale > 0);

    // NOTE : width *must* be a power of two
    for (int test = width; test > 1; test >>= 1)
    {
        if (test & 1)
        {
            FatalError("TX_SpectralSynth: width '%d' is not a power of two\n", width);
        }
    }

    init_gauss();

    create_mesh(width);

    spectral_synth(width, 3.0 - fracdim);

    copy_and_scale(buf);

    if (fabs(powscale - 1.0) > 0.01)
    {
        power_law_scale(buf, powscale);
    }

    free_mesh();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
