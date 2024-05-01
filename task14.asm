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
	li t0, 2
	bge s10, t0, parseargv
	error "Need more args!"
parseargv:
	lw t1, 0(s11)
	lb t2, 0(t1)
	li t0, '-'
	bne t2, t0, L1
	lb t2, 1(t1)
	checkarg 'v', 8, checkn
checkn:
	checkarg 'n', 4, checkc
checkc:
	checkarg 'c', 2, checki
checki:
	checkarg 'i', 1, errorparse
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
	li t0, 2
	beq t1, t0, maingrep
	error "Need more args!"
maingrep:
	lw s2, 0(s11)  #  str
	lw s1, 4(s11)  #  file
	mv a0, s1
	li a1, O_READ
	call open
	mv s1, a0  # fd
	call flenght
	mv a1, s1
	call load
	call split
	mv a2, s2
	mv a3, s4
	call grep
	mv a0, s1
	call close
	exit 0
