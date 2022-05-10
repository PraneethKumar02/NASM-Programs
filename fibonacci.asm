section .text
global _start
_start:

;To print the msg1
mov eax , 4
mov ebx , 1
mov ecx , msg
mov edx , len
int 0x80

; Print the 1st number
mov eax , [x]
mov edi, sum
call int2str
sub edi, sum
mov [sum_len], edi
mov eax , 4
mov ebx , 1
mov ecx , sum
mov edx , [sum_len]
int 0x80
mov eax , 4
mov ebx , 1
mov ecx , msg2
mov edx , len2
int 0x80

; Print the 2nd number
mov eax , [y]
mov edi, sum
call int2str

sub edi, sum
mov [sum_len], edi
mov eax , 4
mov ebx , 1
mov ecx , sum
mov edx , [sum_len]
int 0x80
mov eax , 4
mov ebx , 1
mov ecx , msg2
mov edx , len2
int 0x80

mov ecx , [range]
sub ecx , 2
fib_loop:
mov [range] , ecx
mov eax , [x]
mov ebx , [y]
add eax , ebx
mov ebx , [y]
mov [x] , ebx
mov [y] , eax
mov edi, sum
call int2str
sub edi, sum
mov [sum_len], edi
mov eax , 4
mov ebx , 1
mov ecx , sum
mov edx , [sum_len]
int 0x80
mov eax , 4
mov ebx , 1
mov ecx , msg2
mov edx , len2
int 0x80

mov ecx , [range]
dec ecx
jne fib_loop

mov eax, 1
int 0x80

;to Print the Number greater than 9
int2str:
xor ecx, ecx
mov ebx, 10

.LL1:
xor edx, edx
div ebx
push dx
inc ecx
test eax, eax
jnz .LL1

.LL2:
pop dx
or dl, '0'
mov [edi], dl
inc edi
loop .LL2
mov byte [edi], 0
ret

section .data
x dd 0 ;First Number
y dd 1 ;Second Number
range dd 15
msg db "The Fibonacci Sequence is : " ;Message to Print
len equ $-msg ;Length of message
msg2 db " " ;Like to give space after every number
len2 equ $-msg2
msg3 db "Enter the Range : "
len3 equ $-msg3

segment .bss
sum resb 40
sum_len resd 1