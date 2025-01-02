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