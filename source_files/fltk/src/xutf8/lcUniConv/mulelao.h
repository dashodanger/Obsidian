/* $XFree86: xc/lib/X11/lcUniConv/mulelao.h,v 1.3 2000/11/29 17:40:35 dawes Exp $ */

/*
 * MULELAO-1
 */

static const unsigned short mulelao_2uni[96] = {
    /* 0xa0 */
    0x00a0,
    0x0e81,
    0x0e82,
    0xfffd,
    0x0e84,
    0xfffd,
    0xfffd,
    0x0e87,
    0x0e88,
    0xfffd,
    0x0e8a,
    0xfffd,
    0xfffd,
    0x0e8d,
    0xfffd,
    0xfffd,
    /* 0xb0 */
    0xfffd,
    0xfffd,
    0xfffd,
    0xfffd,
    0x0e94,
    0x0e95,
    0x0e96,
    0x0e97,
    0xfffd,
    0x0e99,
    0x0e9a,
    0x0e9b,
    0x0e9c,
    0x0e9d,
    0x0e9e,
    0x0e9f,
    /* 0xc0 */
    0xfffd,
    0x0ea1,
    0x0ea2,
    0x0ea3,
    0xfffd,
    0x0ea5,
    0xfffd,
    0x0ea7,
    0xfffd,
    0xfffd,
    0x0eaa,
    0x0eab,
    0xfffd,
    0x0ead,
    0x0eae,
    0x0eaf,
    /* 0xd0 */
    0x0eb0,
    0x0eb1,
    0x0eb2,
    0x0eb3,
    0x0eb4,
    0x0eb5,
    0x0eb6,
    0x0eb7,
    0x0eb8,
    0x0eb9,
    0xfffd,
    0x0ebb,
    0x0ebc,
    0x0ebd,
    0xfffd,
    0xfffd,
    /* 0xe0 */
    0x0ec0,
    0x0ec1,
    0x0ec2,
    0x0ec3,
    0x0ec4,
    0xfffd,
    0x0ec6,
    0xfffd,
    0x0ec8,
    0x0ec9,
    0x0eca,
    0x0ecb,
    0x0ecc,
    0x0ecd,
    0xfffd,
    0xfffd,
    /* 0xf0 */
    0x0ed0,
    0x0ed1,
    0x0ed2,
    0x0ed3,
    0x0ed4,
    0x0ed5,
    0x0ed6,
    0x0ed7,
    0x0ed8,
    0x0ed9,
    0xfffd,
    0xfffd,
    0x0edc,
    0x0edd,
    0xfffd,
    0xfffd,
};

static int mulelao_mbtowc(conv_t conv, ucs4_t *pwc, const unsigned char *s, int n) {
  unsigned char c = *s;
  if (c < 0xa0) {
    *pwc = (ucs4_t)c;
    return 1;
  } else {
    unsigned short wc = mulelao_2uni[c - 0xa0];
    if (wc != 0xfffd) {
      *pwc = (ucs4_t)wc;
      return 1;
    }
  }
  return RET_ILSEQ;
}

static const unsigned char mulelao_page0e[96] = {
    0x00, 0xa1, 0xa2, 0x00, 0xa4, 0x00, 0x00, 0xa7, /* 0x80-0x87 */
    0xa8, 0x00, 0xaa, 0x00, 0x00, 0xad, 0x00, 0x00, /* 0x88-0x8f */
    0x00, 0x00, 0x00, 0x00, 0xb4, 0xb5, 0xb6, 0xb7, /* 0x90-0x97 */
    0x00, 0xb9, 0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0xbf, /* 0x98-0x9f */
    0x00, 0xc1, 0xc2, 0xc3, 0x00, 0xc5, 0x00, 0xc7, /* 0xa0-0xa7 */
    0x00, 0x00, 0xca, 0xcb, 0x00, 0xcd, 0xce, 0xcf, /* 0xa8-0xaf */
    0xd0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7, /* 0xb0-0xb7 */
    0xd8, 0xd9, 0x00, 0xdb, 0xdc, 0xdd, 0x00, 0x00, /* 0xb8-0xbf */
    0xe0, 0xe1, 0xe2, 0xe3, 0xe4, 0x00, 0xe6, 0x00, /* 0xc0-0xc7 */
    0xe8, 0xe9, 0xea, 0xeb, 0xec, 0xed, 0x00, 0x00, /* 0xc8-0xcf */
    0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, /* 0xd0-0xd7 */
    0xf8, 0xf9, 0x00, 0x00, 0xfc, 0xfd, 0x00, 0x00, /* 0xd8-0xdf */
};

static int mulelao_wctomb(conv_t conv, unsigned char *r, ucs4_t wc, int n) {
  unsigned char c = 0;
  if (wc < 0x00a0) {
    *r = wc;
    return 1;
  } else if (wc == 0x00a0)
    c = 0xa0;
  else if (wc >= 0x0e80 && wc < 0x0ee0)
    c = mulelao_page0e[wc - 0x0e80];
  if (c != 0) {
    *r = c;
    return 1;
  }
  return RET_ILSEQ;
}
