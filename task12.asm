start:
	j main
	
	
.include "macrosLib.asm"
.include "fileLib.asm"
.include "stringLib.asm"

	
main:
	mv s10, a0  #  argc
	mv s11, a1  #  argv
	
	li t0, 1
	beq s10, t0, L1
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
	call countlines
	mv s2, a0
	message "Count lines: "
	messageI s2
	printendl
	mv a0, s1
	call close
	exit 0