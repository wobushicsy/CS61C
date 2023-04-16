.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue


loop_start:
    lw t0, 0(a0)
    blt x0, t0, do_nothing
    mv t0, x0

do_nothing:
    sw t0, 0(a0)

    addi a1, a1, -1
    addi a0, a0, 4

    bne a1, x0, loop_start


loop_continue:



loop_end:


    # Epilogue

    
	ret