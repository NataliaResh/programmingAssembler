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

.macro readbcd
	li t2, 58
	bge a0, t2, exit
	li t2, 48
	blt a0, t2, exit
	addi a0, a0, -48
.end_macro

.macro bcdtochar
	li t0, 10
	bge a0, t0, exit
	addi a0, a0, 48
.end_macro

.macro op
	li t0, 43
	bne a0, t0, subop
	addbcd
	j endop
subop:
	li t0, 45
	bne a0, t0, exit
	subbcd
endop:
.end_macro

.macro addbcd
	li t5, 0
	li t6, 29
	li s4, 0x0000000f
	li s9, 0
loopadd:
	and s7, s1, s4
	and s8, s2, s4
	srl s7, s7, t5
	srl s8, s8, t5
	add a0, s7, s8
	beqz s9, m1add #if s9 != 0:
	add a0, a0, s9
	li s9, 0
m1add: #if !(9 >= a0)
	li t0, 9
	bge t0, a0 m2add
	li s9, 1
	li t0, 10
	sub a0, a0, t0
m2add:
	slli s0, s0, 4
	add s0, s0, a0
	slli s4, s4, 4
	addi t5, t5, 4
	blt t5, t6 loopadd
.end_macro #ans in s0

.macro subbcd
	li t5, 0
	li t6, 29
	li s4, 0x0000000f
	li s9, 0
loopsub:
	and s7, s1, s4
	and s8, s2, s4
	
	srl s7, s7, t5
	srl s8, s8, t5
	
	bge s7, s8, m1sub # if s7 < s8 (s7 >= s8)
	addi s7, s7, 10
	mv t4, s4
	mv t3, t5
nextdigit:
	slli t4, t4, 4
	addi t3, t3, 4
	and t1, s1, t4
	srl t1, t1, t3 # next digit s1 in t1
	bgtz t1,greaterzero #if t1 == 0 (t1 > 0)
	li t1, 9
	sll t1, t1, t3
	add s1, s1, t1
	j nextdigit
greaterzero:
	# else if t1 > 0
	li t1, 1
	sll t1, t1, t3
	sub s1, s1, t1
m1sub:
	sub a0, s7, s8
	
	slli s0, s0, 4
	add s0, s0, a0
	slli s4, s4, 4
	addi t5, t5, 4
	blt t5, t6 loopsub
.end_macro #ans in s0

main:
	li s10, 10
metka1:
	readch
	beq a0, s10, metka3
	readbcd
	add s1, s1, a0
metka2:
	readch
	beq a0, s10, metka3
	readbcd
	slli s1, s1, 4
	add s1, s1, a0
	j metka2
metka3:
	readch
	beq a0, s10, metka5
	readbcd
	add s2, s2, a0
metka4:
	readch
	beq a0, s10, metka5
	readbcd
	slli s2 s2, 4
	add s2, s2, a0
	j metka4
	
metka5:
	readch #read op
	op
	mv a0, s10
	printch
	li s5, 0
	li s6, 29
	li s4, 0x0000000f
loopprint:
	and a0, s0, s4
	srl a0, a0, s5
	bcdtochar
	printch
	slli s4, s4, 4
	addi s5, s5, 4
	blt s5, s6, loopprint
exit:
	exit 0
