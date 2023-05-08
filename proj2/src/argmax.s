.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    # s0 maxindex
    # s1 maxargument
    # push s0, s1
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    mv s0, x0
    li s1, 0x80000000

    mv t1, x0 # counter


loop_start:
    lw t0, 0(a0)
    ble t0, s1, do_nothing

    mv s1, t0
    mv s0, t1

do_nothing:
    addi t1, t1, 1
    addi a0, a0, 4

    bne t1, a1, loop_start


loop_end:
    mv a0, s0
    

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8


    ret