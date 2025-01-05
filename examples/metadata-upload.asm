section .data
    ; Token metadata strings
    debug_start db "Starting token metadata display...", 0xA, 0
    token_name db "Token Name: MyToken", 0xA, 0
    token_symbol db "Symbol: MTK", 0xA, 0
    token_description db "Description: This is my custom token!", 0xA, 0
    token_twitter db "Twitter: https://twitter.com/MyToken", 0xA, 0
    token_telegram db "Telegram: https://t.me/MyTokenGroup", 0xA, 0
    token_website db "Website: https://mytoken.io", 0xA, 0

section .bss
    bytes_written resq 1  ; Reserve space for the number of bytes written

section .text
extern GetStdHandle
extern WriteConsoleA
global main

main:
    ; Get the handle for the standard output
    sub rsp, 32              ; Align stack
    mov rcx, -11             ; STD_OUTPUT_HANDLE constant
    call GetStdHandle        ; Call GetStdHandle
    mov rbx, rax             ; Save the handle in rbx

    ; Print all metadata
    lea rdx, [rel debug_start]
    call print_string

    lea rdx, [rel token_name]
    call print_string

    lea rdx, [rel token_symbol]
    call print_string

    lea rdx, [rel token_description]
    call print_string

    lea rdx, [rel token_twitter]
    call print_string

    lea rdx, [rel token_telegram]
    call print_string

    lea rdx, [rel token_website]
    call print_string

    ; Exit the program
    xor rax, rax             ; Return 0
    add rsp, 32              ; Restore stack
    ret

print_string:
    ; Print the string to the console
    mov rcx, rbx             ; Handle (stdout)
    mov rdx, rdx             ; Pointer to the string
    call string_length       ; Get string length
    mov r8, rax              ; Move length to r8
    sub rsp, 40              ; Align stack for WriteConsoleA
    xor r9, r9               ; No OVERLAPPED structure
    call WriteConsoleA       ; Call WriteConsoleA
    add rsp, 40              ; Restore stack
    ret

string_length:
    ; Calculate the length of a null-terminated string
    xor rax, rax             ; Reset counter
next_char:
    cmp byte [rdx + rax], 0  ; Check for null terminator
    je done                  ; Jump if end of string
    inc rax                  ; Increment counter
    jmp next_char            ; Repeat
done:
    ret
