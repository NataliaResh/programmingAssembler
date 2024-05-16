start:
	j main


.include "macrosLib.asm"
.include "fileLib.asm"
.include "stringLib.asm"


.data
sorted: .asciz ".sorted"

.text
main:
	mv s10, a0  #  argc
	mv s11, a1  #  argv
	li t0, 1
	bge s10, t0, L1
	error "Need more args!"
L1:
	lw s9, 0(s11)  #  file
	mv a0, s9
	li a1, O_READ
	call open
	mv s1, a0  #  fd
	call flenght
	mv s2, a0  #  size
	mv a1, s1
	call load
	call split
	addi a1, a1, -1
	mv s3, a0  #  array
	mv s4, a1  #  array`s size
	li a2, 0
	addi a3, a1, -1
	li a4, 0

	call radixsort
	mv a0, s3
	mv a1, s4
	mv a2, s2
	call join
	mv s5, a0
	mv a0, s9
	la a1, sorted
	call concat
	li a1 O_WRITE
	call open
	mv s6, a0  #  fd
	mv a1, s5
	mv a2, s2
	call write
	mv a0, s1
	call close
	mv a0, s6
	call close
	exit 0
