SET(libstoreSrc ${libstoreSrc}
	build.cc
	derivations.cc
	gc.cc
	globals.cc
	local-store.cc
	misc.cc
	optimise-store.cc
	pathlocks.cc
	references.cc
	remote-store.cc
	store-api.cc
)

SET(libstoreHeaders ${libstoreheaders}
	derivations.hh
	globals.hh
	local-store.hh
	misc.hh
	pathlocks.hh
	references.hh
	remote-store.hh
	store-api.hh
	worker-protocol.hh
)

add_definitions(
	-DOPENSSL_PATH="${NIX_OPENSSL_PATH}"
)


INCLUDE_DIRECTORIES (${CMAKE_BINARY_DIR})
INCLUDE_DIRECTORIES (.)
INCLUDE_DIRECTORIES (..)
INCLUDE_DIRECTORIES (../..)
INCLUDE_DIRECTORIES (../libutil)

ADD_LIBRARY ( store SHARED ${libstoreSrc} )

INSTALL( TARGETS store DESTINATION "${NIX_LIB_DIR}/nix" )

INSTALL( FILES ${libstoreHeaders} DESTINATION "${NIX_INCLUDE_DIR}/nix" )

