.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi sp, sp, -12
    sw ra, 8(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    # load m0* in s3, row* in s4, column* in s5
    li a0, 4
    jal ra, malloc
    mv s4, a0
    li a0, 4
    jal ra, malloc
    mv s5, a0
    lw a0, 4(s1)
    mv a1, s4
    mv a2, s5
    jal read_matrix
    mv s3, a0

    ########################################
    # test
    # mv a0, s3
    # lw a1, 0(s4)
    # lw a2, 0(s5)
    # jal ra, print_int_array
    ########################################


    # Load pretrained m1
    # load m1* in s6, row* in s7, column* in s8
    li a0, 4
    jal ra, malloc
    mv s7, a0
    li a0, 4
    jal ra, malloc
    mv s8, a0
    lw a0, 8(s1)
    mv a1, s7
    mv a2, s8
    jal read_matrix
    mv s6, a0

    ########################################
    # test
    # mv a0, s6
    # lw a1, 0(s7)
    # lw a2, 0(s8)
    # jal ra, print_int_array
    ########################################


    # Load input matrix
    # load imput* in s9, row* in s10, column* in s11
    li a0, 4
    jal ra, malloc
    mv s10, a0
    li a0, 4
    jal ra, malloc
    mv s11, a0
    lw a0, 12(s1)
    mv a1, s10
    mv a2, s11
    jal read_matrix
    mv s9, a0

    ########################################
    # test
    # mv a0, s9
    # lw a1, 0(s10)
    # lw a2, 0(s11)
    # jal ra, print_int_array
    ########################################


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # malloc for d, *d = sp[0]
    lw t0, 0(s3)
    lw t1, 0(s11)
    mul a0, t0, t1
    slli a0, a0, 4
    jal ra, malloc
    sw a0, 0(sp)

    # hidden_layer = matmul(m0, input)
    mv a0, s3
    lw a1, 0(s4)
    lw a2, 0(s5)
    mv a3, s9
    lw a4, 0(s10)
    lw a5, 0(s11)
    lw a6, 0(sp)
    jal ra, matmul

    ########################################
    # hidden_layer test
    # lw a0, 0(sp)
    # li a1, 3
    # li a2, 1
    # jal ra, print_int_array
    ########################################


    # relu(hidden_layer)
    lw a0, 0(sp)
    lw t0, 0(s3)
    lw t1, 0(s11)
    mul a1, t0, t1
    jal ra, relu

    ########################################
    # relu test
    # lw a0, 0(sp)
    # li a1, 3
    # li a2, 1
    # jal ra, print_int_array
    ########################################

    # malloc for scores
    lw t0, 0(s7)
    lw t1, 0(s11)
    mul t0, t0, t1
    slli a0, t0, 2
    jal malloc
    sw a0, 4(sp)

    # scores = matmul(m1, hidden_layer)
    mv a0, s6
    lw a1, 0(s7)
    lw a2, 0(s8)
    lw a3, 0(sp)
    lw a4, 0(s4)
    lw a5, 0(s11)
    lw a6, 4(sp)
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s1)
    lw a1, 4(sp)
    lw a2, 0(s7)
    lw a3, 0(s11)
    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    lw a0, 4(sp)
    lw a1, 0(s7)
    lw t0, 0(s11)
    mul a1, a1, t0
    jal ra, argmax

    # Print classification
    slli a0, a0, 2
    lw a1, 4(sp)
    add a1, a1, a0
    lw a1, 0(a1)
    jal ra, print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char


    # pop ra
    lw ra, 8(sp)
    addi sp, sp, 12

    ret