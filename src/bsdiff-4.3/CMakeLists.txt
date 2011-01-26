FIND_LIBRARY(BZIP2_LIBRARIES NAMES bz2 bzip2)
if(NOT BZIP2_LIBRARIES)
	# Do an other trial
        FIND_FILE(BZIP2_LIBRARIES NAMES libbz2.so.1 PATHS /lib)
	message(STATUS "no bzip2 library found. 'app-arch/bzip2' is what i was searching: might work best with bzip2 version 1.0.5-r1")
endif()

ADD_EXECUTABLE(bsdiff bsdiff.c)
TARGET_LINK_LIBRARIES(bsdiff ${BZIP2_LIBRARIES})

ADD_EXECUTABLE(bspatch bspatch.c)
TARGET_LINK_LIBRARIES(bspatch ${BZIP2_LIBRARIES})

INSTALL( TARGETS bsdiff DESTINATION "${NIX_LIBEXEC_DIR}")
INSTALL( TARGETS bspatch DESTINATION "${NIX_LIBEXEC_DIR}")
