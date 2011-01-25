================== how to install: ========================
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH="/tmp/nix-cmake" ..
make install
 -> this should be all, remember to adapt the DCMAKE_INSTALL_PREFIX:PATH to your desired path

WARNING: do NOT use 'make install DESTDIR="DO_NOT_USE_THIS_DESTDIR_THING" as the nix CMakeLists.txt stuff does not work with it





todo:
---- installation done targets ----

 - search for all command line toggles which were important for ./configure automake crap
  -> --prefix=/usr/local
  -> --localstatedir=/tmp/nix/state
  -> --with-store-dir=/tmp/nix/store

  --bindir=DIR            user executables [EPREFIX/bin]
  --sbindir=DIR           system admin executables [EPREFIX/sbin]
  --libexecdir=DIR        program executables [EPREFIX/libexec]  
  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]          
  --libdir=DIR            object code libraries [EPREFIX/lib]                  
  --includedir=DIR        C header files [PREFIX/include]                      
  --oldincludedir=DIR     C header files for non-gcc [/usr/include]            
  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share] 
  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
  --infodir=DIR           info documentation [DATAROOTDIR/info]                
  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]           
  --mandir=DIR            man documentation [DATAROOTDIR/man]                  
  --docdir=DIR            documentation root [DATAROOTDIR/doc/nix]









- find all utils/programs needed for runtime
 - scripts are still not valid: check for tools and insert them into @foo@
  # grep -h "@[a-z,0-9]*@" -o * | sort | uniq
  for that for 
   -> scripts
   -> corepkgs


================== done: ==================
- WARNING: store/ is no longer created with 1777 but instead drwxr-xr-x 755
- WARNING: libraries are no longer installed with 'libmain.so.0', 'libmain.so.0.0', 'libmain.so.0.0.0'. also 'libmain.so.la' is missing.
- NOTICE: renamed scripts/nix-profile.sh.in into scripts/nix.sh.in (as it is installed in the autotools variant as nix.sh)
- NOTICE: the nix release version is now provided by NIX_VERSION in the main CMakeLists.txt file
- NOTICE: src/boost/shared_count.hpp was not installed in the autotools variant (cmake installs it)
- NOTICE: src/boost/workaround.hpp  was not installed in the autotools variant (cmake installs it)
- NOTICE: uses native bzip2, removed ./libexec/nix/bunzip2 and ./libexec/nix/bzip2
 - WARNING: no bzip2 tests anymore, should there be any?
   ./bzip2 -1  < sample1.ref > sample1.rb2               
   ./bzip2 -2  < sample2.ref > sample2.rb2  
- QUESTION: bsdiff/bspatch seem to be patched but patch is not 'yet' upstream?!
- FIX: fixes bug where '--with-store-dir' was changed using another run of ./configure 
  but the autotools variant (in contrast to the cmake variant) would require a 'make distclean' first to work as expected
- FIX: config.h (config.h.in) was used for two things: SYSTEM and OPENSSL_PATH (all other values were not used)
       most files still contain the include, but it is not needed. please FIX upstream.
	  src/nix-setuid-helper/nix-setuid-helper.cc:#include "config.h"
	  src/libstore/local-store.cc:#include "config.h"
	  src/libstore/build.cc:#include "config.h"
	  src/libutil/hash.cc:#include "config.h"
	  src/libutil/archive.cc:#include "config.h"
	  src/libutil/util.cc:#include "config.h"
	  src/libmain/shared.cc:#include "config.h"
       the replacement now uses defines as done in libmain originally. when fixing this please consider:
         a) remove all above include statements
         b) remove config.h.in
         c) edit CMakelists.txt and remove CONFIGURE_FILE for config.h.in
         d) remove all includes in the respective subprojects using config.h as: nix-setuid-helper, libstore, libutil, libmain
            remove include(CMAKE_BINARY_DIR) as it is not needed anymore
       NOTICE: having config.h not installed questions if the /include installation is used at all. probably not
 - NOTICE: after installation the binary from nix-cmake does know where to search for the library and makes the LD_LIBRARY_PATH unnecessary,
           see http://www.cmake.org/Wiki/CMake_RPATH_handling
           -> this is done to be compatible with the autotools build but could be optimized by not adding a RPATH for in- or out-of-source builds
              as binaries might not be executed during 'make' time (only in the field, after 'make install') anyway it would only speed up the 'make install' step 
              and this does not take that long therefore i did not optimize this



 - install headers
 - install binaries
 - install libraries .so
 - check permissions of files
 - create directories
 - install manpages/configs
 - rework the symlink makro to be globally defined





