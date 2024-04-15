start:
	j main


.include "macrosLib.asm"
.include "decimalLib.asm"


main:
	call readdecimal
	mv s1, a0
	call readdecimal
	mv a1, a0
	mv a0, s1
	call udivAB
	mv s1, a1
	call printdecimal
	printendl
	mv a0, s1
	call printdecimal
exit:
	exit 0
