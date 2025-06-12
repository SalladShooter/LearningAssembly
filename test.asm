section .bss
    buffer resb 100    ; reserve 100 bytes for input

section .data
    msg db "Yes, or no?", 0xA
    msg_len equ $ - msg

    yesstr db "yes", 10    ; 'yes' + newline
    yeslen equ 4

    yessay db "You said YES!", 10
    yessay_len equ $ - yessay

    nosay db "You did not say yes.", 10
    nosay_len equ $ - nosay

section .text
    global _start

%macro syscall4 4    ; macro for assigning registers for syscall faster
    mov rax, %1
    mov rdi, %2 
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

_start:
    syscall4 1, 1, msg, msg_len    ; prompt the user

    syscall4 0, 0, buffer, 100    ; read user input

    ; Prepare for comparison
    mov rsi, buffer    ; input
    mov rdi, yesstr    ; target string
    mov rcx, yeslen    ; bytes to compare

recheck:    ; checks if user said yes, or didn't say yes
    mov al, [rsi]
    cmp al, [rdi]
    jne not_yes
    inc rsi
    inc rdi
    loop recheck

    syscall4 1, 1, yessay, yessay_len    ; if equal
    jmp exit

not_yes:
    syscall4 1, 1, nosay, nosay_len

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
