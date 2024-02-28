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

.macro readhex
	slti t0, a0, 103
	li t1, 1
	bne t0, t1, exit
	li t2, 97
	blt a0, t2, big
	addi a0, a0, -87
	j endread
big:
	li t2, 71
	bge a0, t2, exit
	li t2, 65
	blt a0, t2, number
	addi a0, a0, -55
	j endread
number:
	li t2, 58
	bge a0, t2, exit
	li t2, 48
	blt a0, t2, exit
	addi a0, a0, -48
endread:
.end_macro

.macro hextochar
	li t0, 10
	bge a0, t0, char
	addi a0, a0, 48
	j endhextochar
char:
	addi a0, a0, 87
endhextochar:
.end_macro

.macro op
	li t0, 43
	bne a0, t0, subop
	add s0, s1, s2
	j endop
subop:
	li t0, 45
	bne a0, t0, andop
	sub s0, s1, s2
	j endop
andop:
	li t0, 38
	bne a0, t0, orop
	and s0, s1, s2
	j endop
orop:
	li t0, 124
	bne a0, t0, exit
	or s0, s1, s2
endop:
.end_macro


main:
	li s10, 10
metka1:
	readch
	beq a0, s10, metka3
	readhex
	add s1, s1, a0
metka2:
	readch
	beq a0, s10, metka3
	readhex
	slli s1, s1, 4
	add s1, s1, a0
	j metka2
metka3:
	readch
	beq a0, s10, metka5
	readhex
	add s2, s2, a0
metka4:
	readch
	beq a0, s10, metka5
	readhex
	slli s2 s2, 4
	add s2, s2, a0
	j metka4
metka5:
	readch #read op
	op
	mv a0, s10
	printch
	li s5, 28
	li s6, 0
	li s4, 0xf0000000
loop2: # print ans
	blt s5, s6, exit
	and a0, s0, s4
	srl a0, a0, s5
	hextochar
	printch
	srli s4, s4, 4
	addi s5, s5, -4
	j loop2
exit:
	exit 0
