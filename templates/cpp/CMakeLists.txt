cmake_minimum_required(VERSION 3.25.3)

############################
#         COMPILER         #
############################

# When on windows, VS sets this value itself
if (UNIX)
	set(CMAKE_BUILD_TYPE "Debug")
endif(UNIX)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

############################
#       DEPENDENCIES       #
############################

# Import this cmake module
include(FetchContent)

# This only affects dependencies
add_compile_options(-Wno-everything)

# Fetch fmt
message("Fetching fmt")
FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt
    GIT_TAG 10.0.0
)
FetchContent_MakeAvailable(fmt)

############################
#         PROJECT          #
############################

# Set project compiler options
add_compile_options(-Wall -Wextra -Wpedantic)

# Setup the project
project(newProject)
file(GLOB SOURCES src/*.cpp)
add_executable(${PROJECT_NAME} ${SOURCES})

# Link required libraries
target_link_libraries(${PROJECT_NAME} fmt)

# Symlink compile_commands to root dir
if (UNIX)
	file(CREATE_LINK
		"${CMAKE_BINARY_DIR}/compile_commands.json"
		"${CMAKE_SOURCE_DIR}/compile_commands.json"
		SYMBOLIC
	)
endif(UNIX)

