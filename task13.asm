start:
	j main
	
	
.include "macrosLib.asm"
.include "fileLib.asm"
.include "stringLib.asm"

	
main:
	mv s10, a0  #  argc
	mv s11, a1  #  argv
	
	li t0, 1
	bge s10, t0, L1
	error "Need file name arg!"
	
L1:
	lw s1, 0(s11)  #  s0: argv[0]	
	mv a0, s1
	li a1, O_READ
	call open
	mv s1, a0  # fd
	call flenght
	mv a1, s1
	call load
	call split
	li a2, 1
	li t0, 1
	beq s10, t0, printans
	mv s2, a0
	mv s3, a1
	lw a0, 4(s11)
	call strtoint
	mv a2, a0
	mv a0, s2
	mv a1, s3
	
	sub a2, a1, a2
	addi a2, a2, 1

printans:
	
	call printlines
	printendl
	mv a0, s1
	call close
	exit 0