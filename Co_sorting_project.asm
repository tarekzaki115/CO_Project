.data
Arr:    .word 0,0,0,0,0,0,0,0,0,0   
choice1: .word 0
choice2: .word 0 
length: .word 10	
text:   .asciiz "enter a number\n"
nLine:  .asciiz "\n"
	NumOrCHar1: .asciiz "do you want to sort numbers or letters?\n"		
	NumOrCHar2: .asciiz "enter 1 for numbers or 2 for letters\n"
	promptSort1: .asciiz "what sorting algorithm do you want to be used?\n"
	promptSort2: .asciiz "enter 1 for bubble sort, 2 for selection sort or 3 for merge sort\n"
	promptSort3: .asciiz "please enter a number:\n"
	
	eol:		.asciiz	"\n"
	

.text

	main:

	# a0 has NumOrCHar1
	# t0 has NumOrCHar2
		la $a0, NumOrCHar1
		la $t0, NumOrCHar2
	# printing NumOrCHar1
		li $v0, 4
		syscall
	# moving NumOrCHar2 into a0
		move $a0, $t0
	# printing NumOrCHar2
		li $v0,4
		syscall
		
	# scan from user the choice in choice1
		li $v0, 5
		syscall
		
	# move value from v0 to t0 then store it in choice1
		move $t0, $v0
		sw $t0, choice1

	# prompt choosing sorting algorithm
		la $a0, promptSort1
		la $t0, promptSort2
		li $v0, 4
		syscall
		move $a0, $t0
		li $v0, 4
		syscall
	# scan the user's choice in choice2
		li $v0, 5
		syscall		
		move $t0, $v0
		sw $t0, choice2

	# scan the data from the user
	
	lw $t0, choice2
	beq $t0,3 , merging
	beq $t0,1 , bubbleSort
	
		

		
	#end main
		li $v0, 10
		syscall
	
		
	bubbleSort:
		li      $t1,10                   # get total number of array elements
    		j scanData

# main_loop -- do multiple passes through array
main_loop:
    subi    $a1,$t1,1               # get count for this pass (must be one less)
    blez    $a1,main_done           # are we done? if yes, fly

    la      $a0,Arr                 # get address of array
    li      $t2,0                   # clear the "did swap" flag

    jal     pass_loop               # do a single sort pass

    # NOTES:
    # (1) if we make no swaps on a given pass, everything is in sort and we
    #     can stop
    # (2) after a pass the last element is now highest, so there is no need
    #     to compare it again
    # (3) a standard optimization is that each subsequent pass shortens the
    #     pass count by 1
    # (4) by bumping down the outer loop count here, this serves both _us_ and
    #     the single pass routine [with a single register]

    beqz    $t2,main_done           # if no swaps on current pass, we are done

    subi    $t1,$t1,1               # bump down number of remaining passes
    b       main_loop

# everything is sorted
# do whatever with the sorted data ...


scanData:
addi $t8, $zero, 10
la $t2, Arr
while_scan:
beqz $t8, main_loop

la $a0, text
li $v0, 4
syscall

li $v0, 5
syscall
move $t0, $v0

sw $t0, ($t2)

addi $t8, $t8, -1
addi $t2, $t2, 4
j while_scan


main_done:

li      $v0, 0
la      $t1, Arr
addi $t0, $zero, 0
loop1:
    bge     $t0, 10, end

    # load word from addrs and goes to the next addrs
    lw      $t2, 0($t1)
    addi    $t1, $t1, 4
    
    la $a0, nLine
    li $v0, 4
    syscall

    # syscall to print value
    li      $v0, 1      
    move    $a0, $t2
    syscall

    #increment counter
    addi    $t0, $t0, 1
    j      loop1

# pass_loop -- do single pass through array
#   a0 -- address of array
#   a1 -- number of loops to perform (must be one less than array size because
#         of the 4($a0) below)
pass_loop:
    lw      $s1,0($a0)              # Load first element in s1
    lw      $s2,4($a0)              # Load second element in s2
    bgt     $s1,$s2,pass_swap       # if (s1 > s2) swap elements

pass_next:
    addiu   $a0,$a0,4               # move pointer to next element
    subiu   $a1,$a1,1               # decrement number of loops remaining
    bgtz    $a1,pass_loop           # swap pass done? if no, loop
    jr      $ra                     # yes, return

pass_swap:
    sw      $s1,4($a0)              # put value of [i+1] in s1
    sw      $s2,0($a0)              # put value of [i] in s2
    li      $t2,1                   # tell main loop that we did a swap
    j       pass_next

