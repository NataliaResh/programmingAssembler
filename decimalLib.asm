#  char chartodecimal(char);
#  char decimaltochar(char);
#  void printdecimal(int);
#  int lendecimal(int)
#  int mul10(int)
#  int div10(int)
#  int mod10(int)


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


lendecimal:  #  int lendecimal(int)
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


div10:  #  int div10(int)
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


mod10:  #  int mod10(int)
	push2 ra, s1
	mv s1, a0
	call div10
	call mul10
	sub a0, s1, a0
	pop2 ra, s1
	ret
	
	
printdecimal:  # void printdecimal(int);
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
