# excerciseE.asm
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
	.data
	.globl aaa
aaa: 	.word 11,11,3,-11
	.globl bbb
bbb:	.word 200,-300,400,500
	.globl	ccc
ccc:	.word -2,-3,2,1,2,3
	
	
	
	
	.text
	.globl	main 
main:

	#prologue
	addi	sp,sp -32
	sw	ra,12(sp)
	sw	s2,8(sp)
	sw	s2,4(sp)
	sw	s2,0(sp)
	
	#body
	#s0 = red
	#s1 = green
	#s2 = blue
	li 	s2,1000
	li 	a0,10
	la	a1,aaa
	li	a2, 4
	jal	special_sum
	mv	s0,a0
	li	a0,200
	la	a1,bbb
	li	a2,4
	jal	special_sum
	mv	s1,a0
	li	a0,500
	la	a1,ccc
	li	a2,6
	jal	special_sum
	add	t0,s0,s1
	add	t1,t0,a0
	add	s2,s2,t1
	
	
	
	
	
	
	
	#epilogue
	
	lw	ra,12(sp)
	lw	s2,8(sp)
	lw	s2,4(sp)
	lw	s2,0(sp)
	addi	sp,sp,32
	
	li      a0, 0   # return value from main = 0
	jr	ra
	
	
	
	
	
	
	
	
.globl clamp

clamp:

	#no prologue and epilogue its a leaf function
	
	sub 	t2 ,zero, a0 	#-bound
	mv	t3,a0		# bound
	
	mv	a0,a1		#a0 = x
	
	bge	a1, t2, else
	mv	a0,t2		#a0 = -bound
	j 	end_clamp
else:	ble	a1,t3,end_clamp
	mv	a0,t3	#a0 = bound
	
	
end_clamp:
	jr	ra










	.globl special_sum
special_sum:	
	#prologue
	addi 	sp, sp, -32
	sw	ra,	24(sp)
	sw	s5,	20(sp)
	sw	s4,	16(sp)
	sw	s3, 	12(sp)
	sw	s2,	8(sp)
	sw	s1,	4(sp)
	sw	s0, 	0(sp)
	mv	s0,	a0 #bound
	mv	s1,	a1 # pointer x
	mv	s2, 	a2 # n
	
	#body
	#s3 result
	#s4	i
	addi	s3,zero,0 #result =0
	addi	s4,zero,0 #i=0
startloop:
	bge	s4,s2,pastloop
	mv	a0, s0	#a0 = bound
	slli	t0,s4,2
	add	t1,s1,t0
	lw	t4, (t1)	
	mv	a1, t4 #a1 = x[i]
	jal	clamp
	add	s3,s3,a0 #result+= clamp(bound,x[i])
	addi	s4,s4,1	# i++
	j	startloop
	
	
	
	
	
	
	
	
pastloop:	
	#epilogue
	mv	a0,s3
	
	lw	ra,	24(sp)
	lw	s5,	20(sp)
	lw	s4,	16(sp)
	lw	s3, 	12(sp)
	lw	s2,	8(sp)
	lw	s1,	4(sp)
	lw	s0, 	0(sp)
	
	addi	sp,sp,32
	
	jr 	ra
	
