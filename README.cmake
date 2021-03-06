WARNING: this codebase has not been tested yet, this is a developer release of incomplete code.

- STATUS: tested successfully on my gentoo linux box as prefix installation

     i have tested the cmake based installer on my dual core 64 bit computer with a prefix installation in gentoo and it worked, i installed vim into /nix/store
     but as a normal user (see the assisted installation below, and especially step (6) to understand the setup)
           - used vim
           - used evopedia

================== broken stuff ==================
-> paths in libmain are wrong. in fact: i think i have to rework all paths
given by CMakeLists.txt, libmain's
-DNIX_STORE_DIR=/nix/store
-DNIX_DATA_DIR=/tmp/nix-prefix/share
-DNIX_STATE_DIR=/tmp/nix-prefix/state
-DNIX_LOG_DIR=/tmp/nix-prefix/state/log/nix
-DNIX_CONF_DIR=/tmp/nix-prefix/etc
-DNIX_LIBEXEC_DIR=/tmp/nix-prefix/libexec
-DNIX_BIN_DIR=/tmp/nix-prefix/bin
-DNIX_VERSION=0.16

autotools log
-DNIX_STORE_DIR=\"/tmp/nix-autotools/store\" 
-DNIX_DATA_DIR=\"/tmp/nix-autotools/share\" 
-DNIX_STATE_DIR=\"/tmp/nix-autotools/state/nix\" 
-DNIX_LOG_DIR=\"/tmp/nix-autotools/state/log/nix\" 
-DNIX_CONF_DIR=\"/tmp/nix-autotools/etc/nix\" 
-DNIX_LIBEXEC_DIR=\"/tmp/nix-autotools/libexec\"
 -DNIX_BIN_DIR=\"/tmp/nix-autotools/bin\" 




-> the symlink created by """etc/profile.d/nix.sh""" does point to a not existing direcotry /tmp/nix-prefix/state/nix/profiles/default/
   i've added a symlink from  /tmp/nix-prefix/state/nix/profiles/default/   to   ../../profiles/default/ and now i can:
   export PATH=/home/meli/.nix-profile/bin:$PATH
   and use binaries installed via nix
   -> does nix-autotools do that automatically??
  -> this error will only occur when "etc/profile.d/nix.s" is run before nix-channel --update

-> symlink index.html in /tmp/nix-cmake/share/doc/nix/manual should not point to /tmp/nix-cmake/share/doc/nix/manual/manual.html
  -> in contrast, symlinks in /state/nix/gcroots should be absolute (and they are correct)

-> what does the next message mean?
warning: `/tmp/nix-prefix/state/nix/profiles/default-1-link' is not in a directory where the garbage collector looks for roots; therefore, `/nix/store/4pi3p39g4n8ssf6aqswk5xm5x4k8b6p6-user-environment' might be removed by the garbage collector
================== resolved issues ==================
-> when SYSTEM (like x86_64-linux) is wrongly defined, this will lead to strange problems as for instance it will remove too many packages in the store 
   when calling nix-collect-garbage. a better way would be to fail with a meaning full error message


 - nix-collect-garbage should not remove _all_ packages, which it does currenlty? why?!
  -> experimented with nix-autotools (which uses /nix/store (after i cleaned it)) and using the same commands it WON'T remove the manifest
     so something is weird here.

this is the log from nix-cmake installation:

