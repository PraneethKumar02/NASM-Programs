section .data
msg db "Enter a number: ", 0xa
len equ $- msg
msg1 db "The given number is a Perfect number", 0xa
len1 equ $- msg1
msg2 db "The given number is not a Perfect number", 0xa
len2 equ $- msg2

section .bss
num resb 3
result resb 10
result_len resb 10

section .text
global _start ;must be declared for using gcc
_start: ;tell linker entry point
mov ebx,1 ;file descriptor (stdout)
mov eax,4 ;system call number (sys_write)
mov ecx,msg
mov edx, len
int 0x80 ;call kernel

mov eax , 3
mov ebx , 0
mov ecx , num
mov edx , 3
int 0x80
mov edx, num ; our string
call string_to_int
mov ecx , eax

sub ecx , 2
mov ebx,2
mov ecx,1
mov edx,0
check_perfect_number : ;To find the sum of the positive divisors
cmp eax,1
je print
cmp ebx,eax
je print
push eax
push edx
div ebx
cmp edx,0
je sum

end:
pop edx
pop eax
inc ebx
jmp check_perfect_number

print:
push eax
push ecx
mov edi, result ; Argument: Address of the target string
call int_to_string ; Get the digits of EAX and store it as ASCII
sub edi, result ; getting length of the string
mov [result_len], edi
pop ecx
pop eax
cmp eax,1
je not_perfect_number
cmp ecx,eax
je perfect_number

not_perfect_number:
mov ebx,1 ;file descriptor (stdout)
mov eax,4 ;system call number (sys_write)
mov ecx,msg2
mov edx, len2
int 0x80 ;call kernel
jmp exit

perfect_number:
mov ebx,1 ; file descriptor (stdout)
mov eax,4 ; system call number (sys_write)
mov ecx,msg1
mov edx, len1
int 0x80 ; call kernel

exit:
mov eax, 1
mov ebx,0
int 80h

sum:
add ecx,ebx
jmp end

string_to_int: ; Converts an string in EDX to a integer stored in eax.
xor eax, eax ; clear off anything in eax

.top:
movzx ecx, byte [edx] ; get each character of string in each iteration
inc edx
cmp ecx, '0' ; If you reach end of string, then you're done.
jb .done
cmp ecx, '9'
ja .done
sub ecx, '0' ; converting character to integer
imul eax, 10 ; multiply the result obtained till now by ten
add eax, ecx ; add in current digit
jmp .top ; loop until done.

.done:
ret

int_to_string: ; Converts an positive integer in EAX to a string pointed to by EDI
xor ecx, ecx
mov ebx, 10 ; divided by 2 to covert into binary

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