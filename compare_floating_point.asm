
#################################################
#					 	#
#		text segment			#
#						#
#################################################

	.text
	.globl __start

__start:

	li $a0, 0x81234567
	li $a1, 0x81234567
	
compareFP:

	signcmp:
		srl $t0, $a0, 31	#sign of a0
		srl $t1, $a1, 31	#sign of a1
	
		bgt $t0, $t1, one_greater_zero	#a1 > a0 because a0 is negative
		bgt $t1, $t0, zero_greater_one	#a0 > a1 because a1 is negative
		beq $t0, $t1, exponentcmp	#a0 = a1 (same sign bit)
	
	exponentcmp:
		sll $t0, $a0, 1	#delete sign bit
		srl $t0, $t0, 24	#delete fraction
		
		sll $t1, $a1, 1 #delete sign bit
		srl $t1, $t1, 24	#delete fraction
			
		bgt $t0, $t1, zero_greater_one
		bgt $t1, $t0, one_greater_zero
		beq $t1, $t0, fractioncmp
		
	fractioncmp:	
		sll $t0, $a0, 9 # delete sign and exponent
		srl $t0, $t0, 9 # get fraction back to least significant part
		
		sll $t1, $a1, 9 # delete sign and exponent
		srl $t1, $t1, 9 # get fraction back to least significant part
		
		bgt $t0, $t1, zero_greater_one
		bgt $t1, $t0, one_greater_zero
		beq $t1, $t0, zero_equals_one
			
one_greater_zero:
	la $a0, one_is_greate
	li $v0, 4
	syscall
	
	j exit
	
zero_greater_one:
	la $a0, zero_is_greate
	li $v0, 4
	syscall
	
	j exit

zero_equals_one:
	la $a0, zero_is_equal_one
	li $v0, 4
	syscall
	
	j exit
	
exit:
	# exit the program
	li $v0, 10
	syscall
			
#################################################
#					 	#
#     	 	data segment			#
#						#
#################################################

	.data
one_is_greate : .asciiz "$a1 is greater than $a0"
zero_is_greate : .asciiz "$a0 is greater than $a1"
zero_is_equal_one : .asciiz "$a0 is equal to $a1"