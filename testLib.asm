.macro START
	message "Testing function "
	message FUNC_NAME
	message "...\n"
	li s5, 0  #   passed
	li s6, 0  #  failed
.end_macro


.macro DONE
	message "Passed: "
	messageI s5
	message ", failed: "
	messageI s6
	message "\n"
.end_macro