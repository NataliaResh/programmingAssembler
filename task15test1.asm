start:
	j test

.include "macrosLib.asm"
.include "stringLib.asm"
.include "teststrspn.asm"
.include "testLib.asm"

.eqv CALL_FUNC strspn
.eqv FUNC_NAME "strspn"

test:
	START
	OK 1 "abcde", "a"
	OK 4 "abcade", "bac"
	OK 0 "abc abcca", " "
	OK 0 "", "ca"
	OK 0 "", ""
	OK 0 "aaa", "b"
	OK 4 "aabsbdfdf", "bac"
	OK 3 "a a", "a"
	OK 4 "0123A", "30"
	OK 3 "aaa", "abc"
	DONE
	exit 0
