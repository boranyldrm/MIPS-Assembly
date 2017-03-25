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
	
	addi $a1, $s0, -1
menu:
	la $a0, menu_text
	li $v0, 4
	syscall
	#get the user selection
	li $v0, 5
	syscall
	move $s1, $v0
	
	beq $s1, 1, BubbleSort
	beq $s1, 2, BubbleSort
	beq $s1, 3, median
	beq $s1, 4, exit

BubbleSort:
	bge $t7, $a1, print_bs_or_minmax
	
	bne $t7, 1, max_found
		lb $t9, 0($t1)	#max element in the array
	max_found:
	li $t6, 0
	li $t1, 0x100000F0
	jal second_loop
	
	addi $t0, $t0, 4
	addi $t7, $t7, 1
	
	j BubbleSort

second_loop:
	
	sub $t2, $a1, $t7
	bge $t6, $t2, return
	
	lb $t3, 0($t1)
	lb $t4, 4($t1)
	
	blt $t3, $t4, increment
	
	sb $t4, 0($t1)
	sb $t3, 4($t1)
	
	increment:
		addi $t1, $t1, 4
		addi $t6, $t6, 1
	
	j second_loop
	
	return:
		jr $ra
		
print_bs_or_minmax:
	li $t7, 0
	li $t0, 0x100000F0
	
	beq $s1, 1, print_bs
	beq $s1, 2, print_minmax
	
	print_bs:
		beq $t7, $s0, menu
	
		lb $a0, 0($t0)
		li $v0, 1
		syscall
	
		la $a0, comma
		li $v0, 4
		syscall
	
		addi $t0, $t0, 4
		addi $t7, $t7, 1
		j print_bs
	
	print_minmax:	
		#print out the minimum
		la $a0, minimum
		li $v0, 4
		syscall
	
		lb $a0, 0($t0)
		li $v0, 1
		syscall
	
		la $a0, endl
		li $v0, 4
		syscall
	
		#print out the maximum
		la $a0, maximum
		li $v0, 4
		syscall
	
		add $a0, $0, $t9
		li $v0, 1
		syscall
		
		j menu
	
median:
	li $t7, 0
	li $t0, 0x100000F0

	sra $t1, $s0, 1
	loop:
		addi $t0, $t0, 4
		addi $t7, $t7, 1
		blt $t7, $t1, loop
	
	la $a0, median_text
	li $v0, 4
	syscall
	
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	
	j menu
	
exit:
	li $v0, 10 #exit the program
	syscall
	
#################################
#				#
#     	 data segment		#
#				#
#################################
	

	.data
menu_text:	.asciiz "\n\n1) Bubble Sort \n2) minMax \n3) median \n4)quit\n"
askSize:	.asciiz "How large should the array be: "
enterAnInt:	.asciiz "Enter an integer: "
comma:		.asciiz ", "
endl:		.asciiz "\n"
median_text:	.asciiz "Median is: "
minimum:	.asciiz "Minimum number is: "
maximum:	.asciiz "Maximum number is: "