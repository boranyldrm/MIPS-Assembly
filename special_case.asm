
# find if floating point entered is a special case(NaN, infinity)
#################################################
#					 	#
#		text segment			#
#						#
#################################################

	.text
	.globl __start

__start:

	li $s0, 0xFF840000	# test number
	
	addi $s1, $0, 255	# variable to special_case(all 1) exponent
	
	jal special_case
	
	# exit the program
	li $v0, 10
	syscall
	
special_case:
	
	sll $t1, $s0, 1		## delete the sign bit
	srl $t2, $t1, 24	## delete the fraction and shift exponent to lsb
	
	beq $t2, $0, true
	beq $t2, $s1, true
	
	j false
	
	true:
		addi $a0, $0, 1
		li $v0, 1
		syscall
		
		jr $ra
	false:
		add $a0, $0, $0
		li $v0, 1
		syscall
		
		jr $ra

			
#################################################
#					 	#
#     	 	data segment			#
#						#
#################################################

	.data
