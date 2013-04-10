project(kde-user-units)

FIND_PACKAGE(KDE4 REQUIRED)

FILE(GLOB systemd_services *.service *.target)
FILE(GLOB systemd_services_in *.service.in)

SET(inFiles
    kdeinit.service
    ksmserver.service
    lnusertemp@.service
    )

# FindKDE4Internal defines KDE4_LIBEXEC_INSTALL_DIR
# which is used by configure_file to set the right paths

FOREACH(infileName ${inFiles})
    MESSAGE(STATUS "Processing file: ${infileName}")

    configure_file(${infileName}.in "${CMAKE_CURRENT_BINARY_DIR}/${infileName}" @ONLY)

    install(
        FILES "${CMAKE_CURRENT_BINARY_DIR}/${infileName}"
        DESTINATION ${LIB_INSTALL_DIR}/systemd/user/
        )
ENDFOREACH(infileName)

install(
    FILES ${systemd_services}
    DESTINATION ${LIB_INSTALL_DIR}/systemd/user/
)


