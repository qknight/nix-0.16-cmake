SET(libutilSrc ${libutilSrc}
	md5.c
	sha1.c
	sha256.c
	archive.cc
	hash.cc
	serialise.cc
	util.cc
	xml-writer.cc
)

SET(libutilsHeaders ${libutilHeaders}
	archive.hh
	hash.hh
	serialise.hh
	types.hh
	util.hh
	xml-writer.hh
)

INCLUDE_DIRECTORIES (${CMAKE_BINARY_DIR})
INCLUDE_DIRECTORIES (..)
INCLUDE_DIRECTORIES (../..)

ADD_LIBRARY ( util SHARED ${libutilSrc} )

INSTALL( TARGETS util DESTINATION "${NIX_LIB_DIR}/nix" )

INSTALL( FILES ${libutilsHeaders} DESTINATION "${NIX_INCLUDE_DIR}/nix" )

