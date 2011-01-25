SET(libexprSrc ${libexprSrc}
	attr-path.cc
	common-opts.cc
	eval.cc
	get-drvs.cc
	lexer-tab.cc
	names.cc
	nixexpr.cc
	parser-tab.cc
	primops.cc
	value-to-xml.cc
)

SET(libexprHeaders ${libexprHeaders}
	attr-path.hh
	common-opts.hh
	eval.hh
	get-drvs.hh
	lexer-tab.hh
	names.hh
	nixexpr.hh
	parser-tab.hh
	parser.hh
	symbol-table.hh
	value-to-xml.hh
)

INCLUDE_DIRECTORIES (.)
INCLUDE_DIRECTORIES (..)
INCLUDE_DIRECTORIES (../..)
INCLUDE_DIRECTORIES (../libutil)
INCLUDE_DIRECTORIES (../libstore)

ADD_LIBRARY(expr SHARED ${libexprSrc} )
TARGET_LINK_LIBRARIES(expr store util format)

INSTALL ( TARGETS expr DESTINATION "${NIX_LIB_DIR}/nix" )

INSTALL ( FILES ${libexprHeaders} DESTINATION "${NIX_INCLUDE_DIR}/nix" )
