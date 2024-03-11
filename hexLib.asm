#  char chartohex();
#  int readhex();
#  char hextochar(char);
#  int op(char op, int a, int b);
#  void printhex(int);
#  int mulhex(int, int);
#  int mul10(int)
#  int div10(int)
#  int mod10(int)


chartohex:  # char chartohex();
	slti t0, a0, 103
	li t1, 1
	bne t0, t1, errorhex
	li t0, 97
	blt a0, t0, big
	addi a0, a0, -87
	ret
big:
	li t0, 71
	bge a0, t0, errorhex
	li t0, 65
	blt a0, t0, number
	addi a0, a0, -55
	ret
number:
	li t0, 58
	bge a0, t0, errorhex
	li t0, 48
	blt a0, t0, errorhex
	addi a0, a0, -48
	ret
errorhex:
	error "Inncorect symbol!"


readhex:  # int readhex();
	push3 ra, s1, s2
	li s2, 0
	li s1, 0
	readch
	li t0, 10
	beq a0, t0, endreadhex
	call chartohex
	add s1, s1, a0
	addi s2, s2, 1
loopreadhex:
	readch
	li t0, 10
	beq a0, t0, endreadhex
	li t0, 8
	bge s2, t0, errorreadhex
	call chartohex
	slli s1, s1, 4
	add s1, s1, a0
	addi s2, s2, 1
	j loopreadhex
endreadhex:
	mv a0, s1
	pop3 ra, s1, s2
	ret
errorreadhex:
	error "Maximum number of characters exceeded!"


hextochar:  # char hextochar(char);
	li t0, 10
	bge a0, t0, char
	addi a0, a0, 48
	ret
char:
	addi a0, a0, 87
	ret


op:  # int op(char op, int a, int b);
	li t0, 43
	bne a0, t0, subop
	add a0, a1, a2
	ret
subop:
	li t0, 45
	bne a0, t0, andop
	sub a0, a1, a2
	ret
andop:
	li t0, 38
	bne a0, t0, orop
	and a0, a1, a2
	ret
orop:
	li t0, 124
	bne a0, t0, errorop
	or a0, a1, a2
	ret
errorop:
	error "Incorrect operation!"
	

mulhex:  #  int mulhex(int, int);
	li t0, 1
	li t1, 0
	li t3, 0  # result
loopop:
	and t2, a1, t0
	beqz t2, endloopop
	sll t2, a0, t1
	add t3, t3, t2
endloopop:
	slli t0, t0, 1
	addi t1, t1, 1
	bnez t0, loopop
	mv a0, t3
	ret


mul10:  #  int mul10(int)
	slli t0, a0, 3
	add t0, t0, a0
	add t0, t0, a0
	mv a0, t0
	ret


div10:  #  int div10(int)
	push2 ra, s1
	li s1, 0
	li t0, 10
	blt a0, t0, enddiv10
	mv s1, a0
	srli a0, a0, 1
	call div10
	srli s1, s1, 2
	sub s1, s1, a0
	srli s1, s1, 1
enddiv10:
	mv a0, s1
	pop2 ra, s1
	ret


mod10:  #  int mod10(int)
	push2 ra, s1
	mv s1, a0
	call div10
	call mul10
	sub a0, s1, a0
	pop2 ra, s1
	ret
	

printhex:  # void printhex(int);
	push4 ra, s1, s2, s3
	li s1, 28
	li s2, 0xf0000000
	mv s3, a0
loopprinthex:
	and a0, s3, s2
	srl a0, a0, s1
	call hextochar
	printch
	srli s2, s2, 4
	addi s1, s1, -4
	bgez s1, loopprinthex
	pop4 ra, s1, s2, s3
	ret
