.data
Arr:    .word 0,0,0,0,0,0,0,0,0,0   
choice: .word 0
length: .word 10	
text:   .asciiz "enter a number\n"
nLine:  .asciiz "\n"
str1:		.asciiz "Insert the array elements,one per line  \n"
str3:		.asciiz "The sorted array is : \n"
str5:		.asciiz "\n"

	promptSort1: .asciiz "what sorting algorithm do you want to be used?\n"
	promptSort2: .asciiz "enter 1 for bubble sort, 2 for selection sort or 3 for merge sort\n"
	promptSort3: .asciiz "please enter a number:\n"
	
	

.text

	main:


	# prompt choosing sorting algorithm
		la $a0, promptSort1
		la $t0, promptSort2
		li $v0, 4
		syscall
		move $a0, $t0
		li $v0, 4
		syscall
	# scan the user's choice in choice
		li $v0, 5
		syscall		
		move $t0, $v0
		sw $t0, choice

	# go to the algorithm that was chosen
	
	lw $t0, choice
	beq $t0,1 , bubbleSortAlgo
	beq $t0,2 , mainSelection
	beq $t0,3 , mergeSortAlgo

	
		

		
	#end main
		li $v0, 10
		syscall
	
	
		
			
				
						
	bubbleSortAlgo:
		lw      $t1,length		# get total number of array elements
    		j scanData			# go to scanData to scan the array from the user	

	# main_loop of the bubble sort
	# it does multiple loops through the array
	main_loop:
			subi    $a1,$t1,1               # get the count for this loop (must be one less)
			blez    $a1,main_done           # check if done sorting then go to main_done

			la      $a0,Arr                 # get the address of the array
			li      $t2,0                   # clear the "did swap" flag
		
			jal     pass_loop               # do a single loop pass

    # if we make no swaps on a given loop, everything is in sort and we can stop
    # after a loop the last element is now highest, so there is no need to compare it again
    # a standard operation is that each loop shortens the loop count($a1) by 1

			beqz    $t2,main_done           	# if no swaps on current loop, go to main_done
								# otherwise continue

			subi    $t1,$t1,1               	# decrease the number of remaining loops by one
			b       main_loop			# go back to main_loop

	# scanData scans the array for bubble sort from the user and store it in Arr
	scanData:
	# $t8 is counter for while_scan, it starts with 10 and decreases by one with each loop
	addi $t8, $zero, 10
	la $t2, Arr		# load the address of Arr in $t2
	# enter the while loop
	while_scan:
		beqz $t8, main_loop	# if $t8 = 0 then we are done scaning then go back to main_loop

		la $a0, text		# load address of text in $a0 to print it
		li $v0, 4
		syscall

		li $v0, 5		# scan the number
		syscall
		move $t0, $v0

		sw $t0, ($t2)		# store the number in the array 

		addi $t8, $t8, -1	# decrease the number of the loop ($t8)
		addi $t2, $t2, 4	# increase the number of the address by four to point to the address of the next index
	
	#go back to while
	j while_scan

	#main_done prints the array
	main_done:
		
		la      $t1, Arr	#load address of Arr in $t1
		addi $t0, $zero, 0	#intialize $t0 with value 0 to use as a counter in loop1
		loop1:
			bge     $t0, 10, end	#if counter ($t0) >=10 then go to end otherwise continue

    			# load word from the address and put it in $t2
			lw      $t2, 0($t1)
			addi    $t1, $t1, 4	#increment the address by 4 bites to go to the next index
    
			la $a0, nLine		#load the address of text nLine to print a new line
			li $v0, 4
			syscall

			# syscall to print value
			li      $v0, 1      
			move    $a0, $t2	# move the value from $t2 to $a0 to print it
			syscall

			#increment counter ($t0)
			addi    $t0, $t0, 1
			j      loop1	# go back to loop1

	# pass_loop does a single loop through the array
	# a0 = address of array
	# a1 = maximum number of loops to allowed to be performed
	pass_loop:
		lw      $s1,0($a0)              # Load first element in s1
		lw      $s2,4($a0)              # Load second element in s2
		bgt     $s1,$s2,pass_swap       # if (s1) > (s2) go to pass_swap to swap elements

	# decrement counter($a1) and move pointer by four byte to the next index in the array
	pass_next:
		addi   $a0,$a0,4               # move pointer to next element
		subi   $a1,$a1,1               # decrement number of loops remaining
		bgtz   $a1,pass_loop           # if ($a1) "did swap" flag is more than 0 i.e. = 1 then go to pass_loop otherwise go back to main_loop 
		jr     $ra                     # return to main_loop

	# swaps the values of two elements
	pass_swap:
		sw      $s1,4($a0)              # put value of [i+1](s1) in first element
		sw      $s2,0($a0)              # put value of [i](s2) in the second element
		li      $t2,1                   # put value 1 in the "did swap" flag
		j       pass_next

	# End the program
	end:
		li      $v0,10
		syscall
				
					
						
	#merge sort algorithm						
	mergeSortAlgo:	
		#scan the numbers from the user and put it in Arr
		scanDataMerge:
			#intialize counter ($t8) to 10
			addi $t8, $zero, 10
			la $t2, Arr	#load address of the array Arr in ($t2)
			while_scanMerge:
				beqz $t8, mergeSortAlgorithm	#if counter($t8) = 0 then go to mergeSortAlgorithm
		
				la $a0, text	#load address of text to print it
				li $v0, 4
				syscall
	
				li $v0, 5	#scan number and store it
				syscall
				move $t0, $v0

				sw $t0, ($t2)	#store number in the address of the array

				addi $t8, $t8, -1	#decrement counter ($t8)
				addi $t2, $t2, 4	#increase address by four to point to the next index in the array
				j while_scanMerge	#go back to while_scanMerge

	

	mergeSortAlgorithm:
	
		la	$a0, Arr		# Load the start address of the array
		lw	$t0, length		# Load the array length
		sll	$t0, $t0, 2		# Multiply the array length by 4 (the size of the elements)
		add	$a1, $a0, $t0		# Calculate the array end address
		jal	mergesort		# Call the merge sort function
  		b	sortend			# We are finished sorting
	
		li	$v0,10
		syscall
		# $a0 = first address of the array
		# $a1 = last address of the array

		mergesort:

		addi	$sp, $sp, -16		# Adjust stack pointer
		sw	$ra, 0($sp)		# Store the return address on the stack
		sw	$a0, 4($sp)		# Store the array start address on the stack
		sw	$a1, 8($sp)		# Store the array end address on the stack
	
		sub 	$t0, $a1, $a0		# Calculate the difference between the start and end address (i.e. number of elements * 4)

		ble	$t0, 4, mergesortend	# If the array only contains a single element, just return	
	
		srl	$t0, $t0, 3		# Divide the array size by 8 to half the number of elements (shift right 3 bits)
		sll	$t0, $t0, 2		# Multiply that number by 4 to get half of the array size (shift left 2 bits)
		add	$a1, $a0, $t0		# Calculate the midpoint address of the array by addint the mid size to the start address
		sw	$a1, 12($sp)		# Store the array midpoint address on the stack
	
		jal	mergesort		# Call recursively on the first half of the array
		
		lw	$a0, 12($sp)		# Load the midpoint address of the array from the stack
		lw	$a1, 8($sp)		# Load the end address of the array from the stack
		
		jal	mergesort		# Call recursively on the second half of the array
	
		lw	$a0, 4($sp)		# Load the array start address from the stack
		lw	$a1, 12($sp)		# Load the array midpoint address from the stack
		lw	$a2, 8($sp)		# Load the array end address from the stack
		
		jal	merge			# Merge the two array halves
	
		mergesortend:				

		lw	$ra, 0($sp)		# Load the return address from the stack
		addi	$sp, $sp, 16		# Adjust the stack pointer
		jr	$ra			# Return 
	

		# merge two adjacent arrays into one sorted array
		# $a0 = First address of first array
		# $a1 = First address of second array
		# $a2 = Last address of second array
		merge:
		addi	$sp, $sp, -16		# Adjust the stack pointer
		sw	$ra, 0($sp)		# Store the return address on the stack
		sw	$a0, 4($sp)		# Store the start address on the stack
		sw	$a1, 8($sp)		# Store the midpoint address on the stack
		sw	$a2, 12($sp)		# Store the end address on the stack
		
		move	$s0, $a0		# Create a copy of the first half address
		move	$s1, $a1		# Create a copy of the second half address
		
		mergeloop:
	
		la	$t0, 0($s0)		# Load the first half position pointer
		la	$t1, 0($s1)		# Load the second half position pointer
		lw	$t0, 0($t0)		# Load the first half position value
		lw	$t1, 0($t1)		# Load the second half position value
		
		bgt	$t1, $t0, noshift	# If the lower value is already first, don't shift
		
		move	$a0, $s1		# Load the value for the element to move
		move	$a1, $s0		# Load the value for the address to move it to
		jal	shift			# Shift the element to the new position 
		
		addi	$s1, $s1, 4		# Increment the second half index
		
		#increments the address of the first half index by four bits
		noshift:
		addi	$s0, $s0, 4		# Increment the first half index
		lw	$a2, 12($sp)		# Reload the end address
		bge	$s0, $a2, mergeloopend	# End the loop when both halves are empty i.e. the copy of the first address = the end address
		bge	$s1, $a2, mergeloopend	# End the loop when both halves are empty i.e. the copy of the second address = the end address
		b	mergeloop	#go back to mergeloop
	
		#merge loop is done so go back to mergesort
		mergeloopend:
		
		lw	$ra, 0($sp)		# Load the return address
		addi	$sp, $sp, 16		# Adjust the stack pointer
		jr 	$ra			# Return

		
		# Shift an array element to another position at a lower address
		# $a0 address of element to shift
		# $a1 destination address of element
		
		shift:
		li	$t0, 10			# load the size in $t0
		ble	$a0, $a1, shiftend	# If we are at the location, stop shifting	#($a1) is address of first half
		addi	$t6, $a0, -4		# Find the previous address in the array	#($a0) is address of second half
		lw	$t7, 0($a0)		# Get the current pointer	
		lw	$t8, 0($t6)		# Get the previous pointer
		sw	$t7, 0($t6)		# Save the current pointer to the previous address
		sw	$t8, 0($a0)		# Save the previous pointer to the current address
		move	$a0, $t6		# Shift the current position back
		b 	shift			# Loop again
		
		#go back to the stored address of the mergeloop
		shiftend:
		jr	$ra			# Return
	
		sortend:			# Point to jump to when sorting is complete


		# Print out the indirect array
		li	$t0, 0				# Initialize the current index
		loop_2:
		lw	$t1,length			# Load the array length
		bge	$t0,$t1,done			# If we hit the end of the array, we are done
		sll	$t2,$t0,2			# Multiply the index by 4 (2^2)
		la	$t3,Arr($t2)			# Get the pointer
		lw	$a0,0($t3)			# Get the value pointed to and store it for printing
		li	$v0,1				
		syscall					# Print the value
		la	$a0,nLine			# Set the value to print to the newline
		li	$v0,4				
		syscall					# Print the value
		addi	$t0,$t0,1			# Increment the current index
		b	loop_2				# Run through the print block again
		done:					# We are finished
		li	$v0,10
		syscall


