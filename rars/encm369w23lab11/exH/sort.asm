# sort.asm
# ENCM 369  Winter 2023 Lab 11 Exercise H

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

	.data
x:	.double	-6.015625, -2.25, -3.125, -5.03125, 
	.double	-8.00390625, -4.0625, -1.5, -7.0078125

# int main(void)
# Register allocation
# Variable   Register
#  i	       s0

	.data
str1:	.asciz	"before sorting ...\n"
str2:	.asciz	"after sorting ...\n"
str3:	.asciz	"    "
str4:	.asciz	"\n"

	.text
	.globl	main
main:
	# Prologue.
	addi	sp, sp, -32
	sw	ra, 4(sp)
	sw	s0, (sp)

	# Body.
	la	a0, str1		# "before sorting ..."
	li	a7, 4			# code for string
	ecall

	mv	s0, zero        	# i = 0
L1:
	slti	t0, s0, 8		# t0 = (i < 8)
	beq	t0, zero, L2		# if (t0 == false) goto L2
	la	a0, str3		# "    " (spaces)
	li	a7, 4			# code for string
	ecall
	la	t0, x
	slli	t1, s0, 3		# t1 = i * 8
	add	t1, t0, t1		# t1 = &x[i]
	fld	fa0, (t1)		# f12 = x[i]
	li	a7, 3   		# code to print a double
	ecall
	la	a0, str4		# newline
	li	a7, 4   		# code for string
	ecall
	addi	s0, s0, 1		# i++
	j	L1
	
L2:
	la	a0, x			# arguments for sort
	li	a1, 8
	jal	sort
	la	a0, str2		# "after sorting ..."
	li	a7, 4		        # code for string
	ecall

	add	s0, zero, zero	        # i = 0
L3:
	slti	t0, s0, 8		# t0 = (i < 8)
	beq	t0, zero, L4		# if (t0 == false) goto L2
	la	a0, str3		# "    " (spaces)
	li	a7, 4	        	# code for string
	ecall
	la	t0, x
	slli	t1, s0, 3		# t1 = i * 8
	add	t1, t0, t1		# t1 = &x[i]
	fld	fa0, (t1)		# f12 = x[i]
	li	a7, 3		        # code to print a double
	ecall
	la	a0, str4		# newline
	li      a7, 4   		# code for string
	ecall
	addi	s0, s0, 1		# i++
	j	L3

L4:
	mv	a0, zero        	# return 0

	# Epilogue.
	lw	ra, 4(sp)
	lw	s0, (sp)
	addi	sp, sp, 32
	jr	ra




# void sort(double *a, int n)
# Sort array elements a[0], ... a[n - 1] in increasing order.
#
	.text
	.globl	sort
sort:
	# Replace this comment with appropriate code.
	
	
	#plan 
	#t0  = outer
	#t3 = inner
	#ft0 = inserted
	
	addi	t0 ,zero, 1  # outer = 1
start_for_loop:
	bge	t0, a1 , past_for_loop
	slli    t1 , t0, 3  # 8 * outer
	add 	t2 , a0, t1 #t2 = a0 + t1
	fld	ft0, (t2)   #inserted = a[outer]
	mv 	t3, t0      #inner = outer
start_while_loop:
	ble 	t3, zero , past_while_loop
	addi	t4, t3, -1 #t4 = inner -1
	slli	t5, t4, 3  #t5 = offset
	add     t6, a0, t5 #t6 = &a[inner-1]
	fld	ft1, (t6)  #ft1 = a[inner-1]
	fge.d	t1 , ft0, ft1 #ft0 = inserted #ft1 = a[inner-1]
	bne	t1, zero, past_while_loop
	slli	t4, t3, 3 # inner = t3 * 8 
	add	t5, a0, t4 #&a[inner]
	fsd	ft1, (t5)
	addi	t3, t3, -1
	j	start_while_loop
	
past_while_loop:
	slli	t4, t3, 3   #inner = t3 * 8 
	add	t5, a0, t4  #&a[inner]
	fsd	ft0 , (t5) 
	addi	t0, t0 , 1 #outer +=1
	j	start_for_loop
	

past_for_loop:
	jr	ra
