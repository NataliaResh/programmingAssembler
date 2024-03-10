start:
	j main
	
.include "macrosLib.asm"


chartobcd:  # char chartobcd(char)
	li t0, 58
	bge a0, t0, errorchartobcd
	li t0, 48
	blt a0, t0, errorchartobcd
	addi a0, a0, -48
	ret
errorchartobcd:
	error "Inncorect symbol!"


readbcd:  # int readbcd();
	push4 ra, s1, s2, s3
	li s2, 1
	li s1, 0
	li s3, 8
	readch
	li t0, 10
	beq a0, t0, endreadbcd
	li t0, 45
	beq a0, t0, addminus
	call chartobcd
	add s1, s1, a0
	slli s1, s1, 4
	addi s2, s2, 1
addminus:
	addi s3, s3, 1
loopreadbcd:
	readch
	li t0, 10
	beq a0, t0, endreadbcd
	li t0, 8
	bge s2, t0, errorreadbcd
	call chartobcd
	add s1, s1, a0
	slli s1, s1, 4
	addi s2, s2, 1
	j loopreadbcd
endreadbcd:
	add s1, s1, s3
	mv a0, s1
	pop4 ra, s1, s2, s3
	ret
errorreadbcd:
	error "Maximum number of characters exceeded!"


bcdtochar:
	li t0, 10
	bge a0, t0, errorbcdtochar
	addi a0, a0, 48
	ret
errorbcdtochar:
	error "Inncorect symbol!"
	

opbcd:  # int opbcd(char a0, int a1, int a2);
	addi sp, sp, -4
	sw ra, 0(sp)
	li t0, 43
	bne a0, t0, subop
	mv a0, a1
	mv a1, a2
	call addbcd
	printch
	j endopbcd
subop:
	li t0, 45
	bne a0, t0, erroropbcd
	mv a0, a1
	mv a1, a2
	call subbcd
endopbcd:
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
erroropbcd:
	error "Incorrect operation!"


addbcd:  # int add(int a0, int a1);
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
	slli s1, s1, 4
	add s1, s1, t6
	slli t2, t2, 4
	addi t1, t1, 4
	li t0, 29
	blt t1, t0 loopadd
	slli s1, s1, 4
	li a0, 1
	printch
	li a0, 0
	printch
	mv a1, s1
	printch
	pop1 s1
	ret


subbcd:  # int subbcd(int a0, int a1);
	push1 s1
	li t1, 0
	li t2, 0x000000f0
	li t3, 0
	li t4, 0
	li t6, 0
	li s1, 0  # result
	li t5, 4
loopsub:
	and a2, a0, t2
	and a3, a1, t2
	srl a2, a2, t5
	srl a3, a3, t5
	bge a2, a3, m1sub
	addi a2, a2, 10
	mv t4, t2
	mv t3, t5
nextdigit:
	slli t4, t4, 4
	addi t3, t3, 4
	and t1, s1, t4
	srl t1, t1, t3 # next digit s1 in t1
	bgtz t1,greaterzero #if t1 == 0 (t1 > 0)
	li t1, 9
	sll t1, t1, t3
	add a0, a0, t1
	j nextdigit
greaterzero:  # else if t1 > 0
	li t1, 1
	sll t1, t1, t3
	sub a0, a0, t1
m1sub:
	sub t6, a2, a3
	slli s1, s1, 4
	add s1, s1, t6
	slli t2, t2, 4
	addi t5, t5, 4
	li t0, 29
	blt t5, t0 loopsub
	slli s1, s1, 4
	mv a0, s1
	pop1 s1
	ret


printbcd:  # void printbcd(int)
	push4 ra, s1, s2, s3
	li s1, 4
	li s2, 0x000000f0
	mv s3, a0
loopprintbcd:
	and a0, s3, s2
	srl a0, a0, s1
	call bcdtochar
	printch
	slli s2, s2, 4
	addi s1, s1, 4
	li t0, 29
	blt s1, t0, loopprintbcd
	pop4 ra, s1, s2, s3
	ret
	

main:	
	call readbcd
	mv s1, a0
	call readbcd
	mv s2, a0
	readch #read op
	mv a1, s1
	mv a2, s2
	call opbcd
	mv s1, a0
	printendl
	mv a0, s1
	call printbcd
exit:
	exit 0
