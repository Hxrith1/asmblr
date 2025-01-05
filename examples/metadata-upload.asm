section .data
    debug_start db "Starting token metadata display...", 0xA, 0
    token_name db "Token Name: MyToken", 0xA, 0
    token_symbol db "Symbol: MTK", 0xA, 0
    token_description db "Description: This is my custom token!", 0xA, 0
    token_twitter db "Twitter: https://twitter.com/MyToken", 0xA, 0
    token_telegram db "Telegram: https://t.me/MyTokenGroup", 0xA, 0
    token_website db "Website: https://mytoken.io", 0xA, 0

section .bss
    bytes_written resq 1  

section .text
extern GetStdHandle
extern WriteConsoleA
global main

main:
    sub rsp, 32              
    mov rcx, -11             
    call GetStdHandle        
    mov rbx, rax             

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

    xor rax, rax             
    add rsp, 32              
    ret

print_string:
    ; Print the string to the console
    mov rcx, rbx             
    mov rdx, rdx             
    call string_length       
    mov r8, rax              
    sub rsp, 40              
    xor r9, r9              
    call WriteConsoleA       
    add rsp, 40              
    ret

string_length:
    ; Calculate the length of a null-terminated string
    xor rax, rax             
next_char:
    cmp byte [rdx + rax], 0  
    je done                  
    inc rax                  
    jmp next_char            
done:
    ret