% nix-collect-garbage
...
deleting `/nix/store/i4wr07l46zx7wxhsfgvlskxx5628jd9b-MANIFEST'
deleting `/nix/store/9ahzh7ijb8dr2whiqc747brfp38vpaai-sha256_a4a940c02aff04b0473113ce05702b3e892ee80a7de3d48aef8dec7921ac98dc'
deleting `/nix/store/lyjrp1pab3q053j7ynmdfxwmwikj7yma-gstreamer-0.10.30.tar.bz2.drv'
deleting `/nix/store/vzdasddxy8pcy26rgdz2w5qgna0zx391-jasper-1.900.1.zip.drv'
deleting `/nix/store/dicm45m90za246ha8dq034njbm9n083y-libXau-1.0.6.tar.bz2.drv'
deleting `/nix/store/s87cjfdmsmig09rjgnar2bphndjlmn91-mysql-5.1.54.tar.gz.drv'
deleting `/nix/store/8n8ds44j88cik2zi8iifm3bz6bzmq84h-sha256_02a98b55e21f43ccda09f3cf595372d68cfcf63797e5f8367bab2dfdf9a16d42'
deleting `/nix/store/xlpbmqvy176nxs26vaqqizlgbpm03jl3-sha256_0df182aef808ccd748c8b850325cbbc5b4f402db3857551cfdcc99ac1687bd0d'
deleting `/nix/store/jvnpvxfyb646kd15vykdfc4v4kk1q1r6-libXext-1.1.2.tar.bz2.drv'
deleting `/nix/store/wjkza7mhq90lqakg9knqgrc14xy55sn6-sha256_0f17636849bbef928689036b37731d61fbcdb00b9b282025dce32fd1e20b821f'
deleting `/nix/store/a7v2wm1wd8qhb1hx76ia52srl5xm82a4-sha256_e78711dc660f140720167e48813b4aa96b195b4ee6b8bcec5e8f718dcee5e56d'
deleting `/nix/store/k0l5smwpjckasqlyfpi61whn5ndqfxfa-pci.ids.20100714.bz2.drv'
deleting `/nix/store/9csn0wh170k5bh7yfbsyxj3d1zjgay9d-sha256_6b60849126676a2cf2bc403a79933c39c3f107e604d83dbddd445bb667de0e77'
deleting `/nix/store/mdhjy7ddslyna0cxmgwykdbanyrs72hp-sha256_ccec48e0e99adcdba1762bc1a719c109425ff63d1793411318e415d526e2037e'
deleting `/nix/store/cfk04ans56xql9l6waqhqzzd60g9rzxi-search-path.patch'
deleting `/nix/store/mkfjx7x76gaz0bdjkgax425wk9h6iz3f-inputproto-2.0.tar.bz2.drv'
526 store paths deleted, 879629860 bytes (838.88 MiB, 1807544 blocks) freed
% which vim                                                                                                                                   5436 2 pts/2 /tmp/nix-prefix meli@anuBis 11-01-28 2:55:54
/usr/bin/vim
% which evopedia                                                                                                                              5437 2 pts/2 /tmp/nix-prefix meli@anuBis 11-01-28 3:00:19
evopedia not found
1 % nix-env -e vim                                                                                                                            5438 2 pts/2 /tmp/nix-prefix meli@anuBis 11-01-28 3:00:23
cannot open `/tmp/nix-prefix/state/nix/manifests/nixpkgs-unstable-eefd72b088a432de0aa0e1703e30ae4a.nixmanifest': No such file or directory at /tmp/nix-prefix/libexec/nix/readmanifest.pm line 28.
error: unexpected EOF reading a line

% nix-channel --update                                                                                                                       5450 2 pts/2 /tmp/nix-prefix meli@anuBis 11-01-28 12:03:20
fetching list of Nix archives at `http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST.bz2'...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 8904k  100 8904k    0     0   678k      0  0:00:13  0:00:13 --:--:--  688k
25675 store paths in manifest
downloading Nix expressions from `http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/nixexprs.tar.bz2'...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 3328k  100 3328k    0     0   634k      0  0:00:05  0:00:05 --:--:--  656k
unpacking channel Nix expressions...
the following derivations will be built:
  /nix/store/c7r1786lkcm7lsh8fhwaza0m7c09m1gb-channels.drv
building path(s) `/nix/store/x3k4shqkkns47i630hsgmvbf3lwjidnf-channels'
unpacking channel nixpkgs-unstable
scanning for references inside `/nix/store/x3k4shqkkns47i630hsgmvbf3lwjidnf-channels'
nix-channel --update  13.33s user 1.58s system 38% cpu 38.830 total
% nix-env -q '*'                                                                                                                             5451 2 pts/2 /tmp/nix-prefix meli@anuBis 11-01-28 12:04:41
% nix-env -e vim                                                                                                                             5452 2 pts/2 /tmp/nix-prefix meli@anuBis 11-01-28 12:07:21
building path(s) `/nix/store/rfgjzzg39nynvl3ydwvas5rw6glami83-user-environment'
created 0 symlinks in user environment
warning: `/tmp/nix-prefix/state/nix/profiles/default-2-link' is not in a directory where the garbage collector looks for roots; therefore, `/nix/store/rfgjzzg39nynvl3ydwvas5rw6glami83-user-environment' might be removed by the garbage collector


================== how to install: ========================
-- the normal installation into / (used in nix os) --
1. mkdir build
2. cd build
3. cmake -DCMAKE_INSTALL_PREFIX:PATH="/" ..
4. make install
5. read the nix operation manual how to use your new nix installation