mainSelection: 
		la	$a0, str1		# Print of str1
		li	$v0, 4			#
		syscall				#

		lw	$s2, length

		sll	$s0, $s2, 2		# $s0=n*4
		sub	$sp, $sp, $s0		# This instruction creates a stack
						# frame large enough to contain
						# the array
		move	$s1, $zero		# i=0
for_get:	bge	$s1, $s2, exit_get	# if i>=n go to exit_for_get
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $t0, $sp		# $t1=$sp+i*4
		li	$v0, 5			# Get one element of the array
		syscall				#
		sw	$v0, 0($t1)		# The element is stored
						# at the address $t1
		la	$a0, str5
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	for_get
exit_get:	move	$a0, $sp		# $a0=base address af the array
		move	$a1, $s2		# $a1=size of the array
		jal	isort			# isort(a,n)
						# In this moment the array has been 
						# sorted and is in the stack frame 
		la	$a0, str3		# Print of str3
		li	$v0, 4
		syscall

		move	$s1, $zero		# i=0
for_print:	bge	$s1, $s2, exit_print	# if i>=n go to exit_print
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $sp, $t0		# $t1=address of a[i]
		lw	$a0, 0($t1)		#
		li	$v0, 1			# print of the element a[i]
		syscall				#

		la	$a0, str5
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	for_print
exit_print:	add	$sp, $sp, $s0		# elimination of the stack frame 
              
		li	$v0, 10			# EXIT
		syscall			#
		
		
