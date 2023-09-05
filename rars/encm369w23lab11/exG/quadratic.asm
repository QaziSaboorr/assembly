# quadratic.asm
# ENCM 369 Winter 2023 Lab 11 Exercise G

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
	.data
c1pt0:	.double 1.0
c1pt5:	.double 1.5
c2pt0:	.double 2.0
c1pt1:	.double 1.1
cm3pt5:	.double -3.5

	.text
	.globl	main
main:
	addi	sp, sp, -32
	sw	ra, 0(sp)

	fld	fa0, c1pt0, t0
	fld	fa1 c1pt5, t0
	fld	fa2, c2pt0, t0
	jal	test_q	      
	fld	fa0, c1pt1, t0
	fld	fa1 cm3pt5, t0
	fld	fa2, c2pt0, t0
	jal	test_q	      

	lw	ra, 0(sp)
	addi	sp, sp, 32
	jr	ra


# double result[4] = {0.0, 0.0, 0.0, 0.0};
	.data
	.globl result
result: .double 0.0, 0.0, 0.0, 0.0

# void test_q(double a, double b, double c)
	.data
str01:	.asciz "\ncoefficient a = "
str02:	.asciz "\ncoefficient b = "
str03:	.asciz "\ncoefficient c = "
str04:	.asciz "\nroot: "
str05:	.asciz " + i * ("
str06:	.asciz ")\nroot: "
str07:	.asciz ")\n"

	.text
	.globl	test_q
test_q:
	addi	sp, sp, -32
	sw	ra, 24(sp)
	fsd	fa2, 16(sp)		# copy c to stack
	fsd	fa1,  8(sp)		# copy b to stack
	fsd	fa0,  0(sp)		# copy a to stack
	
	# Note: At this point a, b, and c are still in the appropriate
	# FPRs, so there is no need to recover them from the stack before
	# making the call to quadratic
	la	a3, result		# 4th arg = &result[0]
	jal	quadratic
	
	la	a0, str01
	li	a7, 4			# ecall to print string
	ecall
	fld	fa0, 0(sp)		# fa0 = a
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str02
	li	a7, 4			# ecall to print string
	ecall
	fld	fa0, 8(sp)		# fa0 = b
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str03
	li	a7, 4			# ecall to print string
	ecall
	fld	fa0, 16(sp)		# fa0 = c
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str04
	li	a7, 4			# ecall to print string
	ecall
	fld	fa0, result, t0		# fa0 = result[0]
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str05
	li	a7, 4			# ecall to print string
	ecall
	la	t0, result		# t0 = &result[0]
	fld	fa0, 8(t0)		# fa0 = result[1]
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str06
	li	a7, 4			# ecall to print string
	ecall
	la	t0, result		# t0 = &result[0]
	fld	fa0, 16(t0)		# fa0 = result[2]
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str05
	li	a7, 4			# ecall to print string
	ecall
	la	t0, result		# t0 = &result[0]
	fld	fa0, 24(t0)		# fa0 = result[3]
	li	a7, 3			# ecall to print double
	ecall

	la	a0, str07
	li	a7, 4			# ecall to print string
	ecall

	lw	ra, 24(sp)
	addi	sp, sp, 32
	jr	ra

#  void quadratic(double a, double b, double c, double *roots)
	
	 .data
zerflt:  .double 0.0
fourflt: .double 4.0


	.text
	.globl	quadratic
quadratic:
	
	# Replace these comments with code that translates the C
	# code.

	# ATTENTION: The C version of quadratic is nonleaf, but you
	# can code the AL version as LEAF by using the RISC-V sqrt.d
	# instruction instead of making a call to a sqrt procedure.
	# its a leaf function dont really need stack 
	#plan


#plan

# discrim = ft0
#sqrtd = ft1 
#two_a  = #ft2
# a = fa0
# b = fa1 
#c = fa2
#zero = ft7
# 5 = ft5
# *root = a4

fmul.d     ft3 , fa0, fa2  #ft3 = a * c
fmul.d     ft4, fa1 , fa1 #ft4 = b * b
la	   t0 , fourflt #address of 4
fld	   ft5, (t0)   #load 4
fmul.d     ft6 , ft5, ft3 # 4 * a * C
fsub.d     ft0 , ft4 , ft6 # discrm
fadd.d     ft2 , fa0, fa0
la         t1, zerflt
fld	   ft7 , (t1) #zero = ft7
flt.d      t2 , ft0,ft7 #discr < ft7
bne        t2, zero, else # t2 !=0 jump to else
fsqrt.d    ft1, ft0      #ft1 = sqrtd(discrm)
fsub.d     ft3 ,ft1, fa1 #f3 = sqrtd - b
fdiv.d     ft4  , ft3, ft2 #ft4 = f3/two_a
fsd        ft4, (a3)   #root[0] = ft4
fsd        ft7 , 8(a3) # root[1] = zero
fneg.d     ft1, ft1 #ft1 = -ft1
fsub.d     ft3, ft1, fa1
fdiv.d     ft4, ft3, ft2
fsd        ft4, 16(a3)
fsd        ft7, 24(a3)

j         past_else

else:
#available 
#ft3
#ft4
#ft6
fneg.d  ft3, ft0  # ft3 = -discr
fsqrt.d ft1, f3   # ft1 = root(-discr)
fneg.d  ft4, fa1  #-b = ft4
fdiv.d  ft6 , ft4, ft2   #-b /2a = ft6
fsd     ft6, (a3) #root a[0] = ft6
fdiv.d  ft6, ft1,ft2  #ft6 = sqrtd/2a
fsd     ft6, 8(a3)   #root[1] = ft6
fld      ft6 , (a3)   #ft6 = root[0]
fsd      ft6, 16(a3)  #root[2] = ft6 =root[0]
fld      ft6, 8(a3)  #ft6 = root [1]
fneg.d   ft6, ft6 #ft6 = -root[1]
fsd      ft6, 24(a3) #root[3]  = ft6

 
past_else:
jr	ra 














	
	
	
	
	
	
	
	
	

	