-- the prefix installation into /home/myuser/nix (can be used in linux/cygwin/macosX) --
1. mkdir build
2. cd build
3. cmake -DCMAKE_INSTALL_PREFIX:PATH="/home/myuser/nix" ..
4. ccmake ..
5. make install
6. (as root): mkdir /store; chown myuser:users /store; chmod 0755 /store
7. read the nix operation manual how to use your new nix installation

HINT: you can also install your store directory to /home/myuser/nix/store but that will require you to compile
      all packages from source. you could also (assisted by an administrator) install into /store but all other
      files will be installed into '/home/myuser/nix/'.
      in step (4), simply search for OVERWRITE_DEFAULT_STORE_DIR and swich it from OFF to ON. now you have to
      create (as root) a new directory called '/store/', given the right permissions you can have a normal
      prefix installation without having to recompile the software all the time.
      NOTE: instead of using ccmake, one could also add this, in step (3): -DOVERWRITE_DEFAULT_STORE_DIR=ON 
      -> this design was chosen as it enables a normal prefix installation without being root, 
      as only stept (6) is done manually (as root user).
      NOTE: only one user per system can use the store like this, if you have a high level of trust you can
            however experiment with the multi user /store setting which requires: 'chmod 1777 /store'.
            security wise one should think about that.

  binaries are in:
    /tmp/nix-autotools/bin
    /tmp/nix-autotools/state/nix/profiles/default/bin

    symlink in ~/.nix-profile should point to /tmp/nix-prefix/state/nix/profiles/default/ (which is an empty directory)
         one could use: /tmp/nix-autotools/state/nix/profiles/default/ instead, which works

         rm ~/.nix-profile; ln -s /tmp/nix-autotools/state/nix/profiles/default/ ~/.nix-profile

================== TODO: final QualityAssurance ==================
 - check all CMakeLists.txt files for static paths which i might have forgotten
 - compare PREFIX-BUILD with PREFIX-DESTDIR-BUILD
 - there should be only one global symlink script: NIX_SYMLINK and NIX_INSTALL_EXECUTABLE_FILE

 check if all files are there, as:
 - installed headers
 - installed binaries
 - installed libraries .so
 - installed files
    state/nix/db
    state/nix/db/big-lock
    state/nix/db/failed
    state/nix/db/info
    state/nix/db/referrer
    state/nix/db/schema
 - check permissions of files
 - create directories
 - install manpages/configs
 - symlinks
    /state/nix/gcroots
       manifests -> /tmp/nix-cmake/state/nix/manifests/
       profiles -> /tmp/nix-cmake/state/nix/profiles/

 - check binaries for RPATH and if they are working
 - check CONFIGURE_FILE files (contents) for correct binaries/directories
 - do the binaries as nix-env execute?
      % ./nix-env          
      error: no operation specified
      Try `nix-env --help' for more information.

 - are scripts marked executable? example: bin/nix-pull

 see the test script, which performs some tests automatically
  - must work if:
    - out of source build aka; mkdir build; cd build; cmake ..; 
      WARNING: in source build is not tested nor supported!
    - install either with:
      - cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..; make install
      - cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..; make install DESTDIR=/tmp/foo
    - targets: must compile in windows(cygwin)/linux/mac os x
  - if the DESTDIR path is altered, say mv /mydestdirpath to /mydestdirpath123, 
    does ldd still find a working nix-env binary? can it still find the .so files?
   -> no 'yet' it can not ;P

================== required software dependencies 0.16: ==================
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

================== changelog of things already done: ==================
- NOTICE: the cmake based installation does not have to be run as root, even when the user wants to use /nix/store
          still it requires some assistance by the admin to create that directory and give it to the user
- WARNING: store/ is no longer created with 1777 but instead drwxr-xr-x 755
 -> nix DOES NOT need 1777 in /store (i've experimented with that, 
    might still be valuable for multi user nix setup BUT not for the default installation)
- WARNING: libraries are no longer installed with 'libmain.so.0', 'libmain.so.0.0', 'libmain.so.0.0.0'. also 'libmain.so.la' is missing.
- NOTICE: renamed scripts/nix-profile.sh.in into scripts/nix.sh.in (as it is installed in the autotools variant as nix.sh)
- NOTICE: the nix release version is now provided by NIX_VERSION in the main CMakeLists.txt file
- NOTICE: src/boost/shared_count.hpp was not installed in the autotools variant (cmake installs it)
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
 - NOTICE: runtime dependencies, programs like 'openssl', are queried via cmake's FIND_PROGRAM(..) for scripts in the directory 'scripts' and 'coreutils'
 - NOTICE: the NIX_SYSTEM variable (like x86_64-linux) is detected automatically using detect-system.sh