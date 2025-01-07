#!/bin/bash

# Compile-Helpers Script for ASMBLR Project
# Automates the compilation of assembly, C, and Rust scripts

# Exit script on any error
set -e

echo "Starting compilation process for ASMBLR..."

# Compile Assembly Script
echo "Compiling assembly script: wallet-generation.asm..."
nasm -f elf64 examples/wallet-generation.asm -o examples/wallet-generation.o
ld examples/wallet-generation.o -o examples/wallet-generation
echo "Assembly script compiled successfully."

# Compile C Script
echo "Compiling C script: transaction-signing.c..."
gcc -o examples/transaction-signing examples/transaction-signing.c -L. -lsolana_sdk_wrapper
echo "C script compiled successfully."

# Compile Rust Script
echo "Compiling Rust project to create DLL/Shared Object..."
cd scripts/rust_project
cargo build --release --target x86_64-pc-windows-gnu
cd ../..

# Move Rust DLL/Shared Object to project root
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  mv scripts/rust_project/target/x86_64-pc-windows-gnu/release/asmblr_signer.dll examples/
  echo "Rust DLL moved to examples directory."
else
  mv scripts/rust_project/target/release/libasmblr_signer.so examples/
  echo "Rust Shared Object moved to examples directory."
fi

# Cleanup intermediate files
echo "Cleaning up intermediate files..."
rm -f examples/*.o

echo "Compilation process completed successfully!"
