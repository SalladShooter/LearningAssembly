section .bss
    buffer resb 100          ; reserve 100 bytes for input

section .data
    msg db "Yes, or no?", 0xA
    msg_len equ $ - msg

    yesstr db "yes", 10      ; 'yes' + newline
    yeslen equ 4

    yessay db "You said YES!", 10
    yessay_len equ $ - yessay

    nosay db "You did not say yes.", 10
    nosay_len equ $ - nosay

section .text
    global _start

_start:
    ; Prompt the user
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ; Read user input
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 100
    syscall
    ; RAX now contains the number of bytes read

    ; Compare first 4 bytes to "yes\n"
    mov rsi, buffer        ; source: buffer
    mov rdi, yesstr        ; compare to: "yes\n"
    mov rcx, yeslen        ; number of bytes to compare

recheck:
    mov al, [rsi]
    cmp al, [rdi]
    jne not_yes
    inc rsi
    inc rdi
    loop recheck

    ; If equal:
    mov rax, 1
    mov rdi, 1
    mov rsi, yessay
    mov rdx, yessay_len
    syscall
    jmp exit

not_yes:
    ; Else:
    mov rax, 1
    mov rdi, 1
    mov rsi, nosay
    mov rdx, nosay_len
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
