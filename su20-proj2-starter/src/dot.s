.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    # error check
    ble a2, x0, exit_5
    ble a3, x0, exit_6
    ble a4, x0, exit_6

    # Prologue

    # t0 counter
    mv t0, x0

    # t1 sum
    mv t1, x0

loop_start:
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t2, t2, t3

    add t1, t1, t2

    addi t0, t0, 1
    add a0, a0, a3
    add a1, a1, a4

    bne t0, a2, loop_start


loop_end:

    mv a0, t1

    # Epilogue

    
    ret

exit_5:
    li a0, 5
    ret

exit_6:
    li a0, 6
    ret