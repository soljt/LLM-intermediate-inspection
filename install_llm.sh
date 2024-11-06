#!/bin/bash

# Detect if the operating system is macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "You are using macOS."
    IS_MACOS=true
else
    echo "You are not using macOS."
    IS_MACOS=false
fi

# Clone the repository and navigate into it
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
mkdir build

# Configure build options based on the OS and GPU availability
if $IS_MACOS; then
    cmake -B build -DLLAMA_CURL=ON
else
    if command -v nvidia-smi &> /dev/null; then
        cmake -B build -DGGML_CUDA=ON -DLLAMA_CURL=ON -DGGML_CUDA_ENABLE_UNIFIED_MEMORY=ON
    else
        cmake -B build -DLLAMA_CURL=ON
    fi
fi

# Build the project
cmake --build build --config Release -j

# Change to the directory containing binaries
cd build/bin

# Function to add a binary to PATH
add_to_path() {
    local binary_name=$1
    local binary_path="$(pwd)/$binary_name"

    echo
    read -p "Do you want to add $binary_name to your PATH? (y/n): " add_to_path

    if [[ "$add_to_path" =~ ^[Yy]$ ]]; then
        # Determine which shell config file to use (.bashrc or .zshrc)
        SHELL_CONFIG="$HOME/.bashrc"
        [ -f "$HOME/.zshrc" ] && SHELL_CONFIG="$HOME/.zshrc"
        
        # Add the binary path to the PATH in the shell config
        echo "export PATH=\"\$PATH:$(pwd)\"" >> "$SHELL_CONFIG"
        echo "✅ $binary_name added to PATH in $SHELL_CONFIG."
        
        # Source the shell configuration to apply changes immediately
        source "$SHELL_CONFIG"
        echo "You may need to restart your terminal for the changes to fully take effect."
    else
        echo "You chose not to add $binary_name to the PATH."
        echo "To manually add it later, you can add the following line to your shell configuration file:"
        echo "export PATH=\"\$PATH:$(pwd)\""
    fi
}

# Prompt to add llama-cli and llama-server to the PATH
add_to_path "llama-cli"
add_to_path "llama-server"

# Run the llama-cli command as needed
./llama-cli --hf-repo "QuantFactory/Meta-Llama-3-8B-Instruct-GGUF" --hf-file Meta-Llama-3-8B-Instruct.Q2_K.gguf --conversation
