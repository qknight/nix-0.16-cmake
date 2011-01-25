SET(nix-instantiateSrc ${nix-instantiateSrc}
	nix-instantiate.cc
	${CMAKE_CURRENT_BINARY_DIR}/help.txt.hh
)

INCLUDE_DIRECTORIES (..)
INCLUDE_DIRECTORIES (../..)
INCLUDE_DIRECTORIES (../libutil)
INCLUDE_DIRECTORIES (../libstore)
INCLUDE_DIRECTORIES (../libexpr)
INCLUDE_DIRECTORIES (../libmain)
INCLUDE_DIRECTORIES (${CMAKE_CURRENT_BINARY_DIR})

# ../bin2c/bin2c "helpText < help.txt > help.txt.hh"
ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/help.txt.hh
	COMMAND bin2c helpText < ${CMAKE_CURRENT_SOURCE_DIR}/help.txt > ${CMAKE_CURRENT_BINARY_DIR}/help.txt.hh
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	DEPENDS help.txt
)

# depends on previous built libs: libmain.so, libstore.so, libutil.so, libformat.so
ADD_EXECUTABLE(nix-instantiate ${nix-instantiateSrc} )
TARGET_LINK_LIBRARIES(nix-instantiate util store expr main)

INSTALL ( TARGETS nix-instantiate DESTINATION "${NIX_BIN_DIR}" )
