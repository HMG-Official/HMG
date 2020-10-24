# Scripts to compile HMG on GitHub

These scripts are to compile HMG official 32bit unicode with MinGW 9.30

  - 2020-10-11  hb32_mgw930_32b.yml

  - 2020-10-11  hmg34offi_hb32_mgw930_32b_uni.yml
  
      Output= HMG library.

  - 2020-10-11  hmg34offi_all_hb32_mgw930_32b_uni.yml
  
      Output= All HMG libraries.

  - 2020-10-11  hmg34_hb32_mgw930_32b_uni.yml
  
      Output= Harbour binaries

  - 2020-10-11  hb32_mgw930_32b_2020_10_11.zip
  
      Harbour binaries compiled, ziped.

#### Compile HMG on different forks

 To compile your fork you should replace the lines where exist "HMG-Official/HMG" in scripts and put your github fork site.

replace
 ```
    - name: Checkout hmg repo
      uses: actions/checkout@v2
      with:
        repository: HMG-Official/HMG
       path: HMG-Official/HMG
    to

    - name: Checkout hmg repo
      uses: actions/checkout@v2
      with:
        repository: asistex/HMG
       path: asistex/HMG



      run: |
        cd HMG-Official\hmg
    to
      run: |
        cd asistex\hmg



      run: |
        mkdir output
        robocopy HMG-Official\hmg\ output\ /E
    to
      run: |
        mkdir output
        robocopy asistex\hmg\ output\ /E
 ```


### HMG official
  https://github.com/HMG-Official/HMG

### harbour source
  https://github.com/asistex/HMG/raw/master/workflows/hb32_mgw930_32b_2020_10_11.zip

### mingw source
  https://bitbucket.org/lorenzodla/mod_harbour_actions_resources/downloads/mingw32.zip
  * gcc version

    winlibs personal build version gcc-9.3.0-llvm-10.0.0-mingw-w64-7.0.0-r4

    This is the winlibs 32-bit standalone build of:

     - GCC 9.3.0
     - GDB 9.1
     - LLVM/Clang/LLD/LLDB 10.0.0- MinGW-w64 7.0.0
     - GNU Binutils 2.34
     - GNU Make 4.3
     - PExports 0.47
     - dos2unix 7.4.1
     - Yasm 1.3.0
     - NASM 2.14.02

     This build was compiled with GCC 9.3.0 on 2020-04-29.
     Please check out http://winlibs.com/ for the latest personal build.

