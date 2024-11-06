#!/bin/bash

# Detect if the operating system is macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "You are using macOS."
    IS_MACOS=true
else
    IS_MACOS=false
fi

# Function to check if a command is available
check_command() {
    local cmd=$1
    local name=$2

    if command -v "$cmd" &> /dev/null; then
        echo "✅ $name is installed."
        return 0
    else
        echo "❌ $name is not installed."
        return 1
    fi
}

# Check for CMake
check_command "cmake" "CMake"

# Check for curl/curl.h if not on macOS
if ! $IS_MACOS; then
    DIRECTORIES=(
        "/usr/include"
        "/usr/local/include"
        "/opt/local/include"
        "/usr/include/x86_64-linux-gnu"
    )
    FOUND=false
    for DIR in "${DIRECTORIES[@]}"; do
        if [ -f "$DIR/curl/curl.h" ]; then
            echo "✅ curl/curl.h found in $DIR"
            FOUND=true
            break
        fi
    done
    if ! $FOUND; then
        echo "❌ Curl developer files (curl/curl.h) were not found."
    fi
else
    echo "Skipping curl/curl.h check on macOS."
fi

# Check for Git
check_command "git" "Git"

# Check for Git LFS
check_command "git-lfs" "Git LFS"

# Check for huggingface_hub in Python
if python3 -c "import huggingface_hub" &> /dev/null; then
    echo "✅ huggingface_hub is installed in the current environment."
else
    echo "❌ huggingface_hub is not installed in the current environment."
fi

# Check for NVIDIA CUDA Toolkit if not on macOS
if ! $IS_MACOS; then
    check_command "nvcc" "NVIDIA CUDA Toolkit"
else
    echo "Skipping NVIDIA CUDA Toolkit check on macOS."
fi
