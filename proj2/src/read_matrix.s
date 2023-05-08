.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
	# push ra, s0, s1, s2, s3, s4, s5, s6
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    # save integer pointer
    mv s1, a1
    mv s2, a2

    # call fopen
    mv a1, a0
    mv a2, x0
    jal ra, fopen

    # save file descriptor
    mv s0, a0

    # s3 = (int*) row
    # test success
    li a0, 4
    jal ra, malloc
    mv s3, a0
    mv a1, s0
    mv a2, s3
    li a3, 4
    jal ra, fread

    ##############################
    # test:                      #
    # lw a1, 0(s3)               #
    # jal ra, print_int          #
    ##############################

    # s4 = (int*) column
    # test pass
    li a0, 4
    jal ra, malloc
    mv s4, a0
    mv a1, s0
    mv a2, s4
    li a3, 4
    jal ra, fread

    ##############################
    # test:                      #
    # lw a1, 0(s4)               #
    # jal ra, print_int          #
    ##############################

    # calculate total needed memory 
    lw t0, 0(s3)
    lw t1, 0(s4)
    mul t0, t0, t1
    slli s5, t0, 2

    # malloc for matrix
    mv a0, s5
    jal ra, malloc
    mv s6, a0

    # read matrix
    mv a1, s0
    mv a2, s6
    mv a3, s5
    jal ra, fread  

    mv a1, s3
    jal ra, fclose

    mv a0, s6
    lw t0, 0(s3)
    sw t0, 0(s1)
    lw t0, 0(s4)
    sw t0, 0(s2)


    # Epilogue
    # pop ra, s0, s1, s2, s3, s4, s5, s6
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32

    ret