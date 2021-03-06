cmake_minimum_required(VERSION 2.8)

SET(PROJECT_NAME nix)
SET(NIX_VERSION 	"0.16" )

OPTION(OVERWRITE_DEFAULT_STORE_DIR "In case you want to install the 'store' directory to '/nix/store' instead of {CMAKE_INSTALL_PREFIX}/nix/store' set this value to ON. In case you are installing into / anyway, use the default value" "OFF")

IF(OVERWRITE_DEFAULT_STORE_DIR)
	SET(NIX_STORE_DIR	"/nix/store")
ELSE(OVERWRITE_DEFAULT_STORE_DIR)
	SET(NIX_STORE_DIR 	"${CMAKE_INSTALL_PREFIX}/nix/store" )
ENDIF(OVERWRITE_DEFAULT_STORE_DIR)

SET(NIX_DATA_DIR 	"share" )
SET(NIX_STATE_DIR 	"state" )
SET(NIX_LOG_DIR 	"${NIX_STATE_DIR}/log/nix" )
SET(NIX_CONF_DIR 	"etc" )
SET(NIX_LIBEXEC_DIR 	"libexec" )
SET(NIX_BIN_DIR 	"bin" )
SET(NIX_LIB_DIR		"lib" )
SET(NIX_INCLUDE_DIR	"include" )

EXECUTE_PROCESS( WORKING_DIRECTORY ${CMAKE_SOURCE_DIR} COMMAND /bin/bash detect-system.sh RESULT_VARIABLE NIX_DETECT_SYSTEM OUTPUT_VARIABLE NIX_SYSTEM )
IF (NOT ${NIX_DETECT_SYSTEM} EQUAL "0")
	MESSAGE(FATAL_ERROR "Could not determine the NIX_SYSTEM variable executing detect-system.sh")
ENDIF (NOT ${NIX_DETECT_SYSTEM} EQUAL "0")

# required external programs (for runtime of nix, not buildtime)
FIND_PROGRAM(NIX_OPENSSL_PATH openssl
  PATHS /usr/bin/ /bin ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_OPENSSL_PATH)
  message(FATAL_ERROR "Could not find 'openssl' command. 'dev-libs/openssl' contains this program.")
endif(NOT NIX_OPENSSL_PATH)

FIND_PROGRAM(NIX_SHELL_PATH bash
  PATHS /bin /usr/bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_SHELL_PATH)
  message(FATAL_ERROR "Could not find 'bash' command. 'app-shells/bash' contains this program.")
endif(NOT NIX_SHELL_PATH)

FIND_PROGRAM(NIX_PERL_PATH perl
  PATHS /bin /usr/bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_PERL_PATH)
  message(FATAL_ERROR "Could not find 'perl' command. 'dev-lang/perl' contains this program.")
endif(NOT NIX_PERL_PATH)

FIND_PROGRAM(NIX_BUNZIP2_PATH bunzip2
  PATHS /bin /usr/bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_BUNZIP2_PATH)
  message(FATAL_ERROR "Could not find 'bunzip2' command. 'app-arch/bzip2' contains this program.")
endif(NOT NIX_BUNZIP2_PATH)

FIND_PROGRAM(NIX_BZIP2_PATH bzip2
  PATHS /bin /usr/bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_BZIP2_PATH)
  message(FATAL_ERROR "Could not find 'bzip2' command. 'app-arch/bzip2' contains this program.")
endif(NOT NIX_BZIP2_PATH)

FIND_PROGRAM(NIX_CURL_PATH curl
  PATHS /usr/bin /bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_CURL_PATH)
  message(FATAL_ERROR "Could not find 'curl' command. 'net-misc/curl' contains this program.")
endif(NOT NIX_CURL_PATH)

FIND_PROGRAM(NIX_GZIP_PATH gzip
  PATHS /bin /usr/bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_GZIP_PATH)
  message(FATAL_ERROR "Could not find 'gzip' command. 'app-arch/gzip' contains this program.")
endif(NOT NIX_GZIP_PATH)

FIND_PROGRAM(NIX_SED_PATH sed
  PATHS /bin /usr/bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_SED_PATH)
  message(FATAL_ERROR "Could not find 'sed' command. 'sys-apps/sed' contains this program.")
endif(NOT NIX_SED_PATH)

FIND_PROGRAM(NIX_TAR_PATH tar
  PATHS /bin /usr/bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_TAR_PATH)
  message(FATAL_ERROR "Could not find 'tar' command. 'app-arch/tar' contains this program.")
endif(NOT NIX_TAR_PATH)

FIND_PROGRAM(NIX_TR_PATH tr
  PATHS /bin /usr/bin/ ENV PATH NO_DEFAULT_PATH
)
if(NOT NIX_TR_PATH)
  message(FATAL_ERROR "Could not find 'tr' command. 'sys-apps/coreutils' contains this program.")
