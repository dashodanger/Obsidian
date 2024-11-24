##########################################
# Nuklear
##########################################

add_library(nuklear INTERFACE)

target_include_directories(nuklear INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR})