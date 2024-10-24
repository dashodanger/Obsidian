cmake_minimum_required(VERSION 3.12..3.20)

project(
  obsidian
  LANGUAGES C CXX
  VERSION 0.1.0
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

string(TIMESTAMP BUILD_TIMESTAMP "%Y.%m.%d" UTC)
add_compile_definitions(OBSIDIAN_TIMESTAMP="${BUILD_TIMESTAMP}")
if(CONSOLE_ONLY)
  add_compile_definitions(OBSIDIAN_CONSOLE_ONLY)
endif()
if(NOT WIN32 AND NOT APPLE AND NOT CONSOLE_ONLY)
  add_compile_definitions(USE_XFT)
endif()
if(MSVC)
  # get the number of logical cores for parallel build
  cmake_host_system_information(RESULT LOGICAL_CORES QUERY NUMBER_OF_LOGICAL_CORES)
  math(EXPR COMPILE_CORES "${LOGICAL_CORES} - 1")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MD /MP${COMPILE_CORES}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MD /EHa /MP${COMPILE_CORES}")
  if(NOT CONSOLE_ONLY)
    set(CMAKE_EXE_LINKER_FLAGS "/SUBSYSTEM:WINDOWS")
  endif()
endif()
if(MSYS OR MINGW)
  if(NOT CONSOLE_ONLY)
    set(CMAKE_EXE_LINKER_FLAGS "-static -mwindows")
  else()
    set(CMAKE_EXE_LINKER_FLAGS "-static")
  endif()
endif()
if(APPLE OR ${CMAKE_SYSTEM} MATCHES "BSD")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I /usr/local/include")
endif()
if(${CMAKE_SYSTEM} MATCHES "OpenBSD")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -I /usr/X11R6/include")
endif()

if(UNIX)
  if(NOT CONSOLE_ONLY
     AND NOT APPLE
  )
    find_package(Fontconfig REQUIRED)
  endif()
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

if (NOT CONSOLE_ONLY)
  set(OBSIDIAN_SOURCE_FILES
    ${OBSIDIAN_SOURCE_FILES}
    source/m_about.cc
    source/m_dialog.cc
    source/m_manage.cc
    source/m_theme.cc
    source/ui_boxes.cc
    source/ui_build.cc
    source/ui_game.cc
    source/ui_hyper.cc
    source/ui_map.cc
    source/ui_module.cc
    source/ui_widgets.cc
    source/ui_window.cc
  )
endif()

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
add_custom_command(
  TARGET obsidian
  POST_BUILD
  COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_FILE:obsidian>"
          "${CMAKE_CURRENT_LIST_DIR}"
)

if(UNIX)
  if(APPLE)
    if(NOT CONSOLE_ONLY)
      target_link_libraries(
        obsidian
        PRIVATE fastPRNG
                fltk
                fltk_images
                minilua
                miniz
                physfs-static
                steve
                "-framework Cocoa"
                "-framework CoreGraphics"
                "-framework CoreText"
                "-framework QuartzCore"
      )
    else()
      target_link_libraries(
        obsidian PRIVATE fastPRNG minilua miniz physfs-static steve
      )
    endif()
  elseif(${CMAKE_SYSTEM} MATCHES "BSD")
    if(NOT CONSOLE_ONLY)
      target_link_libraries(
        obsidian
        PRIVATE fastPRNG
                fltk
                fltk_images
                minilua
                miniz
                physfs-static
                steve
      )
    else()
      target_link_libraries(
        obsidian PRIVATE fastPRNG minilua miniz physfs-static steve
      )
    endif()
  else()
    if(NOT CONSOLE_ONLY)
      target_link_libraries(
        obsidian
        PRIVATE fastPRNG
                fltk
                fltk_images
                minilua
                miniz
                physfs-static
                fontconfig
                pthread
                steve
      )
    else()
      target_link_libraries(
        obsidian
        PRIVATE fastPRNG
                minilua
                miniz
                physfs-static
                pthread
                steve
      )
    endif()
  endif()
else()
  if(NOT CONSOLE_ONLY)
    target_link_libraries(
      obsidian
      PRIVATE fastPRNG
              fltk
              fltk_images
              minilua
              miniz
              physfs-static
              steve
    )
  else()
    target_link_libraries(
      obsidian PRIVATE fastPRNG minilua miniz physfs-static steve
    )
  endif()
endif()