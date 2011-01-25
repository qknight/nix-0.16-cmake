# grep -h "@[a-z,0-9]*@" -o -R * | sort | uniq
SET(bindir ${NIX_BIN_DIR})

# FIXME: need to use scripts to fill these
SET(bunzip2 "/bin/bunzip2")
SET(bzip2 "/bin/bzip2")
SET(coreutils "/usr/bin")
SET(perl "/usr/bin/perl")
SET(shell "/bin/bash")
SET(tar "/bin/tar")
SET(tr "/usr/bin/tr")

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

