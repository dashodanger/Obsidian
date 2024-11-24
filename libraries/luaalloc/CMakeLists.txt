##########################################
# luaalloc
##########################################

add_library(
  luaalloc
  luaalloc.c 
  )

target_include_directories(luaalloc PUBLIC ./)
