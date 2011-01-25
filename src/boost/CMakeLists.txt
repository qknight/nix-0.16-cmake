SET(libformatSrc ${libformatSrc}
	format/format_implementation.cc
	format/free_funcs.cc
	format/parsing.cc
)



SET(libformatHeaders ${libformatHeaders}
	format/exceptions.hpp
	format/feed_args.hpp
	format/format_class.hpp
	format/format_fwd.hpp
	format/group.hpp
	format/internals.hpp
	format/internals_fwd.hpp
	format/macros_default.hpp
)

SET(boostHeaders ${libHeaders}
	assert.hpp
	checked_delete.hpp
	enable_shared_from_this.hpp
	format.hpp
	shared_ptr.hpp
	throw_exception.hpp
	weak_ptr.hpp
)

SET(detailHeaders ${libdetailHeaders}
	detail/shared_count.hpp  
	detail/workaround.hpp
)

#INCLUDE_DIRECTORIES (format)
INCLUDE_DIRECTORIES (..)
ADD_LIBRARY ( format SHARED ${libformatSrc} )

INSTALL ( TARGETS format DESTINATION "${NIX_LIB_DIR}/nix" )

INSTALL ( FILES ${libformatHeaders} DESTINATION "${NIX_INCLUDE_DIR}/nix/boost/format" )
INSTALL ( FILES ${boostHeaders} DESTINATION "${NIX_INCLUDE_DIR}/nix/boost" )
INSTALL ( FILES ${detailHeaders} DESTINATION "${NIX_INCLUDE_DIR}/nix/boost/detail" )
