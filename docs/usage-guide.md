Usage Guide for ASMBLR
Welcome to the ASMBLR project! This guide will walk you through the steps needed to set up your environment, compile and run the scripts, and use the tools to replicate the token creation and signing process.

Table of Contents
 1.  Prerequisites
 2.  Setting Up Dependencies
 3.  Compiling the Scripts
        Assembly Scripts
        C Scripts
        Rust Scripts
 4. Running the Scripts  
 5.   Uploading Metadata and Submitting Transactions

Prerequisites

Before you begin, ensure you have the following installed on your system:

Rust: For compiling the Rust script (lib.rs).
GCC/MinGW: For compiling the C script (signer.c).
NASM (Netwide Assembler): For working with assembly files.
Curl: For testing API requests.
A text editor or IDE: To view and edit the scripts if needed.
Recommended System Requirements:
OS: Windows 10/11 or Linux (for compatibility with the tools and scripts).
Memory: 4GB minimum.
Processor: x86_64 architecture.

Setting Up Dependencies

1. Install Rust
Visit the official Rust website and follow the installation instructions.
After installation, verify by running:
bash
Copy code
rustc --version

2. Install GCC or MinGW
Windows: Download and install MinGW-w64.
Linux: Install GCC via your package manager:
bash
Copy code
sudo apt-get install build-essential
Verify installation:
bash
Copy code
gcc --version

3. Install NASM
Download NASM from the official website.
Verify installation:
bash
Copy code
nasm -v

4. Install Curl
Windows: Download Curl from curl.se.
Linux/MacOS: Install via your package manager:
bash
Copy code
sudo apt-get install curl

Compiling the Scripts
1. Compile the Assembly Script
If you're working with an .asm file, use NASM to compile it:

       nasm -f elf64 myscript.asm -o myscript.o
       ld myscript.o -o myscript

2. Compile the C Script (signer.c)
Use GCC to compile the signer.c file:

       gcc -o signer signer.c -L. -lsolana_sdk_wrapper
Make sure the compiled Rust DLL (solana_sdk_wrapper.dll) is in the same directory as signer.c.

3. Compile the Rust Script (lib.rs)
Navigate to the Rust script directory:

       cd rust_project_directory
Build the Rust script into a DLL:

       cargo build --release --target x86_64-pc-windows-gnu
After building, copy the solana_sdk_wrapper.dll from target/release into the directory with signer.c.


Running the Scripts
1. Running the Assembly Script
If you have an executable from the assembly script, run it using:

       ./myscript

2. Running the C Script
Once signer.c is compiled, run it:

       ./signer

3. Testing the Rust DLL Integration
The signer.c script will dynamically load the solana_sdk_wrapper.dll to handle signing tasks. Ensure both are in the same directory before running signer.   


Uploading Metadata and Submitting Transactions

1. Uploading Metadata
Use Curl to upload metadata to the Pump.fun IPFS API:

curl -X POST https://pump.fun/api/ipfs \
    -H "Content-Type: application/json" \
    -d '{"name":"Terry","symbol":"Terry","description":"The first token to be deployed in assembly language.","twitter":"https://twitter.com/MyToken","telegram":"https://t.me/MyTokenGroup","website":"https://mytoken.io"}'

2. Submitting Transactions
Use Curl to submit signed transactions to the Helius RPC:

curl -X POST https://rpc.helius.xyz/v1/your-api-key \
       -H "Content-Type: application/json" \
       -H "Authorization: your-api-key" \
       -d '{
              "jsonrpc": "2.0",
               "id": 1,
              "method": "sendTransaction",
              "params": [
              "<base58_encoded_signed_transaction>",
              {"encoding": "base58"}
              ]
       }'

    