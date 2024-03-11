start:
	j main


.include "macrosLib.asm"
.include "hexLib.asm"
.include "decimalLib.asm"


main:
	call readdecimal
	call printdecimal
	printendl
exit:
	exit 0