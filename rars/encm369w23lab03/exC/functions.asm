# functions.asm
# ENCM 369 Winter 2023
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
	
	#global variable 
	.data
	#int train = 0x20000
	.globl train
train: .word 0x20000
	
	.text
	.globl	main
main:	

	
	#prologue
	addi 	sp,sp, -32
	sw	ra, 8(sp)
	sw	s1, 4(sp)
	sw 	s0, 0(sp)	
	#body
	#so = plane
	#s1 = boat
	li 	s0, 0x3000 #plane
	li	s1, 0xa000 #boat
	li	a0, 6
	li	a1 , 4
	li	a2 , 3
	li	a3 , 2
	jal	procA
	add	s1,s1,a0
	sub	t0,s1,s0	#t0 = boat - plane
	la	t1,train
	lw	t2, (t1) 	#t2 = train
	add	t2,t2,t0
	sw	t2, (t1)
	
	
	
	#epilogue
	
	lw	ra, 8(sp)
	lw	s1, 4(sp)
	lw 	s0, 0(sp)
	addi 	sp,sp,32
	li      a0, 0   # return value from main = 0
	jr	ra
	
	.globl 	procA
procA:	
	#prologue
	addi 	sp,sp,-32
	sw	ra, 28(sp)
	sw	s6, 24(sp)
	sw	s5 ,20(sp)
	sw	s4 ,16(sp)
	sw	s3, 12(sp)
	sw	s2, 8(sp)
	sw	s1, 4(sp)
	sw	s0, 0(sp)
	mv 	s0,a0 #first
	mv	s1,a1 #second
	mv	s2,a2	#third
	mv	s3,a3	#fourth
	#body	
	
	#s4 = alpha
	#s5 = beta
	#s6 = gamma
	mv	a0, s3
	mv	a1 , s2
	jal	procB
	mv 	s5, a0
	mv	a0,s1
	mv	a1,s0
	jal	procB
	mv	s6,a0
	mv	a0,s2
	mv	a1,s3
	jal	procB
	mv	s4,a0
	add 	t0, s4,s5
	add	a0,t0,s6
		
	
	
	
	
	#epilogue
	lw	ra, 28(sp)
	lw	s6, 24(sp)
	lw	s5 ,20(sp)
	lw	s4 ,16(sp)
	lw	s3, 12(sp)
	lw	s2, 8(sp)
	lw	s1, 4(sp)
	lw	s0, 0(sp)
	addi	sp,sp, 32
	jr	ra
	
	
	.globl procB
procB:	
	
	#body
	slli	t0, a0,8
	add	a0, t0,a1
	jr	ra
