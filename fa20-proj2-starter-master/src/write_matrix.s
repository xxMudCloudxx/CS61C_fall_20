.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
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
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

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
    sw s10, 48(sp)


    mv s0, a0                       # s0 is the pointer to string representing the filename
    mv s1, a1                       # s1 is the pointer to the start of the matrix in memory
    mv s2, a2                       # s2 is the number of rows in the matrix
    mv s3, a3                       # s3 is the number of columns in the matrix
    addi s10, x0, 4                 # s10 is number of size of each what we write

    # Open file and get filename descriptor
    mv a1, s0                       # a1 is filepath
    li a2, 0                        # a2 is permissions
    jal fopen
    li t0, -1
    beq a0, t0, Exceptions_open_93

    add s4, x0, a0                  # s4 is the file descriptor

    # Writer rows and columns

    # The a2 of fwrite need a pointer, so we should creat memory to store rows and columns.
    li t0, 8
    mv a0, t0
    jal malloc
    mv t1, a0
    sw s2, 0(a0)
    sw s3, 4(a0)

    mv a1, s4
    mv a2, t1
    li t2, 2
    mv a3, t2
    mv a4, s10
    jal fwrite

    li t2, 2
    bne a0, t2, Exceptions_write_94

    # Write matrix
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    mv a4, s10
    jal fwrite

    mul t2, s2, s3
    bne a0, t2, Exceptions_write_94

    # Close the file
    mv a1, s4
    jal fclose
    bne a0, x0, Exceptions_close_95

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
    lw s10, 48(sp)
    addi sp, sp, 52

    ret

Exceptions_open_93:
    li a1, 93
    j exit2

Exceptions_write_94:
    li a1, 94
    j exit2
 
Exceptions_close_95:
    li a1, 95
    j exit2
