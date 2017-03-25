##   	
##	x = ((a - b) * c) % 2
##     
##      $s1     a
##      $s2     b
##	$s3	c
##	$t0	0
##	$t1	1
#################################################
#					 	#
#		text segment			#
#						#
#################################################

	.text 
	.globl __start 
       	
__start:		# execution starts here
	
	#print out the get_a
	la $a0, get_a
	li $v0, 4
	syscall
	# assign the value of a to register $s1
	li $v0, 5	
	syscall
	move $s1, $v0
	
	#print out the get_b
	la $a0, get_b
	li $v0, 4
	syscall
	# assign the value of d to register $s2
	li $v0, 5	
	syscall
	move $s2, $v0
	
	#print out the get_c
	la $a0, get_c
	li $v0, 4
	syscall
	# assign the value of c to register $s3
	li $v0, 5	
	syscall
	move $s3, $v0
	
	# a - b
	sub $t0, $s1, $s2
	# (a - b) * c
	mul $t0, $t0, $s3
	# copy $t0 into $t7
	add $t7, $0, $t0 
	
	
	srl $t7, $t7, 1
	sll $t7, $t7, 1
	
	beq $t7, $t0, zero
	
	bne $t7, $t0, one
	
zero:
	#print out the zero_result
	la $a0, zero_result
	li $v0, 4
	syscall
	b exit
one:
	#print out the one_result
	la $a0, one_result
	li $v0, 4
	syscall

	b exit

# system exit
exit:
	li $v0, 10
	syscall

#################################################
#					 	#
#     	 	data segment			#
#						#
#################################################
	.data
get_a:	.asciiz "Enter the value of a: "
get_b:	.asciiz "Enter the value of b: "
get_c:	.asciiz "Enter the value of c: "
zero_result:	.asciiz "The result is 0."
one_result:	.asciiz "The result is 1."
