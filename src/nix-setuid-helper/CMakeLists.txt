SET(nix-setuid-helperSrc ${nix-setuid-helperSrc}
	nix-setuid-helper.cc
)

INCLUDE_DIRECTORIES (${CMAKE_BINARY_DIR})
INCLUDE_DIRECTORIES (..)
INCLUDE_DIRECTORIES (../..)
INCLUDE_DIRECTORIES (../libutil)
INCLUDE_DIRECTORIES (../libformat)

ADD_EXECUTABLE(nix-setuid-helper ${nix-setuid-helperSrc} )
TARGET_LINK_LIBRARIES(nix-setuid-helper util format)

INSTALL( TARGETS nix-setuid-helper DESTINATION "${NIX_LIBEXEC_DIR}")
