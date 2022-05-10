segment .data
msg db "Binary representation of given number is: ",
len equ $- msg
num dd 8 ;input number here

segment .bss
sum resb 40
sum_len resd 1

section .text
global _start
_start:
mov eax, [num]
mov edi, sum
call integer_to_string
sub edi, sum
mov [sum_len], edi
mov ecx, msg
mov edx, len
mov ebx,1 ;file descriptor
mov eax,4 ;system call number
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, sum
mov edx, [sum_len]
int 0x80

exit:
mov eax, 1
xor ebx, ebx
int 0x80

integer_to_string: ; Converts an positive integer in EAX to a string pointed to by EDI
xor ecx, ecx
mov ebx, 2 ; divided by 2 to covert into binary
.loop1: ; First loop: Save the remainders
xor edx, edx ; Clear EDX for div
div ebx ; EDX:EAX/EBX -> EAX Remainder EDX
push dx ; Save remainder
inc ecx ; Increment push counter
test eax, eax ; Anything left to divide?
jnz .loop1 ; Yes: loop once more
.loop2: ; Second loop: Retrieve the remainders
pop dx ; In DL is the value
or dl, '0' ; To ASCII
mov [edi], dl ; Save it to the string
inc edi ; Increment the pointer to the string
loop .loop2 ; Loop ECX times
mov byte [edi], 0 ; Termination character
ret