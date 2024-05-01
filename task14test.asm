start:
	j test

.include "macrosLib.asm"
.include "stringLib.asm"
.include "teststrstr.asm"
.include "testLib.asm"

.eqv CALL_FUNC strstr
.eqv FUNC_NAME "strstr"

test:
	START
	OK 0 "abcde", "a"
	OK 5 "abcde", ""
	OK 0 "abc abcca", "abc"
	OK 7 "abc abcca", "ca"
	OK 0 "", ""
	OK 2 "aaa", "aa"
	OK 0 "abcde", "e"
	NONE "abcde", "aa"
	NONE "", "a"
	NONE " ", " "
	NONE "  abc", "d"
	DONE
	exit 0