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
	li t0, '-'
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
	bnez s1, getreusltreadbcd
	li s3, 10
getreusltreadbcd:
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
	xori a3, a3, 1
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
	j endsumbcd
addequalsign:
	call addbcdmodule
	add a0, a0, a2
endsumbcd:
	pop1 ra
	ret


addbcdmodule:  # int addbcdmodule(int a0, int a1);
	push1 s1
	li t1, 4
	li t2, 0xf0
	li t3, 0
	li s1, 0  # result
loopadd:
	and t4, a0, t2  # symbol1
	and t5, a1, t2  # symbol2
	srl t4, t4, t1
	srl t5, t5, t1
	add t6, t4, t5  # resultsymbol
	add t6, t6, t3
	li t3, 0
	li t0, 9
	bge t0, t6 m1add
	li t3, 1
	addi t6, t6, -10
m1add:
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
	push1 s1
	li t1, 4
	li t2, 0xf0
	li t3, 0
	li s1, 0  # result
loopsub:
	and t4, a0, t2  # symbol1
	and t5, a1, t2  # symbol2
	srl t4, t4, t1
	srl t5, t5, t1
	sub t6, t4, t5  # resultsymbol
	add t6, t6, t3
	li t3, 0
	bgez t6 m1sub
	li t3, -1
	addi t6, t6, 10
m1sub:
	sll t6, t6, t1
	add s1, s1, t6
	slli t2, t2, 4
	addi t1, t1, 4
	li t0, 29
	blt t1, t0 loopsub
	mv a0, s1
	pop1 s1
	ret


printbcd:  # void printbcd(int);
	push3 ra, s1, s2
	li s1, 28
	mv s2, a0
	andi t0, s2, 1
	beqz t0, loopprintbcd
	li a0, '-'
	printch
loopprintbcd:
	srl a0, s2, s1
	andi a0, a0, 0xf
	call decimaltochar
	printch
	addi s1, s1, -4
	li t0, 4
	bge s1, t0, loopprintbcd
	pop3 ra, s1, s2
	ret
