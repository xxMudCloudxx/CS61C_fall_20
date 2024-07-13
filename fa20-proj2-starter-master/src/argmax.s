.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -36
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw t4, 20(sp)
    sw s0, 24(sp)
    sw s1, 28(sp)
    sw s2, 32(sp)

loop_start:
    beq a0, x0, Exceptions      # if a0 is null pointer raise error
    li t0, 1                    
    blt a1, t0, Exceptions      # if a1 is less than 1 raise error

    add t0, a0, x0              # t0 is the pointer to the start of the vector
    add t1, a1, x0              # t1 is the num of elements in the vector
    add t2, x0, x0              # t2 is the counter of the loop
    lw s1, 0(t0)                # s1 is the greatest of the first index(default the first one)
    add s0, x0, x0              # s0 is the index of the greatest one

loop_continue:
    li t3, 4                    # t3 is the strides
    mul t4, t3, t2              # t4 is the offset
    add t4, t4, t0              # t4 is the address of the target element
    lw s2, 0(t4)                # load cur value
    blt s2, s1, update_tag      # if the cur one less then greatest one, continue, or update
    add s1, s2, x0              # update the greatest
    add s0, t2, x0              # update the max index

update_tag:
    addi t2, t2, 1              # update the counter
    blt t2, t1, loop_continue 
loop_end:

    add a0, s0, x0  # return max value's index
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    lw t4, 20(sp)
    lw s0, 24(sp)
    lw s1, 28(sp)
    lw s2, 32(sp)
    addi sp, sp, 36
    # Epilogue


    ret
Exceptions:
    li a1, 77
    j exit2