# stub1.asm
# ENCM 369 Winter 2023 Lab 2
# This program has complete start-up and clean-up code, and a "stub"
# main function.

# BEGINNING of start-up & clean-up code.  Do NOT edit this code.
	.data
exit_msg_1:
	.asciz	"***About to exit. main returned "
exit_msg_2:
	.asciz	".***\n"
main_rv:
	.word	0
	
	.text
	# adjust sp, then call main
	andi	sp, sp, -32		# round sp down to multiple of 32
	jal	main
	
	# when main is done, print its return value, then halt the program
	sw	a0, main_rv, t0	
	la	a0, exit_msg_1
	li      a7, 4
	ecall
	lw	a0, main_rv
	li	a7, 1
	ecall
	la	a0, exit_msg_2
	li	a7, 4
	ecall
        lw      a0, main_rv
	addi	a7, zero, 93	# call for program exit with exit status that is in a0
	ecall
# END of start-up & clean-up code.

# Below is the stub for main. Edit it to give main the desired behaviour.
	
	.data
	.globl alpha
alpha: .word 0xb1, 0xe1,0x91,0xc1,0x81,0xa1,0xf1,0xd1
	.globl beta
beta:	.word 0x0,0x10,0x20,0x30,0x40,0x50,0x60,0x70

	.text
	.globl	main
	#int main (void)
	#
	#local variable 		register
	#int *p				so
	#int *guard			s1
	#int min 			s2
	#int j				s3
	#int k				s4
main:
	la 	s0, alpha		#p = &alpha
	addi 	s1, s0, 32		#guard p + 8
	lw	t0, (s0)		#t0 = *p
	add	s2,t0,zero		#min = *p
	addi	s0,s0,4			#p++
L1:
	beq 	s0,s1,L3		#if (p == guard) goto L3
	bge 	t0,s2,L2		#if (*p >= min) goto L2
	add 	s2,t0,zero		#min = *p
L2:	
	addi	s0,s0,4			#p++
	lw	t0,(s0)			#to = *p
	j	L1			#goto L1
L3:
	add 	s3,zero,zero		#j = 0
	addi 	s4, zero, 7		#s4 = 7
	addi	s5, zero, 8		#s5 = 8
	
L4:	
	bge	s3, s5, L5		#if( j>=s5) goto L5 
	slli	t0,s4,2			#t0 = s4 * 4
	la 	t1, beta		#t1 = &beta
	add	t2,t1,t0		#t2 = t1 + t0 this sets the offset
	lw	t3,(t2)			#t3 = t2
	slli	t4,s3,2			#t4 = s3 * 4
	la	t5, alpha		#t5 = &alpha
	add	t6,t4,t5		#t6 = t4 + t5 this sets the offset
	sw	t3,(t6)			#&t6 = t3
	addi	s3,s3,1			#j++
	addi	s4,s4,-1		#k--
	j	L4			#goto L4
	
L5:
	add	a0,zero,zero		
	jr	ra	
	
	
	
	
	
	
	
	
	
	
	
	li      a0, 0   # return value from main = 0
	jr	ra
