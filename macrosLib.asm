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

.macro printendl
	li a0, 10
	printch
.end_macro

.macro error %str
.data
str: .asciz %str
.text
	la a0, str
	syscall 4
	exit 1
.end_macro

.macro push3 %r1 %r2 %r3
	addi sp, sp, -12
	sw %r1, 0(sp)
	sw %r2, 4(sp)
	sw %r3, 8(sp)
.end_macro

.macro pop3 %r1 %r2 %r3
	lw %r3 8(sp)
	lw %r2 4(sp)
	lw %r1, 0(sp)
	addi sp, sp, 12
.end_macro

.macro push4 %r1 %r2 %r3 %r4
	addi sp, sp, -16
	sw %r1, 0(sp)
	sw %r2, 4(sp)
	sw %r3, 8(sp)
	sw %r4 12(sp)
.end_macro

.macro pop4 %r1 %r2 %r3 %r4
	lw %r4 12(sp)
	lw %r3 8(sp)
	lw %r2 4(sp)
	lw %r1, 0(sp)
	addi sp, sp, 16
.end_macro


