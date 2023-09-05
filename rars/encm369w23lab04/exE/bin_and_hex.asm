# bin_and_hex.asm
# ENCM 369 Winter 2023 Lab 4 Exercise E Partial Solution
#

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
	.text
	.globl	main
main:
	addi	sp, sp, -32
	sw	ra, 0(sp)
	
	li	a0, 0x76543210
	jal	test
	li	a0, 0x89abcdef
	jal	test
	li	a0, 0
	jal	test
	li	a0, -1
	jal	test	    

	mv	a0, zero	# r.v. = 0

	lw	ra, 0(sp)
	addi	sp, sp, 32
	jr	ra


# void test(int test_value)
#
# arg / var	 memory location
#   test_value	     44(sp)
#   char str[40]     40 bytes starting at 0(sp)
#
	.data
STR1:	.asciz "\n\n"
	.text
	.globl	test
test:
	addi	sp, sp, -64
	sw	a0, 44(sp)
	sw	ra, 40(sp)

	addi	a0, sp, 0		# a0 = &str[0]	  
	lw	a1, 44(sp)		# a1 = test_value

	jal	write_in_hex

	addi	a0, sp, 0		# a0 = &str[0]	  
	li      a7, 4	        	# a7 = code to print a string
	ecall
	addi	a0, zero, '\n'	        # a0 = '\n'
	li      a7, 11		        # a7 = code to print a char 
	ecall


	addi	a0, sp, 0		# a0 = &str[0]	  
	lw	a1, 44(sp)		# a7 = test_value
	jal	write_in_binary

	addi	a0, sp, 0		# a0 = &str[0]	  
	li      a7, 4		        # a7 = code to print a string
	ecall
	la	a0, STR1		# a0 = STR1
	addi	a7, zero, 4		# a7 = code to print a string	  
	ecall

	lw	ra, 40(sp)
	addi	sp, sp, 64
	jr	ra


# void write_in_hex(char *str, unsigned int word)
# 
# arg / var	register
#   str	  a0
#   word	  a1
#   digit_list	  t9
#
	.data
hex_digits:
	.asciz  "0123456789abcdef"

	.text
	.globl	 write_in_hex	    
write_in_hex:
	li	t0, '0'
	sb	t0, 0(a0)		# str[0] = '0'
	li	t0, 'x'
	sb	t0, 1(a0)		# str[1] = 'x'
	li	t0,  '_'
	sb	t0, 6(a0)		# str[6] = '_'
	sb	zero, 11(a0)		# str[11] = '\0'

	la	t6, hex_digits		# digit_list = hex_digits

	srli	t1, a1, 28		# t1 = word >> 28
	andi	t2, t1, 0xf		# t2 = t1 & 0xf
	add	t3, t6, t2		# t3 = &digit_list[t2]
	lbu	t4, (t3)		# t4 = digit_list[t2]
	sb	t4, 2(a0)		# str[2] = t4

	srli	t1, a1, 24		# t1 = word >> 24
	andi	t2, t1, 0xf		# t2 = t1 & 0xf
	add	t3, t6, t2		# t3 = &digit_list[t2]
	lbu	t4, (t3)		# t4 = digit_list[t2]
	sb	t4, 3(a0)		# str[3] = t4

	srli	t1, a1, 20		# t1 = word >> 20
	andi	t2, t1, 0xf		# t2 = t1 & 0xf
	add	t3, t6, t2		# t3 = &digit_list[t2]
	lbu	t4, (t3)		# t4 = digit_list[t2]
	sb	t4, 4(a0)		# str[4] = t4

	srli	t1, a1, 16		# t1 = word >> 16
	andi	t2, t1, 0xf		# t2 = t1 & 0xf
	add	t3, t6, t2		# t3 = &digit_list[t2]
	lbu	t4, (t3)		# t4 = digit_list[t2]
	sb	t4, 5(a0)		# str[5] = t4

	srli	t1, a1, 12		# t1 = word >> 12
	andi	t2, t1, 0xf		# t2 = t1 & 0xf
	add	t3, t6, t2		# t3 = &digit_list[t2]
	lbu	t4, (t3)		# t4 = digit_list[t2]
	sb	t4, 7(a0)		# str[7] = t4

	srli	t1, a1, 8		# t1 = word >> 8
	andi	t2, t1, 0xf		# t2 = t1 & 0xf
	add	t3, t6, t2		# t3 = &digit_list[t2]
	lbu	t4, (t3)		# t4 = digit_list[t2]
	sb	t4, 8(a0)		# str[8] = t4

	srli	t1, a1, 4		# t1 = word >> 4
	andi	t2, t1, 0xf		# t2 = t1 & 0xf
	add	t3, t6, t2		# t3 = &digit_list[t2]
	lbu	t4, (t3)		# t4 = digit_list[t2]
	sb	t4, 9(a0)		# str[9] = t4

	andi	t2, a1, 0xf		# t2 = word & 0xf
	add	t3, t6, t2		# t3 = &digit_list[t2]
	lbu	t4, (t3)		# t4 = digit_list[t2]
	sb	t4, 10(a0)		# str[10] = t4

	jr	ra

# write_in_binary(char *str, unsigned int word)
#
# Students have to replace the code for this procedure
# with code that implements the given C code.
	.text
	.globl	write_in_binary
write_in_binary:

	# Time-saving hint: This is a leaf procedure!
	# Leave str and word in a0 and a1, and
	# use t-registers for local variables.

	# Get rid of the next 3 lines before writing a solution. 
	#plan
	#t0 = digit0
	#t1 = digit1
	#t2 = bn
	#t3 = = under
	#s4 = index
	#s5 = mask
	#a0 = *str
	#a1 = word
	
	
	

	mv	t2,zero #bn = 0
	li	t0, '0' #digit = '0'
	li	t1, '1'	#digit1 = '1'
	li	t3, '_'	#under = '_'
	sb	zero, 39(a0)  #str[39] = '\0'
	li	t4, 38 #index = 38
	li	t5, 1 #mask = 1
	#t6 is available for intermediate step
start_loop:	
	and	t6, a1, t5
	bne	t6,zero,else1
	add	t6, a0, t4
	sb	t0, (t6) #str[index]  = digit0
	j	else_past
else1:	
	add	t6, a0, t4
	sb	t1, (t6)
else_past:
	addi 	t4,t4,-1
	addi	t2,t2,1
	slli	t5,t5,1
	li	t6, 32
	beq	t2,t6,end_loop
	andi	t6,t2,3
	bne	t6,zero,else2
	add	t6, a0, t4
	sb	t3, (t6)
	addi	t4,t4,-1

else2:	
	j	start_loop	

end_loop:

	jr	ra




	
	
	
	
	

	 
	
	
	
	
	
	
	#li	t0, '?'
	#sb	t0, 0(a0)		# str[0] = 'Z'
	#sb	zero, 1(a0)		# terminate string
	
	#jr	ra






		#epilogue