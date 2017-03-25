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

findMedian:
	sra $t1, $s0, 1
	loop:
		addi $t0, $t0, 4
		addi $t7, $t7, 1
		blt $t7, $t1, loop
	
	la $a0, median
	li $v0, 4
	syscall
	
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	
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
median:		.asciiz "Median is: "