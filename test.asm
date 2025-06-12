section .bss
    buffer resb 100            ; reserve 100 bytes for user input

section .data
    msg db "Yes, or no?", 10
    msg_len equ $ - msg

    yes1 db "yes", 10
    yes2 db "YES", 10
    yes3 db "Yes", 10
    yes4 db "y", 10

    yes_table dq yes1, yes2, yes3, yes4   ; pointers to valid yes responses
    yes_lens  dq 4,     4,    4,    2     ; corresponding string lengths
    yes_count equ 4                      ; number of entries

    yessay db "You said YES!", 10
    yessay_len equ $ - yessay

    nosay db "You did not say yes.", 10
    nosay_len equ $ - nosay

section .text
    global _start

%macro syscall4 4
    mov rax, %1
    mov rdi, %2 
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

_start:
    syscall4 1, 1, msg, msg_len        ; print prompt
    syscall4 0, 0, buffer, 100         ; read user input

    xor rbx, rbx                       ; index = 0

check_next:
    cmp rbx, yes_count
    jge not_yes                        ; if index >= yes_count, no match

    ; Load string pointer and length
    mov rdi, [yes_table + rbx*8]
    mov rcx, [yes_lens + rbx*8]
    mov rsi, buffer
    call compare

    cmp rax, 1
    je print_yes

    inc rbx
    jmp check_next

print_yes:
    syscall4 1, 1, yessay, yessay_len
    jmp exit

not_yes:
    syscall4 1, 1, nosay, nosay_len

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; rsi = input buffer
; rdi = valid string
; rcx = length
; returns rax = 1 if equal, 0 otherwise
compare:
    push rcx
    xor rax, rax
.compare_loop:
    cmp rcx, 0
    je .equal
    mov al, [rsi]
    cmp al, [rdi]
    jne .done
    inc rsi
    inc rdi
    dec rcx
    jmp .compare_loop
.equal:
    mov rax, 1
.done:
    pop rcx
    ret
