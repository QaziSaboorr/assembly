
li	s2,1
l1:
beq	zero,s2,l2
li t1, 0x00401034
li t2, 0x004010a8
addi	s2,s2,-1
j	l1
l2:
sub t3,t1,t2


li	t4,0x0040001c
li	t5,0x00400004
#li	t4,0x00401038
#li	t5, 0x004010ac

sub	t6,t5,t4




