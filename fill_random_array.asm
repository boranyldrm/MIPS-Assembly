

#################################################
#					 	#
#		text segment			#
#						#
#################################################

	.text
	.globl __start

__start:

	#specify the base address of the array
	li $s0, 0x100000F0
	li $t0, 0x100000F0
	
	# variable to special_case(all 1) exponent
	addi $s2, $0, 255
	
	#print out the asksize 
	la $a0, ask_size
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	j fill_array
	
special_case:
	
	sll $t1, $s1, 1		## delete the sign bit
	srl $t2, $t1, 24	## delete the fraction and shift exponent to lsb
	
	beq $t2, $0, true
	beq $t2, $s2, true
	
	j false
	
	true:
		addi $a1, $0, 1
		
		jr $ra
	false:
		add $a1, $0, $0
		
		jr $ra

get_rand_FP:
	# generate random integer for first check
	li $v0, 41
	syscall
	add $s1, $0, $a0
	
	## check random number in special_case for first check
	jal special_case
	
	recurse:	# recurse from here 
	## if random number != 0, jump to again
	bne $a1, $0, again
	
	j fill	# valid number fill the array
	
	again:
		# generate new random integer
		li $v0, 41
		syscall
		add $s1, $0, $a0
		
		## check random number in special_case
		jal special_case
		
		j recurse
	
fill_array:
	beq $t7, $s0, reset
	
	j get_rand_FP
	fill:
	# s1 is random generated in get_rand_FP
	add $t3, $0, $s1
	sw $t3, 0($t0)
	
	addi $t0, $t0, 4
	addi $t7, $t7, 1
	
	j fill_array
	
reset:
	li $t7, 0
	li $t0, 0x100000F0
	
print: 	
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	la $a0, comma
	li $v0, 4
	syscall
	
	addi $t0, $t0, 4
	addi $t7, $t7, 1
	
	bne $t7, $s0, print
	
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
comma:	.asciiz ", "
ask_size:	.asciiz "Please enter the size of array: "
