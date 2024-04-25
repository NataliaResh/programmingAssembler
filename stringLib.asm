.include "decimalLib.asm"

strchr:  #  char* strchr(char* str, char ch)
	addi a0, a0, -1
strchrloop:
	addi a0, a0, 1
	lb t1, 0(a0)
	beq t1, zero, endstrchr
	bne t1, a1, strchrloop
endstrchr:
	beq t1, a1, retstrchr
	li a0, 0
retstrchr:
	ret
	

countlines:  #  int countlines(char*  str)
	push2 ra, s1
	li s1, 0  # ans
	addi a0, a0, -1
countlinesloop:
	addi s1, s1, 1
	addi a0, a0, 1
	li a1, '\n'
	call strchr
	bnez a0, countlinesloop
	mv a0, s1
	pop2 ra, s1
	ret
	

split:  #  char** split(char*  str)
	push5 ra, s1, s2, s3, s4
	mv s1, a0  #  str
	call countlines
	mv s2, a0  #  count lines
	slli a0, a0, 2
	sbrk
	mv s3, a0  #  array
	mv s4, a0  #  i
	mv a0, s1
	call strchr
splitloop:
	beqz a0, endsplitloop
	sb zero, 0(a0)
	sw s1, 0(s4)
	addi s4, s4, 4
	addi a0, a0, 1
	mv s1, a0
	li a1, '\n'
	call strchr
	j splitloop
endsplitloop:
	sw s1, 0(s4)
	mv a0, s3
	mv a1, s2
	pop5 ra, s1, s2, s3, s4
	ret


strtoint:  #  int strtoint(char* str)
	push4 ra, s1, s2, s3
	mv s1, a0
	li s2, 0  #  ans
	lb a0, 0(s1)
strtointloop:
	beqz a0, endstrtointloop
	call chartodecimal
	mv s3, a0
	mv a0, s2
	call mul10
	add s2, a0, s3
	addi s1, s1, 1
	lb a0, 0(s1)
	j strtointloop
endstrtointloop:
	mv a0, s2
	pop4 ra, s1, s2, s3
	ret	

	
printlines:  #  void printlines(char** array, int size, int start)
	push3 ra, s1, s2
	blez a2, errorprintlines
	bge a2, a1, errorprintlines
	mv t0, a2
	addi a2, a2, -1
	slli a2, a2, 2
	add s1, a0, a2
	mv s2, a1
	addi s2, s2, 1
printlinesloop:
	messageI t0
	lw t1, 0(s1)
	message ":\t "
	messageS t1
	printendl
	addi s1, s1, 4
	addi t0, t0, 1
	bne t0, s2, printlinesloop
	pop3 ra, s1, s2
	ret
errorprintlines:
	error "Incorrect start index!"