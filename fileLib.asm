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
	
	
.macro lseek  #  int lseek(int fd, int offset, int flag);
	syscall 62
	li t0, -1
	beq a0, t0, flenghterror
.end_macro


.macro sbrk
	syscall 9
.end_macro


.macro read  #  int read(int fd, int addr, int len)
	syscall 63
.end_macro


load:  #  int load(int size, int fb);
	push2 s1, s2
	mv s1, a0
	mv s2, a1
	addi a0, a0, 1
	sbrk
	li t0, 0
	add t1, a0, s1
	sb t0, 1(t1)  #  add \0 to end
	mv a1, a0
	mv a0, s2
	mv a2, s1
	read
	li t0, 0
	beq t0, a0, errorread
	pop2 s1, s2
	ret
errorread:
	error "Can't read file"
	
		
flenght:  #  int flenght(int fd);
	mv t1, a0  #  fd
	li a1, 0
	li a2, 1
	lseek
	mv t2, a0  #  curret position
	mv a0, t1
	li a1, 0
	li a2, 2
	lseek
	mv t3, a0  #  len
	mv a0, t1
	mv a1, t2
	li a2, 0
	lseek
	mv a0, t3
	ret
flenghterror:
	error "Some error!"
