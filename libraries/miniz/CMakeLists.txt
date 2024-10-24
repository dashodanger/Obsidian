##########################################
# miniz
##########################################

add_library(
  miniz
  miniz.c 
  )

target_include_directories(miniz PUBLIC ./)
