start:
	j main


.include "macrosLib.asm"
.include "hexLib.asm"
.include "decimalLib.asm"
	
	
main:
	call readhex
	mv s1, a0
	call div10
	printendl
	call printhex
	
	mv a0, s1
	call mod10
	printendl
	call printhex
exit:
	exit 0
