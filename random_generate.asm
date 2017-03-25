

#################################################
#					 	#
#		text segment			#
#						#
#################################################

	.text
	.globl __start

__start:	
	addi $s1, $0, 255	# variable to special_case(all 1) exponent
	
	j get_rand_FP
	
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

get_rand_FP:
	li $v0, 41
	syscall
	add $s0, $0, $a0
	
	jal special_case
	
	bne $a0, $0, again
	
	la $a0, endl
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall
	
	j exit
	
	again:
		li $v0, 41
		syscall
		add $s0, $0, $a0
	
		jal special_case
		
		j get_rand_FP
	
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
endl:	.asciiz "\n"