.macro OK %ans %str1 %str2
.data
str1: .asciz %str1
str2: .asciz %str2
.text
	la a0, str1
	la a1, str2
	mv s1, a0
	mv s2, a1
	li s3, %ans
	li a2, 0
	call CALL_FUNC
	mv s4, a0
	beqz a0, OKtestfaliednone
	sub s4, s4, s1
	bne s3, s4, OKtestfalied
	addi s5, s5, 1
	j endOKtest
OKtestfalied:
	message "Test falied: "
	message FUNC_NAME
	message "(“"
	messageS s1
	message "”, ”"
	messageS s2
	message "”) results in OK("
	messageI s3
	message "), expected OK("
	messageI s4
	message ")\n"
	addi s6, s6, 1
	j endOKtest
OKtestfaliednone:
	message "Test falied: "
	message FUNC_NAME
	message "(“"
	messageS s1
	message "”, ”"
	messageS s2
	message "”) results in OK("
	messageI s2
	message "), expected NONE\n"
	addi s6, s6, 1
endOKtest:
.end_macro


.macro NONE %str1 %str2
.data
str1: .asciz %str1
str2: .asciz %str2
.text
	la a0, str1
	la a1, str2
	mv s1, a0
	mv s2, a1
	li a2, 0
	call CALL_FUNC
	mv s4, a0
	bnez s4, NONEtestfalied
	addi s5, s5, 1
	j endNONEtest
NONEtestfalied:
	message "Test falied: "
	message FUNC_NAME
	message "(“"
	messageS s1
	message "”, ”"
	messageS s2
	message "”) results in NONE, expected OK("
	sub s4, s4, s1
	messageI s4
	message ")\n"
	addi s6, s6, 1
endNONEtest:
.end_macro
