#  char chartodecimal(char);
#  char decimaltochar(char);
#  int readdecimal();
#  void printdecimal(int);
#  int lendecimal(int);
#  int lenbinary(int);
#  int mul10(int);
#  int div10(int);
#  int mod10(int);
#  int sdivAB(int, int);
#  int udivAB(int, int);
#  int insqrt(int);


chartodecimal:  #  char chartodecimal(char);
	li t0, 58
	bge a0, t0, errorchartodecimal
	li t0, 48
	blt a0, t0, errorchartodecimal
	addi a0, a0, -48
	ret
errorchartodecimal:
	error "Inncorect symbol!"


decimaltochar:  #  char decimaltochar(char);
	li t0, 10
	bge a0, t0, errordecimaltochar
	addi a0, a0, 48
	ret
errordecimaltochar:
	error "Inncorect symbol!"


.macro addwithcheck %r1 %r2 %r3
	add %r1, %r2, %r3
	slt t0, %r3, zero
	slt t1, %r1, %r2
	beq t0, t1, endaddwithcheck
	error "Overflow!"
endaddwithcheck:
.end_macro


readdecimal:  #  int readdecimal();
	push3 ra, s1, s3
	li s1, 0
	li s3, 0
	readch
	li t0, 10
	beq a0, t0, endreaddecimal
	li t0, '-'
	bne a0, t0, positive
	addi s3, s3, 1
	j loopreaddecimal
positive:
	call chartodecimal
	add s1, s1, a0
loopreaddecimal:
	readch
	li t0, 10
	beq a0, t0, endreaddecimal
	call chartodecimal
	swap s1, a0
	call mul10
	addwithcheck t3, s1, a0
	mv s1, t3
	j loopreaddecimal
endreaddecimal:
	beqz s3, movedecimal
	neg s1, s1
movedecimal:
	mv a0, s1
	pop3 ra, s1, s3
	ret


opdecimal:  # int opdecimal(char op, int a, int b);
	li t0, '+'
	beq a0, t0, addopdecimal
	li t0, '-'
	bne a0, t0, erroropdecimal
	neg a2, a2
addopdecimal:
	addwithcheck a0, a1, a2
	ret
erroropdecimal:
	error "Inncorect operator!"


lendecimal:  #  int lendecimal(int);
	push2 ra, s1
	li s1, 0
looplendecimal:
	call div10
	addi s1, s1, 1
	bgtz a0, looplendecimal
	mv a0, s1
	pop2 ra, s1
	ret


mul10:  #  int mul10(int)
	li t0, 214748364
	bge a0, t0, muloverflowerror
	slli t0, a0, 3
	add t0, t0, a0
	add a0, t0, a0
	ret
muloverflowerror:
	error "Overflow!"


mulAB:  #  int mulAB(int, int);
	li t0, 1
	li t1, 0
	li t3, 0  # result
mulloop:
	and t2, a1, t0
	beqz t2, endmulloop
	sll t2, a0, t1
	add t3, t3, t2
endmulloop:
	slli t0, t0, 1
	addi t1, t1, 1
	bnez t0, mulloop
	mv a0, t3
	ret
	
div10:  #  int div10(int);
	push3 ra, s1, s2
	mv s2, a0
	li s1, 0
	li t0, 10
	blt a0, t0, enddiv10
	mv s1, a0
	srli a0, a0, 2
	call div10
	srli s1, s1, 3
	sub s1, s1, a0
enddiv10:
	mv a0, s1
	call mul10
	slt a0, s2, a0
	sub a0, s1, a0
	pop3 ra, s1, s2
	ret


mod10:  #  int mod10(int);
	push2 ra, s1
	mv s1, a0
	call div10
	call mul10
	sub a0, s1, a0
	pop2 ra, s1
	ret

	
lenbinary:  #  int lenbinary(int);
	li t0, 0
lenbinaryloop:
	srli a0, a0, 1
	addi t0, t0, 1
	bnez a0, lenbinaryloop
	mv a0, t0
	ret

sdivAB:  #  int sdivAB(int, int);
	push2 ra, s1
	li s1, 0
	bgez a0, secondnumbersdivAB
	neg a0, a0
	addi s1, s1, 1
secondnumbersdivAB:
	bgez a1, calcsdivAB
	neg a1, a1
	addi s1, s1, -1
