# Troubleshooting Guide

This document provides solutions to common issues encountered while using ASMblr tools and scripts.


## Common Issues and Fixes

### 1. Missing DLL Files

**Problem:**

- When running the `signer` script, you encounter the following error:
    solana_sdk_wrapper.dll not found

**Solution:**

- Ensure the `solana_sdk_wrapper.dll` file is placed in the same directory as `signer.exe`.
- If the DLL is missing, recompile the Rust project by following the [Compilation Guide](compilation.md).

### 2. Rust Signing Errors

**Problem:**

- Errors occur when calling the `sign_transaction` function:
    Error: Invalid Transaction Data

**Solution:**

- Ensure the unsigned transaction data is valid and properly formatted in Base58.
- Double-check the private keys being passed to the function. They must be valid Base58-encoded strings.
- Verify that the Rust library (`lib.rs`) is correctly compiled into a DLL and the function signatures match.

### 3. Compilation Errors

#### C Script Compilation Errors

**Problem:**

- When compiling `signer.c`, you encounter undefined reference errors like:
    undefined reference to sign_transaction

**Solution:**

- Ensure the `solana_sdk_wrapper.dll` is properly linked during compilation:

    gcc -o signer signer.c -L. -lsolana_sdk_wrapper

Rust DLL Compilation Errors

    Problem:

    You see errors during the Rust project build:
 
        error: linking with `gcc` failed

    Solution:

    Ensure you’ve installed the gnu Rust toolchain:

        rustup install stable-x86_64-pc-windows-gnu
        rustup default stable-x86_64-pc-windows-gnu

### 4. Dependency Installation Issues

problem:

    GCC, Rust, or NASM isn’t recognized as a command.

Solution:

    Add the binary paths of the respective tools to your system's PATH variable:
    GCC: Add the bin directory of MinGW-w64.
    Rust: Ensure rustup is installed and configured.
    NASM: Add the NASM binary folder.

### Additional Help
    If you encounter an issue not listed here, check the GitHub Issues page for similar problems or create a new issue.
    Refer to the Compilation Guide and Usage Guide for further assistance.

