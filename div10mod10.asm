start:
	j main


.include "macrosLib.asm"
.include "hexLib.asm"
.include "decimalLib.asm"
	
	
main:
	call readdecimal
	mv s1, a0
	call div10
	printendl
	call printdecimal
	
	mv a0, s1
	call mod10
	printendl
	call printdecimal
exit:
	exit 0
