#   Palindrome
##     $t1     - lower array pointer, A
##     $t2     - upper array pointer, B
##     $t3     - character at address A
##     $t4     - character at address B
##     $v0     - syscall parameter / return value
##     $a0     - syscall parameters
##     $a1     - syscall parameters

#################################################
#					 	#
#		text segment			#
#						#
#################################################

	.text 
	.globl __start 
       	
__start:		# execution starts here

        ## read the character string into str_space
	la $a0, str_space
	li $a1, 1024
	li $v0, 8
	syscall
	
	# lower array pointer = base address of the array
	la $t1, str_space 
	# start upper pointer at beginning    
	la $t2, str_space     
	
length_loop:
	# grab the character at upper ptr
	lb $t3, ($t2) 
	# if $t3 == 0, we're at the terminator           
	beq $t3, $0, end_length_loop
	# increment upper array ptr  
	addi $t2, $t2, 1
	# repeat the loop           
	b length_loop           
	
end_length_loop:
	# move upper pointer back to last char of the str
	subi $t2, $t2, 2          
	
check_loop:
	# if lower pointer >= upper pointer, yes is_palin
	bge $t1, $t2, is_palin   
	
	# load the character at lower ptr
	lb  $t3, ($t1)  
	# load the character at upper ptr         
	lb  $t4, ($t2)      
	# if $t3 and $t4 are different, it's not_palin     
	bne $t3, $t4, not_palin   
	
	# increment lower ptr
	addi $t1, $t1, 1
	# decrement upper ptr  
	subi $t2, $t2, 1  
	# repeat the loop         
	b check_loop

# print the is-palindrome message
is_palin:
	la $a0, is_palindrome  
	li $v0, 4
	syscall
	b exit
	
# print the not-palindrome message
not_palin:
	la $a0, not_palindrome 
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
str_space:	.space 1024
is_palindrome:  .asciiz "The string is a palindrome.\n"
not_palindrome: .asciiz "The string is not a palindrome.\n"
