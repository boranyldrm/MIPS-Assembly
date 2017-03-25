#################################
#				#
#	text segment		#
#				#
#################################
	
	.text
	.globl __start
__start:
	#specify the base address of the array
	li $s0, 0x100000F0
	li $t0, 0x100000F0

	#print out the welcome message
	la $a0, askSize
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	move $v1, $v0 
	
takeInput:
	beq $t7, $s0, reset
	
	#prompt the user to enter an integer
	la $a0, enterAnInt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t1, $v0
	sb $t1, 0($t0)
	
	addi $t0, $t0, 4
	addi $t7, $t7, 1
	j takeInput
	
reset:
	li $t7, 0
	li $t0, 0x100000F0
	
	addi $a1, $s0, -1	# size = n - 1
	
BubbleSort:
	bge $t7, $a1, reset_p	# if i < size
	
	li $t6, 0		# j = 0
	li $t1, 0x100000F0
	jal second_loop
	
	addi $t0, $t0, 4
	addi $t7, $t7, 1
	
	j BubbleSort

second_loop:
	sub $t2, $a1, $t7	# t2 = size - i
	bge $t6, $t2, return	# if j < ($t2)
	
	lb $t3, 0($t1)
	lb $t4, 4($t1)
	
	blt $t3, $t4, increment	# if t3 > t4
	# swap 
	sb $t4, 0($t1)
	sb $t3, 4($t1)
	
	increment:
		addi $t1, $t1, 4
		addi $t6, $t6, 1
	
	j second_loop
	
	return:
		jr $ra
reset_p:
	li $t7, 0
	li $t0, 0x100000F0	
print:
	beq $t7, $s0, exit
	
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	
	la $a0, comma
	li $v0, 4
	syscall
	
	addi $t0, $t0, 4
	addi $t7, $t7, 1
	j print
	
exit:
	li $v0, 10 #exit the program
	syscall
	
#################################
#				#
#     	 data segment		#
#				#
#################################
	

	.data
askSize:	.asciiz "How large should the array be: "
enterAnInt:	.asciiz "Enter an integer: "
comma:		.asciiz ", "
