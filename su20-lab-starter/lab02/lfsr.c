#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

uint16_t get_bit(uint16_t x,
                 unsigned n) {
    return x << (15-n) >> 15;
}

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    int bit_0 = get_bit(*reg, 0);
    int bit_2 = get_bit(*reg, 2);
    int bit_3 = get_bit(*reg, 3);
    int bit_5 = get_bit(*reg, 5);
    *reg >>= 1;
    int bit_15 = bit_0 ^ bit_2 ^ bit_3 ^ bit_5;
    bit_15 <<= 15;
    *reg += bit_15;
}

