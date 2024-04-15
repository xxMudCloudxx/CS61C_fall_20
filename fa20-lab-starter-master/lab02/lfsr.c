#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

uint16_t get_bit(uint16_t x,
                 uint16_t n) {
    return (x >> n) & 1;
}

void set_bit(uint16_t * x,
             uint16_t v) {
    // YOUR CODE HERE
    if (v) {
        *x |= (1 << 15);
    } else {
        *x &= ~(1 << 15);
    }
}

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    uint16_t last = get_bit(*reg, 0);
    *reg >>= 1;
    last = get_bit(*reg, 1) ^ last;
    last = get_bit(*reg, 2) ^ last;
    last = get_bit(*reg, 4) ^ last;
    set_bit(reg, last);
}

