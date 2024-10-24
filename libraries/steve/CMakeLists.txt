##########################################
# steve
##########################################

project(steve)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

file(GLOB_RECURSE SOURCES src/*.cpp src/*.h)

add_library(steve ${SOURCES})

target_include_directories(steve PUBLIC ./src)