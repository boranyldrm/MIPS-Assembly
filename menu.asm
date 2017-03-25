#s0 = the size of the array
#s1 = user operation selection
#t0 = base address of the array
#t7  = loop counter
#t6 = numberOfOccurences
#t5 = numbersGraterThanInput (opt1)
#t4 = sum of evens, t3 = sum of odds

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

print:
	beq $t7, $s0, menu
	lb $a0, 0($t0)
	li $v0, 1
	syscall
	
	la $a0, comma
	li $v0, 4
	syscall
	
	addi $t0, $t0, 4
	addi $t7, $t7, 1
	j print
	
menu:
	la $a0, menuText
	li $v0, 4
	syscall
	#get the user selection
	li $v0, 5
	syscall
	move $s1, $v0
	
	beq $s1, 1, opt1
	beq $s1, 2, opt2
	beq $s1, 3, opt3
	beq $s1, 4, exit
	
opt1:
	li $t7, 0
	li $t0, 0x100000F0
	
	la $a0, enterAnInt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $a1, $v0
	
	findSum:
		beq $t7, $s0, printSum
		lb $a0, 0($t0)
		
		blt $a0, $a1, less
		add $t5, $t5, $a0
		
		less:
			addi $t0, $t0, 4
			addi $t7, $t7, 1
		j findSum
	printSum:
		move $a0, $t5
		li $v0, 1
		syscall
	j menu
	
opt2:
	li $t7, 0
	li $t0, 0x100000F0
	
	sum_eo:
		lb $a0, 0($t0)
		
		rem $t1, $a0, 2
		beq $t1, 1, s_odd
		beq $t1, 0, s_even
		
		s_odd:
			add $t3, $t3, $a0
			j inc
		s_even:
			add $t4, $t4, $a0
		inc:	
			addi $t0, $t0, 4
			addi $t7, $t7, 1
		bne $t7, $s0, sum_eo
		
	printEven:
		la $a0, even
		li $v0, 4
		syscall
		move $a0, $t3
		li $v0, 1
		syscall
		la $a0, endl
		li $v0, 4
		syscall
		
	printOdd:
		la $a0, odd
		li $v0, 4
		syscall
		move $a0, $t4
		li $v0, 1
		syscall
	j menu
	
opt3:
	li $t7, 0
	li $t0, 0x100000F0
	
	la $a0, enterAnInt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $a1, $v0
	
	occ:
		lw $a0, 0($t0)
		
		rem $t1, $a0, $a1
		
		bne $t1, 0, not_eq
		addi $t6, $t6, 1
		
	not_eq:
		addi $t0, $t0, 4
		addi $t7, $t7, 1
		bne $t7, $s0, occ
	
	print_occ:
		la $a0, numberOfOccurences
		li $v0, 4
		syscall
		move $a0, $t6
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
askSize:	.asciiz "How large should the array be: "
enterAnInt: .asciiz "Enter an integer: "
endl: .asciiz "\n"
comma: .asciiz ", "
even:	.asciiz "Sum of evens: "
odd:	.asciiz "Sum of odds: "
menuText: .asciiz "\n\nMENU\n1)Find summation of numbers which is greater than input number\n2)Find summation of even and odd numbers and display:\n3)Display the number of occurrences of the array elements divisible by a input number.\n4)Quit\n"
numberOfOccurences: .asciiz "Number of occurences: "