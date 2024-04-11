.eqv O_READ 0
.eqv O_WRITE 1
.eqv O_APPEND 9

open:  #  int open(char* name, int flags); 
	syscall 1024
	li t0, -1
	beq a0, t0, openerror
	ret
openerror:
	error "Cannot open file!"
	
close:  #  int close(int fd);
	syscall 57
	ret
	
read:  #  void read(int fd, char* buf, int size);
	mv, t2, a2
	syscall 63
	bne a0, t2, readerror
	ret
readerror:
	error "Cannot read file!"
	
	
.macro lseek
	syscall 62
	li t0, -1
	beq a0, t0, flenghterror
.end_macro

		
flenght:
	mv t1, a0
	li a1, 0
	li a2, 1
	lseek
	mv t2, a0
	mv a0, t1
	li a1, 0
	li a2, 2
	lseek
	mv t3, a0
	mv a0, t1
	mv a1, t2
	li a2, 0
	lseek
	mv a0, t3
	ret
flenghterror:
	error "Some error!"