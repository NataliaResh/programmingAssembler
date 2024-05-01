start:
	j test

.include "macrosLib.asm"
.include "stringLib.asm"
.include "teststrchr.asm"
.include "testLib.asm"

.eqv CALL_FUNC strchr
.eqv FUNC_NAME "strchr"

test:
	START
	OK 0 "abcde" 'a'
	OK 3 "fffwwqw" 'w'
	OK 2 "abcde" 'a'
	OK 3 "abc", '\0'
	NONE "abcdef" 'Q'
	NONE "" '?'
	NONE "abcde" 'e'
	DONE
	exit 0