start:
	j main


.include "macrosLib.asm"
.include "hexLib.asm"


main:
	call readhex
	mv s1, a0
	call readhex
	mv a1, a0
	mv a0, s1
	call mulhex
	printendl
	call printhex
exit:
	exit 0