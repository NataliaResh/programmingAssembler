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
	error "Hello world!"
	readch
	andi s0 a0, 0xff
	li a0, 10
	printch
	addi a0, s0, -48
	sltiu a0, a0, 10
	addi a0, a0, 48
	printch
	exit 0
