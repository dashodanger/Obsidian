##########################################
# minilua
##########################################

add_library(minilua minilua.c)

target_include_directories(minilua PUBLIC ./)