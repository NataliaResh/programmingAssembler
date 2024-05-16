.include "testLib.asm"


.macro OK %str %ch
.end_macro

OK 1 "abcd" 'b'
NONE "abcd" 'q'
NONE "" 'x'
OK 0 "xxx", 'x'
OK 5 "abcde", '\0'

DONE