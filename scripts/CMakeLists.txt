# FIXME: need to use scripts to fill these
# grep -h "@[a-z,0-9]*@" -o * | sort | uniq 
SET(bindir "${NIX_BIN_DIR}")
SET(libexecdir "${NIX_LIBEXEC_DIR}")
SET(localstatedir "${NIX_STATE_DIR}")
SET(storedir "${NIX_STORE_DIR}")
SET(sysconfigdir "${NIX_CONF_DIR}")
SET(datadir "${NIX_DATA_DIR}")
SET(system ${NIX_SYSTEM})

SET(bunzip2 "/bin/bunzip2")
SET(bzip2 "/bin/bzip2")

SET(coreutils "/usr/bin")
SET(curl "/usr/bin/curl")
SET(gzip "/bin/gzip")
SET(perl "/usr/bin/perl")
SET(sed "/bin/sed")
SET(shell "/bin/bash")

MACRO(NIX_CONFIGURE_FILE FILE)
	CONFIGURE_FILE("${FILE}.in" "${FILE}" @ONLY)
ENDMACRO(NIX_CONFIGURE_FILE)

NIX_CONFIGURE_FILE("nix-collect-garbage")
NIX_CONFIGURE_FILE("nix-pull")
NIX_CONFIGURE_FILE("nix-push")
NIX_CONFIGURE_FILE("nix-prefetch-url")
NIX_CONFIGURE_FILE("nix-install-package")
NIX_CONFIGURE_FILE("nix-channel")
NIX_CONFIGURE_FILE("nix-build")
NIX_CONFIGURE_FILE("nix-copy-closure")
NIX_CONFIGURE_FILE("nix.sh")
NIX_CONFIGURE_FILE("readmanifest.pm")
NIX_CONFIGURE_FILE("readconfig.pm")
NIX_CONFIGURE_FILE("find-runtime-roots.pl")
NIX_CONFIGURE_FILE("generate-patches.pl")
NIX_CONFIGURE_FILE("build-remote.pl")
NIX_CONFIGURE_FILE("download-using-manifests.pl")
NIX_CONFIGURE_FILE("copy-from-other-stores.pl")

MACRO(NIX_INSTALL_FILE NIX_FILE NIX_DESTINATION)
	INSTALL(FILES "${CMAKE_CURRENT_BINARY_DIR}/${NIX_FILE}" DESTINATION "${NIX_DESTINATION}")
ENDMACRO(NIX_INSTALL_FILE)

NIX_INSTALL_FILE("nix-collect-garbage" "${NIX_BIN_DIR}")
NIX_INSTALL_FILE("nix-collect-garbage" "${NIX_BIN_DIR}")
NIX_INSTALL_FILE("nix-pull" "${NIX_BIN_DIR}")
NIX_INSTALL_FILE("nix-push" "${NIX_BIN_DIR}")
NIX_INSTALL_FILE("nix-prefetch-url" "${NIX_BIN_DIR}")
NIX_INSTALL_FILE("nix-install-package" "${NIX_BIN_DIR}")
NIX_INSTALL_FILE("nix-channel" "${NIX_BIN_DIR}")
NIX_INSTALL_FILE("nix-build" "${NIX_BIN_DIR}")
NIX_INSTALL_FILE("nix-copy-closure" "${NIX_BIN_DIR}")

NIX_INSTALL_FILE("nix.sh" "${NIX_CONF_DIR}/profile.d/")

NIX_INSTALL_FILE("readmanifest.pm" "${NIX_LIBEXEC_DIR}/nix")
NIX_INSTALL_FILE("readconfig.pm" "${NIX_LIBEXEC_DIR}/nix")
NIX_INSTALL_FILE("find-runtime-roots.pl" "${NIX_LIBEXEC_DIR}/nix")
NIX_INSTALL_FILE("generate-patches.pl" "${NIX_LIBEXEC_DIR}/nix")
NIX_INSTALL_FILE("build-remote.pl" "${NIX_LIBEXEC_DIR}/nix")

NIX_INSTALL_FILE("download-using-manifests.pl" "${NIX_LIBEXEC_DIR}/nix/substituters")
NIX_INSTALL_FILE("copy-from-other-stores.pl" "${NIX_LIBEXEC_DIR}/nix/substituters")

INSTALL(FILES "ssh.pm" DESTINATION "${NIX_LIBEXEC_DIR}/nix")

