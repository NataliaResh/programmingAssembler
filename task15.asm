start:
	j main


.include "macrosLib.asm"
.include "fileLib.asm"
.include "stringLib.asm"


.macro checkarg %arg, %f, %label
	li t0, %arg
	bne t2, t0, %label
	#andi t0, s4, %f
	#bnez t0, errorparse
	addi s4, s4, %f
	j endparse
.end_macro

main:
	mv s10, a0  #  argc
	mv s11, a1  #  argv
	li s4, 0  #  flags
	li s5, 0  #  count
	li t0, 1
	bge s10, t0, parseargv
	error "Need more args!"
parseargv:
	lw t1, 0(s11)
	lb t2, 0(t1)
	li t0, '-'
	bne t2, t0, L1
	lb t2, 1(t1)
	checkarg 'l', 8, checkn
checkn:
	checkarg 'w', 4, checkc
checkc:
	checkarg 'c', 2, checki
checki:
	checkarg 'L', 1, errorparse
endparse:
	lb t2, 2(t1)
	bnez t2, errorparse
	addi s5, s5, 1
	addi s11, s11, 4
	j parseargv
errorparse:
	error "Incorrect flag!"
L1:
	sub t1, s10, s5
	li t0, 1
	beq t1, t0, mainwc
	error "Need more args!"
mainwc:
	lw s1, 0(s11)  #  file
	mv a0, s1
	li a1, O_READ
	call open
	mv s1, a0  # fd
	call flenght
	mv s2, a0
	mv a1, s1
	call load
	mv a1, s2
	mv a2, s4
	call wc
	mv a0, s1
	call close
	exit 0