endif(NOT NIX_TR_PATH)

# FIXME a constant is not good here
SET (NIX_COREUTILS_PATH "/bin")

# could be removed upstream (as it is not used in the cmake build)
CONFIGURE_FILE("config.h.in" "config.h" @only)

# use, i.e. don't skip the full RPATH for the build tree
SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 

# the RPATH to be used when installing
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${NIX_LIB_DIR}/nix")

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(doc)
ADD_SUBDIRECTORY(misc)
ADD_SUBDIRECTORY(corepkgs)
ADD_SUBDIRECTORY(scripts)

macro(NIX_CREATEDIR DIR)
	INSTALL(CODE "FILE(MAKE_DIRECTORY \$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/${DIR})")
endmacro(NIX_CREATEDIR) 

NIX_CREATEDIR("${NIX_LIBEXEC_DIR}/nix")
NIX_CREATEDIR("${NIX_LIBEXEC_DIR}/nix/substituters")

NIX_CREATEDIR("${NIX_DATA_DIR}/nix/log2html")
NIX_CREATEDIR("${NIX_DATA_DIR}/nix/corepkgs")
NIX_CREATEDIR("${NIX_DATA_DIR}/nix/corepkgs/nar")
NIX_CREATEDIR("${NIX_DATA_DIR}/nix/corepkgs")
NIX_CREATEDIR("${NIX_DATA_DIR}/nix/corepkgs/buildenv")
NIX_CREATEDIR("${NIX_DATA_DIR}/nix/corepkgs")
NIX_CREATEDIR("${NIX_DATA_DIR}/nix/corepkgs/channels")
NIX_CREATEDIR("${NIX_DATA_DIR}/doc/nix/manual")
NIX_CREATEDIR("${NIX_DATA_DIR}/doc/nix/manual/figures")
NIX_CREATEDIR("${NIX_DATA_DIR}/doc/nix/release-notes")
NIX_CREATEDIR("${NIX_DATA_DIR}/emacs/site-lisp")
NIX_CREATEDIR("${NIX_DATA_DIR}/doc/nix")

NIX_CREATEDIR("${NIX_CONF_DIR}/profile.d")
NIX_CREATEDIR("${NIX_CONF_DIR}/nix")

NIX_CREATEDIR("${NIX_STATE_DIR}/nix")
NIX_CREATEDIR("${NIX_STATE_DIR}/nix/db")
NIX_CREATEDIR("${NIX_STATE_DIR}/log/nix")
NIX_CREATEDIR("${NIX_STATE_DIR}/log/nix/drvs")
NIX_CREATEDIR("${NIX_STATE_DIR}/nix/profiles")
NIX_CREATEDIR("${NIX_STATE_DIR}/nix/gcroots")
NIX_CREATEDIR("${NIX_STATE_DIR}/nix/temproots")
NIX_CREATEDIR("${NIX_STATE_DIR}/nix/userpool")
NIX_CREATEDIR("${NIX_STATE_DIR}/nix/manifests")

IF(NOT OVERWRITE_DEFAULT_STORE_DIR)
	NIX_CREATEDIR("${NIX_STORE_DIR}")
ENDIF(NOT OVERWRITE_DEFAULT_STORE_DIR)

macro(NIX_SYMLINK FILE LINK)
	INSTALL(CODE "EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E create_symlink
	      \"\$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/${FILE}\"
	      \"\$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/${LINK}\")"
	)
endmacro(NIX_SYMLINK) 

NIX_SYMLINK("${NIX_STATE_DIR}/nix/profiles"  "${NIX_STATE_DIR}/nix/gcroots/profiles")
NIX_SYMLINK("${NIX_STATE_DIR}/nix/manifests" "${NIX_STATE_DIR}/nix/gcroots/manifests")

INSTALL(FILES "nix.conf.example" DESTINATION "${NIX_CONF_DIR}/nix")
# FIXME need to do this properly
IF(NOT EXISTS "${CMAKE_INSTALL_PREFIX}/${NIX_CONF_DIR}/nix/nix.conf")
	INSTALL( CODE "
		FILE(RENAME \"${CMAKE_INSTALL_PREFIX}/${NIX_CONF_DIR}/nix/nix.conf.example\" \"${CMAKE_INSTALL_PREFIX}/${NIX_CONF_DIR}/nix/nix.conf\")
		" )
	INSTALL(FILES "nix.conf.example" DESTINATION "${NIX_CONF_DIR}/nix")
ENDIF(NOT EXISTS "${CMAKE_INSTALL_PREFIX}/${NIX_CONF_DIR}/nix/nix.conf")

INSTALL(FILES README DESTINATION "${NIX_DATA_DIR}/doc/nix")
