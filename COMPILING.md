
# COMPILING Obsidian

## BSD Dependencies
1. CMake Utilities:
   * package: `cmake`

2. Xorg:
   * package: `xorg` (`xorg-libraries` on its own doesn't seem sufficient)

3. FLTK:
   * package: `fltk`

The C++ compiler/toolchain should already be present on a typical BSD install

## Linux Dependencies (MSYS has some differences; see MSYS Cross-Compilation section below)

1. C++ compiler and associated tools
   * packages: `g++` `binutils`
   * if compiling with clang: `clang`
   * compiler and toolchain need C++17 capabilities

2. GNU make
   * package: `make`

3. CMake Utilities:
   * package: `cmake`

4. Development libraries
   * package: `libfontconfig1-dev`
   * recommended if using X11 for better fonts: `libxft-dev`
   * if using X11 and not pulled in by one of the above packages: `libx11-dev`
   * package: `libfltk1.3-dev` (minimum required version, later versions also acceptable)

## Linux/BSD Compilation

Assuming all those dependencies are met, then the following steps
will build the Obsidian binary.

```
> cmake -B build -DCMAKE_BUILD_TYPE=Release
> cmake --build build (-j# optional, with # being the number of cores you'd like to use)
> strip ./obsidian (if desired)
```

Then, Obsidian can be launched with:

```
> ./obsidian
```

## Windows Cross-Compilation on Linux using MinGW

You will need the `mingw-w64` package as well (or your distro's equivalent).

```
> cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=./Toolchain_mingw64.cmake (use Toolchain_mingw32.cmake for a 32-bit build)
> cmake --build build (-j# optional, with # being the number of cores you'd like to use)
```

Then, Obsidian can be launched (in Windows, or with Wine) with:

```
> ./obsidian.exe
```

## Windows Cross-Compilation using MSYS

You will need to install the following on top of the regular MSYS Mingw64 install:
   * package: `mingw-w64-(arch)-cmake`

Similar to the above directions:

```
> cmake -B build -G "MSYS Makefiles"
> cmake --build build (-j# optional, with # being the number of cores you'd like to use)
```

Then, Obsidian can be launched (in Windows) with:

```
> obsidian.exe
```

## Windows Compilation using MSVC Build Tools and VSCode

Download the Visual Studio Build Tools Installer and install the 'Desktop Development with C++' Workload
  - Also select the "C++ CMake tools for Windows" optional component

Install VSCode as well as the C/C++ and CMake Tools Extensions

After opening the project folder in VSCode, select the 'Visual Studio Build Tools (version) Release - x86_amd64' kit for 64-bit, or the x86 kit for 32-bit

Select the Release CMake build variant

Click Build

Then, Obsidian can be launched with:

```
> obsidian.exe
```