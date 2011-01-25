SET(nix-workerSrc ${nix-workerSrc}
	nix-worker.cc
	${CMAKE_CURRENT_BINARY_DIR}/help.txt.hh
)

INCLUDE_DIRECTORIES (.)
INCLUDE_DIRECTORIES (..)
INCLUDE_DIRECTORIES (../..)
INCLUDE_DIRECTORIES (../libutil)
INCLUDE_DIRECTORIES (../libstore)
INCLUDE_DIRECTORIES (../libmain)
INCLUDE_DIRECTORIES (../libformat)
INCLUDE_DIRECTORIES (${CMAKE_CURRENT_BINARY_DIR})

# ../bin2c/bin2c "helpText < help.txt > help.txt.hh"
ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/help.txt.hh
	COMMAND bin2c helpText < ${CMAKE_CURRENT_SOURCE_DIR}/help.txt > ${CMAKE_CURRENT_BINARY_DIR}/help.txt.hh
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	DEPENDS help.txt
)

ADD_EXECUTABLE(nix-worker ${nix-workerSrc} )
TARGET_LINK_LIBRARIES(nix-worker util store main format)

INSTALL( TARGETS nix-worker DESTINATION "${NIX_BIN_DIR}")
