#  char chartodecimal(char);rtobcd(char);
#  char decimaltochar(char);
# void printdecimal(int);
#  int div10n(int a, int n);
#  int lendecimal(int)


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
	
	
readdecimal:  #  int readdecimal();
	push3 ra, s1, s2
	li s2, 1
	li s1, 0
	readch
	li t0, 10
	beq a0, t0, endreaddecimal
	call chartodecimal
	add s1, s1, a0
	addi s2, s2, 1
loopreaddecimal:
	readch
	li t0, 10
	beq a0, t0, endreaddecimal
	li t0, 8
	bge s2, t0, errorreaddecimal
	call chartodecimal
	swap s1, a0
	call mul10
	swap s1, a0
	add s1, s1, a0
	addi s2, s2, 1
	j loopreaddecimal
endreaddecimal:
	mv a0, s1
	pop3 ra, s1, s2
	ret
errorreaddecimal:
	error "Maximum number of characters exceeded!"
	ret


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


div10n:  #  int div10n(int a, int n);
	push2 ra, s1
	mv s1, a1
	beqz s1, endloopdiv10n
loopdiv10n:
	call div10
	addi s1, s1, -1
	bnez s1, loopdiv10n
endloopdiv10n:
	pop2 ra, s1
	ret


printdecimal:  # void printdecimal(int);
	push3 ra, s1, s2
	mv s1, a0
	call lendecimal
	mv s2, a0
	addi s2, s2, -1
loopprintdecimal:
	mv a0, s1
	mv a1, s2
	call div10n
	call mod10
	call decimaltochar
	printch
	addi s2, s2, -1
	li t0, 0
	bge s2, t0, loopprintdecimal
	pop3 ra, s1, s2
	ret