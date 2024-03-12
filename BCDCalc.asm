start:
	j main
	
.include "macrosLib.asm"
.include "BCDLib.asm"


main:
	call readbcd
	mv s1, a0
	call readbcd
	mv s2, a0
	readch #read op
	mv a1, s1
	mv a2, s2
	call opbcd
	mv s1, a0
	printendl
	mv a0, s1
	call printbcd
exit:
	exit 0
