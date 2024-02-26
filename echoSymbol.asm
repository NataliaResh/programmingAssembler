.text
.macro syscall %n
 	li a7, %n
 	ecall
.end_macro

.macro exit %ecode
	li a0, %ecode
	syscall 93
.end_macro

.macro readch
	syscall 12
.end_macro

.macro printch
	syscall 11
.end_macro

main:
	li s0, 10
metka1:
	readch
	beq a0, s0, metka2
	printch
	addi a0, a0, 1
	printch
	j metka1
metka2:
	exit 0
