.text
.macro syscall %n
 	li a7, %n
 	ecall
.end_macro

.macro exit %ecode
	li a0, %ecode
	syscall 93
.end_macro

.macro error %str
.data
str: .asciz %str
.text
	la a0, str
	syscall 4
	exit 1
.end_macro

.macro readch
	syscall 12
.end_macro

.macro printch
	syscall 11
.end_macro

main:
	syscall 5 #readInt
	call fib
	syscall 1 #printInt
	exit 0
	
.macro push %r
	addi sp, sp, -4
	sw %r, 0(sp)
.end_macro

.macro push2 %r1 %r2
	addi sp, sp, -8
	sw %r1, 0(sp)
	sw %r2, 4(sp)
.end_macro

.macro pop %r
	lw %r, 0(sp)
	addi sp, sp, 4
.end_macro

.macro pop2 %r1 %r2
	lw %r2 4(sp)
	lw %r1, 0(sp)
	addi sp, sp, 8
.end_macro

fib: # int fib(int k)
	sltiu t0, a0, 2
	bnez t0, fib_base
	
	push2 ra, s1
	
	addi a0, a0, -1
	addi s1, a0, -1
	call fib
	mv t0, a0
	mv a0, s1
	mv s1, t0
	call fib
	add a0, a0, s1
	
	pop2 ra, s1
	
	ret
	
fib_base:
	li a0, 1
	ret
