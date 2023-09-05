# 11Fprog.asm
# ENCM 369 Winter 2023 Lab 11 Exercise F

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

# int main(void)
#
# variable		allocation
#  int k		  s0
#  double y[5]		  10 words starting at 0(sp) 
	.text
	.globl	main  
main:
	addi	sp, sp, -64
	sw	ra, 44(sp)
	sw	s0, 40(sp)

	addi	a0, sp, 0		# a0 = &y[0]
	addi	a1, zero, 5		# a1 = 5
	jal	proc1
	add	s0, zero, zero		# k = 0
L11:
	slti	t0, s0, 5		# t0 = (k < 5)
	beq	t0, zero, L12		# if (!t0) goto L12
	slli	t1, s0, 3		# t1 = 8 * k
	add	t2, sp, t1		# t0 = &y[k]
	fld	fa0, (t2)		# f12 = y[k]
	li      a7, 3   		# 3 means print double
	ecall				# print double in fa0
	li      a0, '\n'		# a0 = '\n'
	li	a7, 11  		# 11 means print char
	ecall				# print char in a0
	addi	s0, s0, 1		# k++
	j	L11
L12:
	mv	a0, zero	# r.v = 0

	lw	s0, 40(sp)
	lw	ra, 44(sp)
	addi	sp, sp, 64
	jr	ra

# void proc1(double *a, int n)
#
# arg/var			allocation
#  a				  s0
#  n				  s1
#  int k			  s2
#  double pi_over_2		  fs0
#
	.data
const_pi_by_2:
	.double 1.57079632679489661923
	.text
	.globl	proc1
proc1:
	addi	sp, sp, -32
	sw	ra, 20(sp)
	sw	s2, 16(sp)
	sw	s1, 12(sp)
	sw	s0, 8(sp)
	fsd	fs0, 0(sp) #fsd fsrc, address to memory
	mv	s0, a0  #address of y[0] = s0
	mv	s1, a1  #s1 = n 

	la      t0, const_pi_by_2 #t0 = address of const
	fld	fs0, (t0)  #from memory , pi_over_2 = fs0

	mv	s2, zero		# i = 0
 L21:
	bge	s2, s1, L22		# if (i >= n) goto L22
        fcvt.d.w ft0, s2                # ft0 = (int) i  //conversion for multiplication result goes in t register of f
        fmul.d  fa0, ft0, fs0           # fa0 = ft0 * pi_over_2  //result goes in fa0
	jal	proc2
	slli	t1, s2, 3		# t1 = 8 * i
	add	t2, s0, t1		# t2 = &a[i]
	fsd	fa0, (t2)		# a[i] = r.v. from proc2
	addi	s2, s2, 1		# i++
	j	L21
L22:	
	fld	fs0, 0(sp)
	lw	s0, 8(sp)
	lw	s1, 12(sp)
	lw	s2, 16(sp)
	lw	ra, 20(sp)
	addi	sp, sp, 32
	jr	ra

# double proc2(double x)
#
	.data
const_0pt5:
	.double 0.5
	.text
	.globl	proc2
proc2:
        la      t0, const_0pt5
	fld	ft0, (t0)
	fmul.d	fa0, ft0, fa0		# r.v. = f2 * x
	jr	ra
