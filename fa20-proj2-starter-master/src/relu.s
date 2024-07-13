.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the numbers of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -28
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw s0, 20(sp)
    sw ra, 24(sp)

loop_start:
    beq a0, x0, Exceptions    # if pointer is null, raise error

    addi t0, x0, 1
    blt a1, t0, Exceptions    # if the length of the vector is less than 1;

    add t0, a0, x0            # t0 is the pointer to the array  
    add t1, a1, x0            # t1 is the num of elements
    add t2, x0, x0            # t2 is the counter of the loop

loop_continue:
    li t3, 4             # t3 is the stride
    mul t4, t3, t2            # t4 is the offset
    add t4, t4, t0            # t4 is the address of the target elements
    lw s0, 0(t4)

    bge s0, x0, greater_than_zero
    sw x0, 0(t4)

greater_than_zero:
    addi t2, t2, 1             # update the counter
    bge t1, t2, loop_continue

loop_end:
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw s0, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    # Epilogue

    
	ret
Exceptions:
    li a1, 78
    j exit2