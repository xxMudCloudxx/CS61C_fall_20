.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
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
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw t0, 24(sp)
    sw t1, 28(sp)
    sw t2, 32(sp)
    sw t3, 36(sp)
    sw s5, 40(sp)
    sw s6, 44(sp)
    sw s7, 48(sp)


    add s0, x0, a0                  # s0 is the pointer to string representing the filename
    add s1, x0, a1                  # s1 is a pointer to an integer, set it to the number of rows
    add s2, x0, a2                  # s2 is a pointer to an integer, set it to the number of columns

    # Open file and get filename descriptor
    mv a1, s0                       # a1 is filepath
    li a2, 0                        # a2 is permissions
    jal fopen
    li t0, -1
    beq a0, t0, Exceptions_open_90
    add s3, x0, a0                  # s3 is the file descriptor
    
    # Read rows
    add a1, s3, x0                  # a1 is file descriptor
    add a2, s1, x0                  # a2 is the pointer to the buffer you want to write the read bytes to.
    li a3, 4                        # a3 is the number of bytes to be read.
    jal fread                       # read rows in s1
    li t0, 4
    bne a0, t0, Exceptions_read_91  # check read error

    # Read columns
    add a1, s3, x0                  # a1 is file descriptor
    add a2, s2, x0                  # a2 is the pointer to the buffer you want to write the read bytes to.
    li a3, 4                        # a3 is the number of bytes to be read.
    jal fread                       # read columns in s2
    li t0, 4
    bne a0, t0, Exceptions_read_91  # check read error

    # Malloc memory for matrix
    lw t0, 0(s1)                    # Note: s1 is a pointer
    lw t1, 0(s2)                    # Note: s2 is a pointer
    mul s4, t0, t1                  # the num of the rest of the elements(size of the matrix)
    li s5, 4                        # 4 bytes for each elements
    mul a0, s4, s5                  # pass the total bytes needed to a0
    jal malloc
    beq a0, x0, Exceptions_malloc_88
    add s6, a0, x0                  # s6 is the pointer to the matrix memory

    # Preparation for loop
    add s7, x0, x0                  # s7 is the counter of the loop

loop_start:
    mul t0, s5, s7                  # t0 is the offset
    add t1, s6, t0                  # t1 is the address of the element

    # read the rest number
    mv a1, s3                       # a1 is file descriptor
    mv a2, t1                       # a2 is the pointer to the buffer you want to write the read bytes to.
    mv a3, s5                       # a3 is the number of bytes to be read.
    jal fread
    bne a0, s5, Exceptions_read_91
    addi s7, s7, 1
    blt s7, s4, loop_start


    # Finish reading, close the file
    mv a1, s3

    jal fclose
    bne a0, x0, Exceptions_close_92

    # Return the pointer of the matrix
    mv a0, s6

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw t0, 24(sp)
    lw t1, 28(sp)
    lw t2, 32(sp)
    lw t3, 36(sp)
    lw s5, 40(sp)
    lw s6, 44(sp)
    lw s7, 48(sp)
    addi sp, sp, 52
    ret

Exceptions_malloc_88:
    li a1, 88
    j exit2

Exceptions_open_90:
    li a1, 90
    j exit2
    
Exceptions_read_91:
    li a1, 91
    j exit2
    
Exceptions_close_92:
    li a1, 92
    j exit2
    