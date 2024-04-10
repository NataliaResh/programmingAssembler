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
	mv s1, a1
	mv s2, a0
	call lenbinary
	swap a0, a1
	call lenbinary # s2 = a, a1 = len a, s1 = b, a0 = len b
	li t6, 0 #  result
	li t1, 0xffffffff
	sub t0, a1, a0  #  diff len a and b
	sll t1, t1, t0
	sll s1, s1, t0
udivABloop:
	and t2, s2, t1  #  t2 = tmp dividend
	slli t6, t6, 1
	# if (t2 >= b(s1)) :
	bgt s1, t2, endudivABloop
	addi t6, t6, 1
	sub s2, s2, s1
endudivABloop:
	srli t1, t1, 1
	srli s1, s1, 1
	addi t0, t0, -1
	bgez t0, udivABloop
	
	mv a0, t6
	pop3 ra, s1, s2
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
