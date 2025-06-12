section .bss
    buffer resb 100        ; reserve 100 bytes for input
    buffer_len equ $ - buffer    ; defines 'len' var

section .data
    msg db "Yes, or no?", 0xA
    msg_len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1             ; syscall: write
    mov rdi, 1             ; file descriptor 1 = stdout
    mov rsi, msg        ; msg to output
    mov rdx, msg_len           ; write the same number of bytes
    syscall

    ; Read input from stdin (fd = 0)
    mov rax, 0             ; syscall: read
    mov rdi, 0             ; file descriptor 0 = stdin
    mov rsi, buffer        ; buffer to store input
    mov rdx, buffer_len           ; number of bytes to read
    syscall

    ; Optional: write the input back out to stdout
    mov rax, 1             ; syscall: write
    mov rdi, 1             ; file descriptor 1 = stdout
    mov rsi, buffer        ; buffer to output
    mov rdx, buffer_len           ; write the same number of bytes
    syscall

    ; Exit
    mov rax, 60            ; syscall: exit
    xor rdi, rdi           ; exit code 0
    syscall
