.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
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
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    ble a1, x0, Exceptions_dimen_m0         # if the dimensions of m0 do not make sense
    ble a2, x0, Exceptions_dimen_m0         # if the dimensions of m0 do not make sense
    ble a4, x0, Exceptions_dimen_m1         # if the dimensions of m1 do not make sense
    ble a5, x0, Exceptions_dimen_m1         # if the dimensions of m1 do not make sense
    bne a2, a4, Exceptions_dimen_match      # if a2 != a4 then Exceptions_dimen_match

    # Prologue
    addi sp, sp, -56
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw t4, 20(sp)
    sw t5, 24(sp)
    sw s0, 28(sp)
    sw s1, 32(sp)
    sw s6, 36(sp)
    sw s7, 40(sp)
    sw s8, 44(sp)
    sw s9, 48(sp)
    sw s2, 52(sp)


    add t0, a0, x0              # t0 is the pointer to the start of m0
    add t1, a3, x0              # t1 is the pointer to the start of m1
    add t2, a6, x0              # t2 is the pointer to the start of d
    li s0, 4                    # s0 is the sizeof(int)
    add t3, x0, x0              # t3 is the counter of the outer_loop

    mv s6, a1                   # s6 is the # of rows (height) of m0
    mv s7, a2                   # s7 is the # of columns (width) of m0               
    mv s8, a4                   # s8 is the # of rows (height) of m1
    mv s9, a5                   # s9 is the # of columns (width) of m1 

outer_loop_start:
    mul t4, s0, t3
    mul t4, t4, s7              # s0 is the offset of the m0's row offset
    add s1, t0, t4              # s1 is the address of i-th row

    add t5, x0, x0               # t5 is the counter of the counter_loop

inner_loop_start:
    mul t4, s0, t5              # t4 is the offset of the m1's col offset
    add s2, t1, t4              # s2 is the address of j-th column

    mv a0, s1
    mv a1, s2
    mv a2, s8
    addi a3, x0, 1
    mv a4, s9

    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw t5, 24(sp)
    jal dot
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    lw t5, 24(sp)

    # store value in d
    mul t6, t3, s9
    add t6, t6, t5              # t5 is the number of the element before cur one
    mul t6, t6, s0              # t5 is the offset of the cur element of d 
    add t6, t2, t6              # t5 is the address of cur one
    sw a0 0(t6)

inner_loop_end:    
    addi t5, t5, 1
    blt t5, s9, inner_loop_start

outer_loop_end:
    addi t3, t3, 1
    blt t3, s6, outer_loop_start
    # Epilogue
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    lw t4, 20(sp)
    lw t5, 24(sp)
    lw s0, 28(sp)
    lw s1, 32(sp)
    lw s6, 36(sp)
    lw s7, 40(sp)
    lw s8, 44(sp)
    lw s9, 48(sp)
    lw s2, 52(sp)
    addi sp, sp, 56
    ret

Exceptions_dimen_m0:
    li a1, 72
    j exit2
Exceptions_dimen_m1:
    li a1, 73
    j exit2
Exceptions_dimen_match:
    li a1, 74
    j exit2