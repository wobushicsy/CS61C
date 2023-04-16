.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    ble a1, x0, exit_2
    ble a2, x0, exit_2
    ble a4, x0, exit_3
    ble a5, x0, exit_3
    bne a2, a4, exit_4

    # Prologue
    # push s0, s1, s2, s3, s4, s5, s6

    # s0, s1 represent outer, inner loop counter
    mv s0, x0
    mv s1, x0

    # s2 represents current box of m2, init as a6
    mv s2, a6

    # s3, s4 represent current row, column of m0, m1, init as a0, a3
    mv s3, a0
    mv s4, a3

    # s5, s6 represent stride of m1, m2, const as a2 * 4, a5 * 4
    li t0, 4
    mul s5, a2, t0
    mul s6, a5, t0


outer_loop_start:
    # reset s1 to 0
    mv s1, x0

    mv t2, a3

    mv s1, x0

inner_loop_start:
    # t0 represents the sum counter
    mv t0, x0

    # t1, t2 represent the beginning of m0, m1 to mul and sum
    li t3, 4
    mul t4, t3, a2
    mul t4, t4, s0
    add t1, a0, t4
    mul t4, t3, s1
    add t2, t4, a3

    # t3 represents the sum
    mv t3, x0

    # t4 represents the sum loop counter
    mv t4, x0

mul_loop_start:
    # load data
    lw t5, 0(t1)
    lw t6, 0(t2)

    # do calculation
    mul t5, t5, t6
    add t3, t3, t5

    # increment t1, t2
    addi t1, t1, 4
    add t2, t2, s6

    # increment t4 and do conditional branch
    addi t4, t4, 1
    bne t4, a2, mul_loop_start

mul_loop_end:
    # store the sum and increment s2
    sw t3, 0(s2)
    addi s2, s2, 4

    # increment inner loop counter and co conditional branch
    addi s1, s1, 1
    bne s1, a5, inner_loop_start

inner_loop_end:

    # increment outer loop counter and co conditional branch
    addi s0, s0, 1
    bne s0, a1, outer_loop_start

outer_loop_end:


    # Epilogue
    # pop 

    ret

exit_2:
    li a0, 2
    ret

exit_3:
    li a0, 3
    ret

exit_4:
    li a0, 4
    ret