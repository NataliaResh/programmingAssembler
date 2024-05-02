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
	call CALL_FUNC
	mv s4, a0
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
endOKtest:
.end_macro
