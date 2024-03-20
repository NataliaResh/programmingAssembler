#  int readbcd();
#  int opbcd(char a0, int a1, int a2);
#  int addbcd(int a0, int a1);
#  int subbcd(int a0, int a1);
#  void printbcd(int);


.include "decimalLib.asm"


readbcd:  # int readbcd();
	push4 ra, s1, s2, s3
	li s2, 1
	li s1, 0
	li s3, 10
	readch
	li t0, 10
	beq a0, t0, endreadbcd
	li t0, 45
	bne a0, t0, positivebcd
	addi s3, s3, 1
	j loopreadbcd
positivebcd:
	call chartodecimal
	add s1, s1, a0
	slli s1, s1, 4
	addi s2, s2, 1
loopreadbcd:
	readch
	li t0, 10
	beq a0, t0, endreadbcd
	li t0, 8
	bge s2, t0, errorreadbcd
	call chartodecimal
	add s1, s1, a0
	slli s1, s1, 4
	addi s2, s2, 1
	j loopreadbcd
endreadbcd:
	add a0, s1, s3
	pop4 ra, s1, s2, s3
	ret
errorreadbcd:
	error "Maximum number of characters exceeded!"
	

opbcd:  # int opbcd(char a0, int a1, int a2);
	push1 ra
	mv t1, a0
	mv a0, a1
	mv a1, a2
	li t0, '+'
	beq t1, t0, addopcall
	li t0, '-'
	bne t1, t0, erroropbcd
	call subbcd
	j endopbcd
addopcall:
	call addbcd
endopbcd:
	pop1 ra
	ret
erroropbcd:
	error "Incorrect operation!"


.macro getmoduleandsign %r1, %r2
	li t0, 0xf
	and %r2, %r1, t0
	sub %r1, %r1, %r2
.end_macro


subbcd:  # int subbcd(int, int)
	push1 ra
	getmoduleandsign a0, a2
	getmoduleandsign a1, a3
	li t0, 10
	bne a3, t0, reverse
	addi t0, t0, 1
reverse:
	mv a3, t0
	call sumbcd
	pop1 ra
	ret
	

addbcd:  # int addbcd(int, int)
	push1 ra
	getmoduleandsign a0, a2
	getmoduleandsign a1, a3
	call sumbcd
	pop1 ra
	ret
	
	
sumbcd:  # int sumbcd(int a, int b, int sa, int sb);
	push1 ra
	beq a2, a3, addequalsign
	bge a0, a1, addgreater
	swap a0, a1
	swap a2, a3
addgreater:
	call subbcdmodule
	add a0, a0, a2
	j endopbcd
addequalsign:
	call addbcdmodule
	add a0, a0, a2
endsumbcd:
	pop1 ra
	ret
	

addbcdmodule:  # int addbcdmodule(int a0, int a1);
	push1 s1
	li t1, 4
	li t2, 0x000000f0
	li t3, 0
	li t4, 0  # symbol1
	li t5, 0  # symbol2
	li t6, 0  # resultsymbol
	li s1, 0  # result
loopadd:
	and t4, a0, t2
	and t5, a1, t2
	srl t4, t4, t1
	srl t5, t5, t1
	add t6, t4, t5
	beqz t3, m1add #if t3 != 0:
	add t6, t6, t3
	li t3, 0
m1add: #if !(9 >= a0)
	li t0, 9
	bge t0, t6 m2add
	li t3, 1
	addi t6, t6, -10
m2add:
	sll t6, t6, t1
	add s1, s1, t6
	slli t2, t2, 4
	addi t1, t1, 4
	li t0, 29
	blt t1, t0 loopadd
	bnez t3, erroroverflowbcd
	mv a0, s1
	pop1 s1
	ret
erroroverflowbcd:
	error "Overflow!"


subbcdmodule:  # int subbcdmodule(int a0, int a1);
	push5 s1, s4, s7, s8, s0
	li s1, 0
	li t0, 0
	li t3, 0
	li t4, 0
	li t5, 4
	li t6, 29
	li s4, 0x000000f0
loopsub:
	and s7, a0, s4
	and s8, a1, s4
	srl s7, s7, t5
	srl s8, s8, t5
	bge s7, s8, m1sub # if s7 < s8 (s7 >= s8)
	addi s7, s7, 10
	mv t4, s4
	mv t3, t5
nextdigit:
	slli t4, t4, 4
	addi t3, t3, 4
	and t1, a0, t4
	srl t1, t1, t3 # next digit s1 in t1
	bgtz t1, greaterzero #if t1 == 0 (t1 > 0)
	li t1, 9
	sll t1, t1, t3
	add a0, a0, t1
	j nextdigit
greaterzero: # else if t1 > 0
	li t1, 1
	sll t1, t1, t3
	sub a0, a0, t1
m1sub:
	sub t0, s7, s8
	sll t0, t0, t5
	add s0, s0, t0
	slli s4, s4, 4
	addi t5, t5, 4
	blt t5, t6 loopsub
	mv a0, s0
	pop5 s1, s4, s7, s8, s0
	ret


printbcd:  # void printbcd(int);
	push4 ra, s1, s2, s3
	li s1, 28
	li s2, 0xf0000000
	mv s3, a0
	li t0, 0xf
	and t0, s3, t0
	li t1, 0xa
	beq t0, t1, loopprintbcd
	li a0, '-'
	printch
loopprintbcd:
	and a0, s3, s2
	srl a0, a0, s1
	call decimaltochar
	printch
	srli s2, s2, 4
	addi s1, s1, -4
	li t0, 4
	bge s1, t0, loopprintbcd
	pop4 ra, s1, s2, s3
	ret