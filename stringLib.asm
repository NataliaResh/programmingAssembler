.include "decimalLib.asm"

.data
spaces: .asciz " \t\n"
endstr: .asciz "\0"

.text

.macro lowercase %r
	li t0, 'Z'
	bgt %r, t0, endlowercase
	li t0, 'A'
	blt %r, t0, endlowercase
	addi %r, %r, 32
endlowercase:
.end_macro


.macro strstrequal %i, %r1, %r2, %labeln
	beqz %i, strstrnolc
	lowercase %r1
	lowercase %r2
strstrnolc:
	bne %r1, %r2, %labeln
.end_macro


strchr:  #  char* strchr(char* str, char ch, bool i)
	addi a0, a0, -1
strchrloop:
	addi a0, a0, 1
	lb t1, 0(a0)
	beq t1, zero, endstrchr
	strstrequal a2, t1, a1, strchrloop
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
	

split:  #  char**, int split(char*  str)
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
	message ":"
	messageS t1
	printendl
	addi s1, s1, 4
	addi t0, t0, 1
	bne t0, s2, printlinesloop
	pop3 ra, s1, s2
	ret
errorprintlines:
	error "Incorrect start index!"


strstr:  #  char* strstr(char* str1, char* str2, bool i)
	push5 ra, s1, s2, s3, s4
	mv s1, a0  #  str1
	mv s2, a1  #  str2
	mv s4, a2  #  i
	li s3, 0  #  ans
strstrloop:
	lb a1 0(s2)  #  first char
	mv a0, s1
	mv a2, s4
	call strchr
	mv s1, a0
	addi s1, s1, 1
	beqz a0, notfoundstrstr
	li t1, 0  #  index
innerstrstrloop:
	add t4, s2, t1
	lb t4, 0(t4)
	beqz t4, foundstrstr
	add t3, a0, t1
	lb t3, 0(t3)
	beqz t3, notfoundstrstr
	strstrequal s4, t3, t4, strstrloop
	addi t1, t1, 1
	j innerstrstrloop
notfoundstrstr:
	li a0, 0	
foundstrstr:
	pop5 ra, s1, s2, s3, s4
	ret


.macro checkgrepc %labely
	andi t0, s6, 2
	beqz t0, endcheckgrepc
	addi s7, s7, 1
	j %labely
endcheckgrepc:
.end_macro


.macro checkgrepn
	andi t0, s6, 4
	beqz t0, endcheckgrepn
	messageI s4
	message ":"
endcheckgrepn:
.end_macro


grep:  #  void grep(char** array, int size, char* str, int flags (vnci))
	push5, ra, s1, s2, s3, s4
	push3 s5, s6, s7 
	mv s1, a0  #  array
	mv s2, a1  #  size
	mv s3, a2  #  str
	li s4, 1  #  index
	mv s6, a3  #  flags
	li s7, 0  #  count
greploop:
	lw s5, 0(s1)
	mv a0, s5
	mv a1, s3
	andi a2, s6, 1
	call strstr
	beqz a0, notfoundgrep
	andi t0, s6, 8
	bnez t0, greploopend
	checkgrepc greploopend
	checkgrepn
	messageS s5
	printendl
	j greploopend
notfoundgrep:
	andi t0, s6, 8
	beqz t0, greploopend
	checkgrepc greploopend
	checkgrepn
	messageS s5
	printendl
greploopend:
	addi s1, s1, 4
	addi s4, s4, 1
	ble s4, s2, greploop
	andi t0, s6, 2
	beqz t0, grependnotc
	messageI s7
	printendl
grependnotc:
	pop3 s5, s6, s7
	pop5 ra, s1, s2, s3, s4
	ret


strspn:  #  int strspn(char *str, char *sym)
	push4 ra, s1, s2, s3
	mv s1, a0  #  str
	mv s2, a1  #  sym
	li s3, -1  #  ans
strspnloop:
	addi s3, s3, 1
	lb a1, 0(s1)
	beqz a1, strspnend
	mv a0, s2
	li a3, 0
	call strchr
	addi s1, s1, 1
	bnez a0, strspnloop
strspnend:
	mv a0, s3
	pop4 ra, s1, s2, s3
	ret
	

strcspn:  #  int strcspn(char *str, char *sym)
	push4 ra, s1, s2, s3
	mv s1, a0  #  str
	mv s2, a1  #  sym
	li s3, -1  #  ans
strscpnloop:
	addi s3, s3, 1
	lb a1, 0(s1)
	beqz a1, strscpnend
	mv a0, s2
	li a3, 0
	call strchr
	addi s1, s1, 1
	beqz a0, strscpnloop
strscpnend:
	mv a0, s3
	pop4 ra, s1, s2, s3
	ret


wordscount:  #  int wordscount(char* str)
	push4 ra, s1, s2, s3
	mv s1, a0
	la s2, spaces
	li s3, -1  #  ans
wordscountloop:
	addi s3, s3, 1
	lb t0, 0(s1)
	mv a0, t0
	beqz t0, wordscountend
	mv a0, s1
	mv a1, s2
	call strspn
	add s1, s1, a0
	lb t0, 0(s1)
	beqz t0, wordscountend
	mv a0, s1
	mv a1, s2
	call strcspn
	add s1, s1, a0
	bnez a0, wordscountloop
wordscountend:
	mv a0, s3
	pop4 ra, s1, s2, s3
	ret


maxlengh:  #  int maxlengh(char** array, int size)
	push5 ra, s1, s2, s3, s4
	mv s1, a0  #  array
	mv s2, a1  #  size
	la s4, endstr
	li s3, 0
maxlenghloop:
	lw a0, 0(s1)
	mv a1, s4
	call strcspn
	addi s1, s1, 4
	blt a0, s3, nomaxlengh
	mv s3, a0
nomaxlengh:
	addi s2, s2, -1
	bnez s2, maxlenghloop
	mv a0, s3
	pop5 ra, s1, s2, s3, s4
	ret


wc:  #  void wc(char* str, int size, int flags (lwcL))
	push5 ra, s1, s2, s3, s4
	push2 s5, s6
	bnez a2, notchangeflags
	li a2, 14
notchangeflags:
	mv s1, a0  #  str
	mv s2, a1  #  bytes
	mv s3, a2  #  flags
	mv a0, s1
	call wordscount
	mv s6, a0  #  words
	mv a0, s1
	call split
	mv s4, a1  #  lines
	mv s5, a0  #  array
	andi t0, s3, 8
	beqz t0, checkwcw
	messageI s4
	message " "
checkwcw:
	andi t0, s3, 4
	beqz t0, checkwcc
	messageI s6
	message " "
checkwcc:
	andi t0, s3, 2
	beqz t0, checkwcL
	messageI s2
	message " "
checkwcL:
	andi t0, s3, 1
	beqz t0, wcend
	mv a0, s5
	mv a1, s4
	call maxlengh
	messageI a0
wcend:
	pop2 s5, s6
	pop5 ra, s1, s2, s3, s4
	ret