- fix RPATH thing again, did stop to work
  regression was because of the wrong path being linked to:
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${NIX_LIB_DIR}")
 -> resulting in "/usr/local//lib"
but using: make install DESTDIR=/tmp/foo 
 -> "/tmp/foo/lib"

when using: 
NOTE: cmake -DCMAKE_INSTALL_PREFIX:PATH="/tmp/nix-cmake" .. && make install 
one HAS to use relative directories to make installation work
-> watch for wrong "Set runtime path of" directories
this should be the directory your libfoo.so is located     
- now installations with prefix will overwrite all others but warn about recompilation issues related to moving /nix/store into $prefix/nix/store where prefix != /
 - cmake relative path is done using:
  INSTALL(FILES "ssh.pm" DESTINATION "libexec/nix")
  -> installs into /usr/local/libexec/nix
  vs
  INSTALL(FILES "ssh.pm" DESTINATION "/libexec/nix")
  -> installs into /libexec/nix
 - fix relative 'make install DESTDIR=/tmp/foo' installation issue, where the defines would be incorrect when used
   -> $ENV{DESTDIR}${VAR_INSTALL_DIR}
   -> CMAKE_INSTALL_PREFIX

================== required software dependencies: ==================
- cmake (buildtime only)
- openssl
- coreutils
- bzip2
- bunzip2
- curl
- bash
- gzip
- sed
- perl
- tar
- tr

================== final testing: ========================
  cd build
  rm -Rf /home/meli/Desktop/nix/nix-0.16-cmake/build/*  && cmake .. && make && make install DESTDIR=/tmp/foo

  - must work if:
    - out of source build aka; mkdir build; cd build; cmake ..; 
      WARNING: in source build is not tested nor supported!
    - install either with:
      - cmake ..; make install DESTDIR=/tmp/foo
      - cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..; make install
    - must compile in windows(cygwin)/linux/mac os x/nix
  
================== blog: ==================
 - why is nix-prefix deployment faster than gentoo-prefix deployment: 
  > nix uses more system tools
   < does it use native gcc?
  > nix does not recompile much
 - what is better:
  a) several places including "config.h" produced by configure_file(config.h.in config.h @only)
  b) several places modified using configure_file individually
  c) use DEFINES as -DNIX_LOG_DIR="/nix/var/log/nix"
  for some files (as scripts) it would be good to use a) if there are many many variables shared but b) if it is only the version of the program
  for compiler code it is sufficient to use defines when needed
  a) is also cool when wanting all headers+config.h to be available for later library usage as it might be needed for projects later on
     this is however not the case here as config.h (in the autotools style project) isn't installed at all

 - advantage using:
   make install DESTDIR=/tmp/foo over cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local
 - discuss why "BUILD_WITH_INSTALL_RPATH ON" is important (compare to autotools nix build, where this was default). 
   this helps to find the library while not having to use LD_LIBRARY_PATH
   http://www.cmake.org/Wiki/CMake_RPATH_handling
 - seen this work in the perspective of a package manager
   -> it is important that paths are 'relative' in the sense of 'make install' so that one can 
      install this project into a prefix and later create a package from that which will however, be deployed to '/'
      therefore a 'relative' path structure for libraries and search paths is crucial