calcsdivAB:
	call udivAB
	beqz s1, endsdivAB
	neg a0, a0
endsdivAB:
	pop2 ra, s1
	ret

	
udivAB:  #  int udivAB(int, int);
	push3 ra, s1, s2
	beqz a1, errorzerodiv
	mv s1, a1
	mv s2, a0
	swap a0, a1
	call lenbinary  # s2 = a, s1 = b, a0 = len b
	neg a0, a0
	addi t0, a0, 31
	sll s1, s1, t0
	li t6, 0 #  result
udivABloop:
	li t1, -1
	sll t1, t1, t0
	and t2, s2, t1  #  t2 = tmp dividend
	slli t6, t6, 1
	# if (t2 >= b(s1)) :
	bgt s1, t2, endudivABloop
	addi t6, t6, 1
	sub s2, s2, s1
endudivABloop:
	srli s1, s1, 1
	addi t0, t0, -1
	bgez t0, udivABloop
	
	mv a0, t6
	pop3 ra, s1, s2
	ret
errorzerodiv:
	error "Zero division!"
	

modAB:  #  int modAB(int, int);
	push3 ra, s1, s2
	mv s1, a0
	mv s2, a1
	call udivAB
	mv a1, s2
	call mulAB
	sub a0, s1, a0
	pop3 ra, s1, s2
	ret

	
isqrt:  #  int insqrt(int);
	push2 ra, s1
	bltz a0, errorisqrt
	mv s1, a0
	call lenbinary  # a0 = len
	andi t0, a0, 1
	addi a0, a0, -2
	add a0, a0, t0
	li t6, 0 #  result
	li t1, 0xffffffff
	sll t1, t1, a0
isqrtloop:
	and t2, s1, t1  #  t2 = tmp sqrt
	slli t6, t6, 1
	slli t0, t6, 1
	addi t0, t0, 1
	sll t0, t0, a0
	# if (t2 >= t0) :
	bgt t0, t2, endisqrtloop
	addi t6, t6, 1
	sub s1, s1, t0
endisqrtloop:
	srli t1, t1, 2
	addi a0, a0, -2
	bgez a0, isqrtloop
	mv a0, t6
	pop2 ra, s1
	ret
errorisqrt:
	error "Sqrt from negative number!"


icbrt:  #  int icbrt(int);
	push5 ra, s1, s2, s3, s4
	push2 s5, s6
	li s6, 0
	bgez a0, mainicbrt
	neg a0, a0
	li s6, 1
mainicbrt:
	mv s1, a0  #  s1 = number
	call lenbinary
	mv s2, a0  #  s2 = len
	li a1, 3
	call modAB
	sub s2, s2, a0
	mv a0, s2
	li s3, 0 #  result
	li s4, 0xffffffff
	sll s4, s4, s2
icbrtloop:
	mv a0, s3
	mv a1, s3
	call mulAB
	li a1, 12
	call mulAB
	mv s5, a0  #  1100 * s3 * s3
	mv a0, s3
	li a1, 6
	call mulAB
	add a0, a0, s5
	addi a0, a0 1  #  s5 + 110 * s3 + 1
	sll a0, a0, s2
	and t2, s1, s4  #  t2 = tmp sqrt
	slli s3, s3, 1
	# if (t2 >= a0) :
	bgt a0, t2, endicbrtloop
	addi s3, s3, 1
	sub s1, s1, a0
endicbrtloop:
	srli s4, s4, 3
	addi s2, s2, -3
	bgez s2, icbrtloop
	beqz s6, mainendicbrt
	neg s3, s3
mainendicbrt:
	mv a0, s3
	pop2 s5, s6
	pop5 ra, s1, s2, s3, s4
	ret

	
printdecimal:  #  void printdecimal(int);
	push3 ra, s1, s2
	li s2, 0
	mv s1, a0
	bgez a0, digitstostack
	li a0, '-'
	printch
	neg s1, s1
	mv a0, s1
digitstostack:
	call mod10
	push1 a0
	mv a0, s1
	call div10
	mv s1, a0
	addi s2, s2, 1
	bnez a0, digitstostack
loopprintdecimal:
	pop1 a0
	call decimaltochar
	printch
	addi s2, s2, -1
	bnez s2, loopprintdecimal
	pop3 ra, s1, s2
	ret
