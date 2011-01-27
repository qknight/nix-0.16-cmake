# grep -h "@[a-z,0-9]*@" -o -R * | sort | uniq
SET(bindir 	"${NIX_BIN_DIR}")
SET(bunzip2     "${NIX_BUNZIP2_PATH}")
SET(bzip2       "${NIX_BZIP2_PATH}")
SET(coreutils   "${NIX_COREUTILS_PATH}")
SET(perl        "${NIX_PERL_PATH}")
SET(shell       "${NIX_SHELL_PATH}")
SET(tar 	"${NIX_TAR_PATH}")
SET(tr 		"${NIX_TR_PATh}")

MACRO(NIX_CONFIGURE_FILE FILE)
        CONFIGURE_FILE("${FILE}.in" "${FILE}" @ONLY)
ENDMACRO(NIX_CONFIGURE_FILE)

MACRO(NIX_INSTALL_FILE NIX_FILE NIX_DESTINATION)
        INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/${NIX_FILE}" DESTINATION "${NIX_DESTINATION}")
ENDMACRO(NIX_INSTALL_FILE)

INSTALL(FILES "buildenv/default.nix" DESTINATION "${NIX_DATA_DIR}/nix/corepkgs/buildenv")
NIX_CONFIGURE_FILE("buildenv/builder.pl")
NIX_INSTALL_FILE("buildenv/builder.pl" "${NIX_DATA_DIR}/nix/corepkgs/buildenv")

INSTALL(FILES "channels/unpack.nix" DESTINATION "${NIX_DATA_DIR}/nix/corepkgs/channels")
NIX_CONFIGURE_FILE("channels/unpack.sh")
NIX_INSTALL_FILE("channels/unpack.sh" "${NIX_DATA_DIR}/nix/corepkgs/channels")

INSTALL(FILES "nar/nar.nix" DESTINATION "${NIX_DATA_DIR}/nix/corepkgs/nar" )
NIX_CONFIGURE_FILE("nar/nar.sh")
NIX_INSTALL_FILE("nar/nar.sh" "${NIX_DATA_DIR}/nix/corepkgs/nar")

