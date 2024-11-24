cmake_minimum_required(VERSION 3.12..3.20)

project(
  obsidian
  LANGUAGES C CXX
  VERSION 0.1.0
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(OBSIDIAN_GUI ON)

if(OBSIDIAN_GUI)
  add_compile_definitions(OBSIDIAN_ENABLE_GUI=1)
endif()

string(TIMESTAMP BUILD_TIMESTAMP "%Y.%m.%d" UTC)
add_compile_definitions(OBSIDIAN_TIMESTAMP="${BUILD_TIMESTAMP}")

if(MSVC)
  # These are needed for MSVC to play ball as much as possible
  # with the /EHs- flag
  add_definitions("-D_HAS_EXCEPTIONS=0 -D_STATIC_CPPLIB")

  # get the number of logical cores for parallel build
  cmake_host_system_information(RESULT LOGICAL_CORES QUERY NUMBER_OF_LOGICAL_CORES)
  math(EXPR COMPILE_CORES "${LOGICAL_CORES} - 1")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /fp:fast /EHs- /GR- /MP${COMPILE_CORES}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /fp:fast /EHs- /GR- /MP${COMPILE_CORES}")
  # For now, keep the console flag while fleshing out the GUI, later on pick properly
  set(CMAKE_EXE_LINKER_FLAGS "/SUBSYSTEM:CONSOLE")
else()
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-exceptions -fno-strict-aliasing")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions -fno-rtti -fno-strict-aliasing")
endif()
if(MSYS OR MINGW)
  set(CMAKE_EXE_LINKER_FLAGS "-static")
endif()
if(APPLE OR ${CMAKE_SYSTEM} MATCHES "BSD")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I /usr/local/include")
endif()

add_subdirectory(libraries)

set(OBSIDIAN_SOURCE_FILES
    source/bsp_level.cc
    source/bsp_misc.cc
    source/bsp_node.cc
    source/bsp_wad.cc
    source/bsp.cc
    source/csg_bsp.cc
    source/csg_doom.cc
    source/csg_main.cc
    source/csg_shade.cc
    source/csg_spots.cc
    source/dm_extra.cc
    source/dm_prefab.cc
    source/ff_main.cc
    source/g_doom.cc
    source/g_wolf.cc
    source/lex.yy.c
    source/lib_argv.cc
    source/lib_midi.cc
    source/lib_tga.cc
    source/lib_util.cc
    source/lib_wad.cc
    source/lib_zip.cc
    source/lib_parse.cc
    source/m_addons.cc
    source/m_cookie.cc
    source/m_lua.cc
    source/m_options.cc
    source/m_trans.cc
    source/main.cc
    source/poly_map.cc
    source/poly.cc
    source/poly_util.cc
    source/poly_wad.cc
    source/slump_dump.cc
    source/slump_main.cc
    source/slump.cc
    source/sys_assert.cc
    source/sys_debug.cc
    source/sys_xoshiro.cc
    source/tx_forge.cc
    source/tx_skies.cc
)

if (WIN32)
  set(OBSIDIAN_SOURCE_FILES
    ${OBSIDIAN_SOURCE_FILES}
    source/obsidian.rc
  )
endif()

add_executable(
  obsidian
  ${OBSIDIAN_SOURCE_FILES}
)

# Copies executables to local install directory after build
set(COPY_FILES "")

set (DEST_DIR "${CMAKE_SOURCE_DIR}")
list(APPEND COPY_FILES "$<TARGET_FILE:obsidian>")

if (COPY_FILES)
  add_custom_command(TARGET obsidian POST_BUILD COMMAND_EXPAND_LISTS COMMAND ${CMAKE_COMMAND} -E copy_if_different ${COPY_FILES} ${DEST_DIR})
endif()

set(OBSIDIAN_LINK_LIBRARIES fastPRNG luaalloc minilua miniz physfs-static steve)

if (UNIX AND NOT APPLE AND NOT ${CMAKE_SYSTEM} MATCHES "BSD")
  set(OBSIDIAN_LINK_LIBRARIES ${OBSIDIAN_LINK_LIBRARIES} pthread)
endif()

if (OBSIDIAN_GUI)
  set(OBSIDIAN_LINK_LIBRARIES ${OBSIDIAN_LINK_LIBRARIES} SDL3::Headers SDL3::SDL3-static moonnuklear nuklear)
endif()

target_link_libraries(obsidian PRIVATE ${OBSIDIAN_LINK_LIBRARIES})