# End the program
end:
    li      $v0,10
    syscall
				
					
						
								
	merging:	
		scanDataMerge:
		addi $t8, $zero, 10
		la $t2, Arr
		while_scanMerge:
		beqz $t8, cont
		
		la $a0, text
		li $v0, 4
		syscall

		li $v0, 5
		syscall
		move $t0, $v0

		sw $t0, ($t2)

		addi $t8, $t8, -1
		addi $t2, $t2, 4
		j while_scanMerge

	cont:
		# sending data to choosen algorithm
		lw $t0, choice2
		beq $t0, 3 , mergeSortAlgorithm

		
		li $v0, 10
		syscall
	

	mergeSortAlgorithm:
	
		la	$a0, Arr		# Load the start address of the array
		lw	$t0, length		# Load the array length
		sll	$t0, $t0, 2		# Multiple the array length by 4 (the size of the elements)
		add	$a1, $a0, $t0		# Calculate the array end address
		jal	mergesort		# Call the merge sort function
  		b	sortend			# We are finished sorting
	
		li	$v0,10
		syscall
		##
		# Recrusive mergesort function
		#
		# @param $a0 first address of the array
		# @param $a1 last address of the array
		##
		mergesort:

		addi	$sp, $sp, -16		# Adjust stack pointer
		sw	$ra, 0($sp)		# Store the return address on the stack
		sw	$a0, 4($sp)		# Store the array start address on the stack
		sw	$a1, 8($sp)		# Store the array end address on the stack
	
		sub 	$t0, $a1, $a0		# Calculate the difference between the start and end address (i.e. number of elements * 4)

		ble	$t0, 4, mergesortend	# If the array only contains a single element, just return	
	
		srl	$t0, $t0, 3		# Divide the array size by 8 to half the number of elements (shift right 3 bits)
		sll	$t0, $t0, 2		# Multiple that number by 4 to get half of the array size (shift left 2 bits)
		add	$a1, $a0, $t0		# Calculate the midpoint address of the array
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
	
		##
		# Merge two sorted, adjacent arrays into one, in-place
		#
		# @param $a0 First address of first array
		# @param $a1 First address of second array
		# @param $a2 Last address of second array
		##
		merge:
		addi	$sp, $sp, -16		# Adjust the stack pointer
		sw	$ra, 0($sp)		# Store the return address on the stack
		sw	$a0, 4($sp)		# Store the start address on the stack
		sw	$a1, 8($sp)		# Store the midpoint address on the stack
		sw	$a2, 12($sp)		# Store the end address on the stack
		
		move	$s0, $a0		# Create a working copy of the first half address
		move	$s1, $a1		# Create a working copy of the second half address
		
		mergeloop:
	
		la	$t0, 0($s0)		# Load the first half position pointer
		la	$t1, 0($s1)		# Load the second half position pointer
		lw	$t0, 0($t0)		# Load the first half position value
		lw	$t1, 0($t1)		# Load the second half position value
		
		bgt	$t1, $t0, noshift	# If the lower value is already first, don't shift
		
		move	$a0, $s1		# Load the argument for the element to move
		move	$a1, $s0		# Load the argument for the address to move it to
		jal	shift			# Shift the element to the new position 
		
		addi	$s1, $s1, 4		# Increment the second half index
		noshift:
		addi	$s0, $s0, 4		# Increment the first half index
	
		lw	$a2, 12($sp)		# Reload the end address
		bge	$s0, $a2, mergeloopend	# End the loop when both halves are empty
		bge	$s1, $a2, mergeloopend	# End the loop when both halves are empty
		b	mergeloop
	
		mergeloopend:
		
		lw	$ra, 0($sp)		# Load the return address
		addi	$sp, $sp, 16		# Adjust the stack pointer
		jr 	$ra			# Return

		##
		# Shift an array element to another position, at a lower address
		#
		# @param $a0 address of element to shift
		# @param $a1 destination address of element
		##
		shift:
		li	$t0, 10
		ble	$a0, $a1, shiftend	# If we are at the location, stop shifting
		addi	$t6, $a0, -4		# Find the previous address in the array
		lw	$t7, 0($a0)		# Get the current pointer
		lw	$t8, 0($t6)		# Get the previous pointer
		sw	$t7, 0($t6)		# Save the current pointer to the previous address
		sw	$t8, 0($a0)		# Save the previous pointer to the current address
		move	$a0, $t6		# Shift the current position back
		b 	shift			# Loop again
		shiftend:
		jr	$ra			# Return
	
		sortend:			# Point to jump to when sorting is complete


		# Print out the indirect array
		li	$t0, 0				# Initialize the current index
		prloop:
		lw	$t1,length			# Load the array length
		bge	$t0,$t1,prdone			# If we hit the end of the array, we are done
		sll	$t2,$t0,2			# Multiply the index by 4 (2^2)
		la	$t3,Arr($t2)			# Get the pointer
		lw	$a0,0($t3)			# Get the value pointed to and store it for printing
		li	$v0,1				
		syscall					# Print the value
		la	$a0,eol				# Set the value to print to the newline
		li	$v0,4				
		syscall					# Print the value
		addi	$t0,$t0,1			# Increment the current index
		b	prloop				# Run through the print block again
		prdone:					# We are finished
		li	$v0,10
		syscall
