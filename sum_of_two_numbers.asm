section .text
    global _start    ;must be declared for using gcc
_start:    ;tell linker entry point
    mov eax,111b
    mov ebx,2q
   	add eax, ebx
   	add eax, '0'     ; add '0' to to convert the sum from decimal to ASCII
    
    mov [sum], eax
    mov ecx,msg 
    mov edx, len
    mov ebx,1   ;file descriptor (stdout)
    mov eax,4   ;system call number (sys_write)
    int 0x80    ;call kernel
    
    mov ecx,sum
   	mov edx, 1
   	mov ebx,1   ;file descriptor (stdout)
   	mov eax,4   ;system call number (sys_write)
    int 0x80    ;call kernel
    
    mov eax,1   ;system call number (sys_exit)
    int 0x80    ;call kernel

section .data
    msg db "The sum is:", 0xA 
    len equ $ - msg   

segment .bss
    sum resb 1