start:
	j main

.include "macrosLib.asm"
.include "hexLib.asm"


main:
	call readhex
	mv s1, a0
	call readhex
	mv s2, a0
	readch #read op
	mv a1, s1
	mv a2, s2
	call op  # op(a0, a1, a2)
	mv s1, a0  # result in s1
	printendl
	mv a0, s1
	call printhex
exit:
	exit 0