# Compilation Guide

This guide explains how to set up your environment and compile the components of the ASMblr project. Follow these instructions step-by-step to ensure a smooth setup.

---

## Setting Up Your Environment

### 1. Install GCC (C Compiler)
- **Windows**: Install MinGW-w64 to compile C code.
  - [Download MinGW-w64](https://www.mingw-w64.org/downloads/)
  - Add the `bin` folder of the installation directory to your `PATH` environment variable.
  - Verify installation by running:
    ```bash
    gcc --version
    ```

### 2. Install Rust
- Install Rust using `rustup`:
  ```bash
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

On Windows, download the Rust installer from Rust Download.
Install the gnu toolchain for Rust (required for DLL generation on Windows):

    rustup install stable-x86_64-pc-windows-gnu
    rustup default stable-x86_64-pc-windows-gnu

### 3. Install NASM (Assembly Compiler) [Optional]
Download and install NASM:
    NASM Official Website
Verify installation by running:

    nasm -v


Compiling the Components

Compiling the Rust Library (lib.rs)
    Navigate to the Rust project directory:

        cd rust-signer

Build the Rust project as a DLL:

    cargo build --release --target x86_64-pc-windows-gnu

After successful compilation, the DLL will be located in:

    target/release/solana_sdk_wrapper.dll

Move the DLL to the main project directory:

    cp target/release/solana_sdk_wrapper.dll ../main-project-dir/

Compiling the C Script (signer.c)
    Navigate to the directory containing signer.c:

        cd main-project-dir
    
Compile the script, linking it with the Rust DLL:

    gcc -o signer signer.c -L. -lsolana_sdk_wrapper

Ensure the solana_sdk_wrapper.dll is in the same directory as the compiled signer executable.

Compiling Example Assembly Files
    Navigate to the examples directory:

        cd examples

Assemble the .asm file using NASM:

    nasm -f win64 example.asm -o example.obj

Link the object file to create an executable:

    gcc -o example.exe example.obj


Running the Components

    Running the Rust Signing Library

    Before using the Rust DLL, ensure it is built and placed in the main project directory.
        Running the C Signing Script
    Execute the compiled signer script:

        ./signer
    
    Verify that the output contains the signed transaction.

    Running Example Assembly Scripts
        Navigate to the examples directory:
            cd examples

        Execute the compiled .exe file:

            ./example.exe

Troubleshooting Compilation Issues
Common Errors
1. Missing DLLs
Ensure solana_sdk_wrapper.dll is in the same directory as the compiled signer executable.
2. Rust Compilation Errors
Make sure the gnu toolchain for Rust is installed:

    rustup install stable-x86_64-pc-windows-gnu
3. Assembly Compilation Issues
Ensure NASM is installed and in your PATH.
4. Undefined References in GCC
Confirm that the Rust library was compiled and linked correctly during the C script compilation.

Notes
For detailed usage, refer to the usage-guide.md file.
Additional examples and scripts can be found in the examples and scripts folders.