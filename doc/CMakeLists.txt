INSTALL(FILES "manual/manual.html" DESTINATION "${NIX_DATA_DIR}/doc/nix/manual/")

macro(NIX_SYMLINK FILE LINK)
        INSTALL(CODE "EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E create_symlink
              \"${CMAKE_INSTALL_PREFIX}/${FILE}\"
              \"${CMAKE_INSTALL_PREFIX}/${LINK}\")"
        )
endmacro(NIX_SYMLINK)

NIX_SYMLINK("${NIX_DATA_DIR}/doc/nix/manual/manual.html" "${NIX_DATA_DIR}/doc/nix/manual/index.html")

INSTALL(FILES "manual/style.css" DESTINATION "${NIX_DATA_DIR}/doc/nix/manual")
INSTALL(FILES "manual/figures/user-environments.png" DESTINATION "${NIX_DATA_DIR}/doc/nix/manual/figures")

INSTALL(DIRECTORY "manual/figures" DESTINATION "${NIX_DATA_DIR}/doc/nix/manual")
INSTALL(DIRECTORY "manual/images" DESTINATION "${NIX_DATA_DIR}/doc/nix/manual")

INSTALL(FILES "manual/NEWS.html" DESTINATION "${NIX_DATA_DIR}/doc/nix/release-notes")
INSTALL(FILES "manual/style.css" DESTINATION "${NIX_DATA_DIR}/doc/nix/release-notes")

INSTALL(FILES "manual/nix-build.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-channel.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-collect-garbage.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-copy-closure.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-env.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-hash.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-install-package.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-instantiate.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-prefetch-url.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-pull.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-push.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")
INSTALL(FILES "manual/nix-store.1" DESTINATION "${NIX_DATA_DIR}/man/man1/")

INSTALL(FILES "manual/nix-worker.8" DESTINATION "${NIX_DATA_DIR}/man/man8/")
