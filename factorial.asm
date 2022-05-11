section .bss
num resd 3
fac resb 40
fac_len resd 40

section .data
msg db "Factorial: "
len equ $-msg
fact dd 5 ; change the factorial value here

section .text
global _start
_start:
mov eax,4
mov ebx,1
mov ecx,msg
mov edx,len
int 0x80

mov eax,1
mov ebx,1
mov ecx,[fact]

ll_1:
mul ebx
inc ebx

loop ll_1
mov edi, fac ; Argument: Address of the target string
call int2str ; Get the digits of EAX and store it as ASCII
sub edi, fac ; EDI (pointer to the terminating NULL) - pointer to sum = length of the string
mov [fac_len], edi
mov eax, 4
mov ebx, 1
mov ecx, fac
mov edx, [fac_len]
int 0x80

; Exit code
mov eax, 1
mov ebx, 0
int 0x80

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