# selection_sort
isort:		addi	$sp, $sp, -20		# save values on stack
		sw	$ra, 0($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)
		sw	$s2, 12($sp)
		sw	$s3, 16($sp)

		move 	$s0, $a0		# base address of the array
		move	$s1, $zero		# i=0

		subi	$s2, $a1, 1		# lenght -1
isort_for:	bge 	$s1, $s2, isort_exit	# if i >= length-1 -> exit loop
		
		move	$a0, $s0		# base address
		move	$a1, $s1		# i
		move	$a2, $s2		# length - 1
		
		jal	mini
		move	$s3, $v0		# return value of mini
		
		move	$a0, $s0		# array
		move	$a1, $s1		# i
		move	$a2, $s3		# mini
		
		jal	swap_selection

		addi	$s1, $s1, 1		# i += 1
		j	isort_for		# go back to the beginning of the loop
		
isort_exit:	lw	$ra, 0($sp)		# restore values from stack
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		lw	$s2, 12($sp)
		lw	$s3, 16($sp)
		addi	$sp, $sp, 20		# restore stack pointer
		jr	$ra			# return


# index_minimum routine
mini:		move	$t0, $a0		# base of the array
		move	$t1, $a1		# mini = first = i
		move	$t2, $a2		# last
		
		sll	$t3, $t1, 2		# first * 4
		add	$t3, $t3, $t0		# index = base array + first * 4		
		lw	$t4, 0($t3)		# min = v[first]
		
		addi	$t5, $t1, 1		# i = 0
mini_for:	bgt	$t5, $t2, mini_end	# go to min_end

		sll	$t6, $t5, 2		# i * 4
		add	$t6, $t6, $t0		# index = base array + i * 4		
		lw	$t7, 0($t6)		# v[index]

		bge	$t7, $t4, mini_if_exit	# skip the if when v[i] >= min
		
		move	$t1, $t5		# mini = i
		move	$t4, $t7		# min = v[i]

mini_if_exit:	addi	$t5, $t5, 1		# i += 1
		j	mini_for

mini_end:	move 	$v0, $t1		# return mini
		jr	$ra


# swap_selection routine
swap_selection:		sll	$t1, $a1, 2		# i * 4
		add	$t1, $a0, $t1		# v + i * 4
		
		sll	$t2, $a2, 2		# j * 4
		add	$t2, $a0, $t2		# v + j * 4

		lw	$t0, 0($t1)		# v[i]
		lw	$t3, 0($t2)		# v[j]

		sw	$t3, 0($t1)		# v[i] = v[j]
		sw	$t0, 0($t2)		# v[j] = $t0

		jr	$ra
