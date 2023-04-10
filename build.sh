#!/bin/bash

# Create build directory if it doesn't exist
if [ ! -d "./build" ]; then
    mkdir build
fi

# Navigate to build directory
cd build

while [[ $# -gt 0 ]]; do
    case "$1" in
        -debug)
            build_type="Debug"
            shift
            ;;
        -clean)
            echo "Cleaning build directory"
            rm -rf ./*
            shift
            ;;
    esac
done

# Set the build type to Release if not specified
if [ -z ${build_type+x} ]; then
    build_type="Release"
fi

# Run cmake command with desired options
cmake .. -DCMAKE_TOOLCHAIN_FILE=../arm-none-eabi-gcc.cmake -DCMAKE_BUILD_TYPE=$build_type

# Build the project
make