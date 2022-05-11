section .text
global _start ;must be declared for using gcc
_start: ;tell linker entry point
mov eax, [n1]
cmp eax, [n2]
jg next1
mov eax, [n2]

next1:
cmp eax, [n3]
jg next2
mov eax, [n3]

next2:
cmp eax, [n4]
jg next3
mov eax, [n4]

next3:
cmp eax, [n5]
jg finish
mov eax, [n5]

finish:
mov edi,num
call int2str
sub edi,num
mov [num_len],edi

mov ecx,num
mov edx, [num_len]
mov ebx,1 ;file descriptor (stdout)
mov eax,4 ;system call number (sys_write)
int 0x80 ;call kernel

mov eax, 1
int 80h

int2str: ; Converts an positive integer in EAX to a string pointed to by EDI
xor ecx, ecx
mov ebx, 10

.LL1: ; First loop: Save the remainders
xor edx, edx ; Clear EDX for div
div ebx ; EDX:EAX/EBX -> EAX Remainder EDX
push dx ; Save remainder
inc ecx ; Increment push counter
test eax, eax ; Anything left to divide?
jnz .LL1 ; Yes: loop once more

.LL2: ; Second loop: Retrieve the remainders
pop dx ; In DL is the value
or dl, '0' ; To ASCII
mov [edi], dl ; Save it to the string
inc edi ; Increment the pointer to the string
loop .LL2 ; Loop ECX times

mov byte [edi], 0 ; Termination character
ret ; RET: EDI points to the terminating NULL

section .data
n1 dd 999
n2 dd 420
n3 dd 752
n4 dd 155
n5 dd 983

segment .bss
num resd 20
num_len resd 5