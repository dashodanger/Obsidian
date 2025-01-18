##########################################
# moonnuklear
##########################################

add_library(
  moonnuklear
  src/atlas.c
  src/buffer.c
  src/canvas.c
  src/compat-5.3.c
  src/context.c
  src/cursor.c
  src/edit.c
  src/enums.c
  src/flags.c
  src/font.c
  src/image.c
  src/input.c
  src/layout.c
  src/main.c
  src/nine_slice.c
  src/objects.c
  src/panel.c
  src/structs.c
  src/style.c
  src/tracing.c
  src/udata.c
  src/utils.c
  src/versions.c
  src/widgets.c
  src/window.c
  )

target_link_libraries(moonnuklear PRIVATE minilua nuklear)

target_include_directories(moonnuklear PUBLIC ./src)
