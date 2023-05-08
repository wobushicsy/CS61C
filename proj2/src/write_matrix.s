.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
	# push ra, s0, s1, s2, s3, s4, s5, s6
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw a2, 24(sp)
    sw a3, 28(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # openfile
    mv a1, s0
    li a2, 1
    jal ra, fopen
    mv s4, a0

    # write row and column to the file
    mv a1, s4
    addi a2, sp, 24
    li a3, 1
    li a4, 4
    jal ra, fwrite
    mv a1, s4
    addi a2, sp, 28
    li a3, 1
    li a4, 4
    jal ra, fwrite

    # write matrix to the file
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal ra, fwrite

    # close file
    mv a1, s4
    jal ra, fclose





    # Epilogue
    # pop ra, s0, s1, s2, s3, s4, s5, s6
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 32


    ret
