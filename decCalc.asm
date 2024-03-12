start:
	j main
	
.include "macrosLib.asm"
.include "decimalLib.asm"


main:	
	call readdecimal
	mv s1, a0
	call readdecimal
	mv s2, a0
	readch #read op
	mv a1, s1
	mv a2, s2
	call opdecimal
	mv s1, a0
	printendl
	mv a0, s1
	call printdecimal
exit:
	exit 0
