.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    # pass parameter in register a0, return value in register a0
    # if(a0 < 1)    return 1
    # return a0 * factorial(a0 - 1)
    
    # if(a0 < 3)    return a0
    addi x12, x0, 3
    blt a0, x12, default

    # return a0 * factorial(a0 - 1)
    
    # push a0, ra
    addi sp, sp, -8
    sw a0, 0(sp)
    sw ra, 4(sp)

    # a0 = a0 - 1
    addi a0, a0, -1

    # factorial(a0 - 1)
    jal ra, factorial

    # pop a0, ra
    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    # a0 = a0 * a1
    mul a0, a0, a1
    jr ra

default:
    jr ra