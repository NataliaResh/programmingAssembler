start:
	j test

.include "macrosLib.asm"
.include "stringLib.asm"
.include "teststrspn.asm"
.include "testLib.asm"

.eqv CALL_FUNC strcspn
.eqv FUNC_NAME "strcspn"

test:
	START
	OK 0 "abcde", "a"
	OK 1 "abcade", "bd"
	OK 3 "abc abcca", " "
	OK 0 "", "ca"
	OK 0 "", ""
	OK 3 "aaa", "b"
	OK 3 "aabsbdfdf", "sdc"
	OK 3 "a a", ""
	OK 0 "0123A", "a"
	OK 3 "aaa", "abc"
	DONE
	exit 0
