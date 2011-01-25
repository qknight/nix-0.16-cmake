SET(nix-log2xmlSrc ${nix-log2xmlSrc}
	log2xml.cc
)

ADD_EXECUTABLE(nix-log2xml ${nix-log2xmlSrc} )

INSTALL(TARGETS nix-log2xml DESTINATION "${NIX_BIN_DIR}" )

INSTALL(FILES "log2html.xsl" DESTINATION "${NIX_DATA_DIR}/nix/log2html" )
INSTALL(FILES "mark-errors.xsl" DESTINATION "${NIX_DATA_DIR}/nix/log2html" )
INSTALL(FILES "treebits.js" DESTINATION "${NIX_DATA_DIR}/nix/log2html" )

