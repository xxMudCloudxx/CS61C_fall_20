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
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    addi sp, sp, -44
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw t4, 20(sp)
    sw t5, 24(sp)
    sw s0, 28(sp)
    sw s1, 32(sp)
    sw s2, 36(sp)
    sw s3, 40(sp)


loop_start:
    li t0, 1
    blt a2, t0, Exceptions_length       # if the length of the vector is less than 1
    blt a3, t0, Exceptions_stride       # if the the stride of v0 vector is less than 1
    blt a4, t0, Exceptions_stride       # if the the stride of v1 vector is less than 1
    add t0, x0, a0                      # t0 is the pointer to the start of v0
    add t1, x0, a1                      # t1 is the pointer to the start of v1
    add t2, x0, a2                      # t2 is the length of the vectors
    add t3, x0, x0                      # t3 is the counter of the loop
    add s2, x0, x0                      # s2 store the result

loop_continue:
    addi t4, x0, 4
    mul s0, t4, a3
    mul s0, t3, s0                      # s0 is the offset of the v0
    mul s1, t4, a4
    mul s1, t3, s1                      # s1 is the offset of the v1

    add s0, s0, t0                      # s0 is the address of the target element in v0
    add s1, s1, t1                      # s1 is the address of the target element in v1
    lw t4, 0(s0)                        # store the cur v0 value
    lw t5, 0(s1)                        # store the cur v1 value
    mul t4, t5, t4                      # mul  v0, v1
    add s2, s2, t4                      # s2 = s2 + curResult
    addi t3, t3, 1                      # update the counter
    blt t3, t2, loop_continue
loop_end:

    add a0, s2, x0                      # return the result
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
    lw s2, 36(sp)
    lw s3, 40(sp)
    addi sp, sp, 44
    ret

Exceptions_length:
    li a1, 75
    j exit2
Exceptions_stride:
    li a1, 76
    j exit2