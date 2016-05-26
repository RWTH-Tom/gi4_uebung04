global  main

section .data
 ergebnis dd 1
 ergebnis_fib dq 0
 n dd 2
 n_fib dd 50
 message db "%dth Fibonacci: %llu",10,0

section .text
extern printf

main:
  push dword [n] ; push argument to stack
  call fak
  add esp, 4 ; remove argument from stack

  push dword [n_fib]
  call fib
  add esp, 4

  push dword [ergebnis_fib+4] ;call printf to print fib-number
  push dword [ergebnis_fib]
  push dword [n_fib]
  push message
  call printf

  add esp, 16 ;remove local variables

  mov eax, 1
  mov ebx, 0
  int 0x80
  ret

fak:
  mov ecx, dword [esp+4] ; get argument from stack
  mov eax, 1

  fak_loop: ; calculate ergebnis*currentIndex (32bit)
    imul ecx
    dec ecx
    jnz fak_loop ;end loop when ecx reached 0

  mov [ergebnis], eax  ; write eax to ergebnis

  ret


;takes index from stack, calculates fibonacci number using a loop
fib:
  mov ecx, dword [esp+4] ; get 32bit target index

  dec ecx ; if n==1||n==2 return 1
  jz fib_1
  dec ecx
  jz fib_1

  sub esp, 8
  mov dword [esp], 1 ;initialize temporary local variable as 0th fibbonacci number
  mov dword [esp+4], 0
  mov dword [ergebnis_fib], 1 ;initialize 1st fibbonacci number
  mov dword [ergebnis_fib+4], 0

  mov eax, 1 ;initialize 1st fibbonacci number
  mov edx, 0

  fib_loop:
    add eax, [esp] ; add last number to current, result in eax:edx
    adc edx, [esp+4]
    jc fib_error ;if 64-bit addition overflows, throw error

    mov ebx, [ergebnis_fib] ;shift last numbers (temp = ergebnis_fib; ergebnis_fib = eax:edx;)
    mov [esp], ebx
    mov ebx, [ergebnis_fib+4]
    mov [esp+4], ebx
    mov [ergebnis_fib], eax
    mov [ergebnis_fib+4], edx

    dec ecx
    jnz fib_loop

  add esp, 8 ; remove local variable
  ret

fib_1:
  mov dword [ergebnis_fib], 1
  mov dword [ergebnis_fib+4], 0

  ret

fib_error: ; an error has occured, return 0
  mov dword [ergebnis_fib], 0
  mov dword [ergebnis_fib+4], 0

  add esp, 8
  ret


c_fragment_one:
  mov eax, 0 ;int a = 0
  mov ebx, 7 ;int b = 7

  cmp eax, 0
  jz frag1_zero ;if(a++ == 0) --> frag1_zero
    inc eax ; a++ after the comparison, but in both cases
    mov ebx, 0 ;if/else "swapped"
  jp frag1_end
  frag1_zero:
    inc eax ; a++ after the comparison, but in both cases
    mov ebx, 1
  frag1_end:
  ;;;

c_fragment_two:
  add esp, 40 ; 10 int a 4 bytes -> 40 bytes
  mov ecx, 0 ; int i = 0

  frag2_for
  cmp ecx, 10 ; i<10
  jge frag2_end ; if i >= 10 exit loop
  mov [esp-40+ecx*4], ecx ;a[i] = i;
  int ecx ; i++
  jp frag2_for

  frag2_end:
  ;; end

c_fragment_three:
  mov ecx, 10 ;int i = 10;
  mov eax, 1  ;int ergebnis = 1;

  frag3_loop_begin:
    dec ecx
    jnz frag3_loop_body
    jp frag3_end
    frag3_loop_body:
      mul eax, ecx
      jp frag3_loop_begin

  frag3_end:
  ;;;; end
