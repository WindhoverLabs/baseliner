include(../set-vars.cmake)

# Put target specific functions here.  This is where we build most everything.  Everything that either uses the
# cross toolchain or has target independent functions.

buildliner_initialize(
    PSP ${PSP}

    OSAL ${OSAL}

    CORE_TOOLS ${CMAKE_CURRENT_SOURCE_DIR}/tools

    CONFIG
        ${CMAKE_CURRENT_SOURCE_DIR}/inc
        ${CMAKE_CURRENT_SOURCE_DIR}/../inc
        ${CMAKE_CURRENT_SOURCE_DIR}/../../../shared/inc

    FILESYS
        /cf/apps
        /cf/log
        /cf/downlink/ch0/poll0
        /cf/downlink/ch0/poll1
        /cf/downlink/ch0/poll2
        /cf/downlink/ch0/poll3
        /cf/downlink/ch0/poll4
        /cf/downlink/ch0/poll5
        /cf/downlink/ch0/poll6
        /cf/downlink/ch0/poll7
        /cf/downlink/ch1/poll0
        /cf/downlink/ch1/poll1
        /cf/downlink/ch1/poll2
        /cf/downlink/ch1/poll3
        /cf/downlink/ch1/poll4
        /cf/downlink/ch1/poll5
        /cf/downlink/ch1/poll6
        /cf/downlink/ch1/poll7
        /cf/upload
        /ram

    STARTUP_SCRIPT
        ${CMAKE_CURRENT_SOURCE_DIR}/cfe_es_startup.scr
)


buildliner_add_app(
    cfs_lib
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/cfs_lib/fsw/for_build
)

buildliner_add_app(
    sch
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/sch/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/sch
    CONFIG_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/apps/sch/sch_custom.c
)

buildliner_add_app(
    cf
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/cf/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/cf
)

buildliner_add_app(
    cs
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/cs/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/cs
)

buildliner_add_app(
    ds
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/ds/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/ds
)

buildliner_add_app(
    fm
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/fm/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/fm
)

buildliner_add_app(
    hk
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/hk/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/hk
)

buildliner_add_app(
    hs
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/hs/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/hs
    CONFIG_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/apps/hs/hs_custom.c
)

buildliner_add_app(
    lc
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/lc/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/lc
    CONFIG_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/apps/lc/src/lc_custom.c
)

buildliner_add_app(
    md
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/md/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/md
)

buildliner_add_app(
    mm
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/mm/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/mm
)

buildliner_add_app(
    sc
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/sc/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/sc
)

buildliner_add_app(
    ci
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/ci/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/ci
    CONFIG_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/apps/ci/ci_custom.c
)

buildliner_add_app(
    to
    DEFINITION ${PROJECT_SOURCE_DIR}/apps/to/fsw/for_build
    CONFIG     ${CMAKE_CURRENT_SOURCE_DIR}/apps/to
    CONFIG_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/apps/to/tables/to_backup_cfg.c
        ${CMAKE_CURRENT_SOURCE_DIR}/apps/to/to_custom.c
)
