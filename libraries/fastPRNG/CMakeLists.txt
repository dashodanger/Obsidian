##########################################
# fastPRNG
##########################################

add_library(fastPRNG INTERFACE)

target_include_directories(fastPRNG INTERFACE
  ${CMAKE_CURRENT_SOURCE_DIR})