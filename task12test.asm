start:
	j test

.include "macrosLib.asm"
.include "fileLib.asm"
.include "stringLib.asm"


.macro OK %ans %str %chr
.data
str: .asciz %str
.text
	la a0, str
	mv s1, a0
	li s2, %ans
	li a1, %chr
	mv s3, a1
	call strchr
	mv s4, a0
	beqz a0, OKtestfaliednone
	sub s4, s4, s1
	bne s2, s4, OKtestfalied
	addi s5, s5, 1
	j endOKtest
OKtestfalied:
	message "Test falied: strchr(“"
	messageS s1
	message "”, '"
	mv a0, s3
	printch
	message "') results in OK("
	messageI s2
	message "), expected OK("
	messageI s4
	message ")\n"
	addi s6, s6, 1
	j endOKtest
OKtestfaliednone:
	message "Test falied: strchr(“"
	messageS s1
	message "”, '"
	mv a0, s3
	printch
	message "') results in OK("
	messageI s2
	message "), expected NONE\n"
	addi s6, s6, 1
endOKtest:
.end_macro


.macro NONE %str %chr
.data
str: .asciz %str
.text
	la a0, str
	mv s1, a0
	li a1, %chr
	mv s3, a1
	call strchr
	mv s4, a0
	bnez s4, NONEtestfalied
	addi s5, s5, 1
	j endNONEtest
NONEtestfalied:
	message "Test falied: strchr(“"
	messageS s1
	message "”, '"
	mv a0, s3
	printch
	message "') results in NONE, expected OK("
	sub s4, s4, s1
	messageI s4
	message ")\n"
	addi s6, s6, 1
endNONEtest:
.end_macro


test:
	message "Testing function strchr...\n"
	li s5, 0  #   passed
	li s6, 0  #  failed
	OK 0 "abcde" 'a'
	OK 3 "fffwwqw" 'w'
	OK 2 "abcde" 'a'
	OK 3 "abc", '\0'
	NONE "abcdef" 'Q'
	NONE "" '?'
	NONE "abcde" 'e'
	message "Passed: "
	messageI s5
	message ", failed: "
	messageI s6
	message "\n"
	exit 0
