start:
	j main


.include "macrosLib.asm"
.include "decimalLib.asm"


main:
	call readdecimal
	call isqrt
	call printdecimal
	printendl
	call readdecimal
	call icbrt
	call printdecimal
exit:
	exit 0
