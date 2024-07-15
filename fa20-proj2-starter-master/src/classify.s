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
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>



    # prologue
	addi sp, sp, -68
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw t0, 24(sp)
    sw t1, 28(sp)
    sw t2, 32(sp)
    sw s5, 40(sp)
    sw s6, 44(sp)
    sw s7, 48(sp)
    sw s8, 52(sp)
    sw s9, 56(sp)
    sw s10, 60(sp)
    sw s11, 64(sp)

    # Check correct number of command line args
    li t0, 5
    bne t0, a0, Exceptions_incorrect_input_89
    add s11, a2, x0                     # s11 is the print_classification
	# =====================================
    # LOAD MATRICES
    # =====================================
    li t0, 4
    add s0, t0, a1
    lw s1, 0(s0)                        # s1 is the MO_PATH name

    add s0, t0, s0
    lw s2, 0(s0)                        # s2 is the M1_PATH name

    add s0, t0, s0
    lw s3, 0(s0)                        # s3 is the INPUT_PATH name

    add s0, t0, s0
    lw s4, 0(s0)                        # s4 is the OUTPUT_PATH name

    # Load pretrained m0
    li t0, 8
    mv a0, t0
    jal malloc
    beq a0, x0, Exceptions_malloc_88

    mv s5, a0                           # s5 is a pointer which has 8 bytes memory
    
    mv a0, s1
    mv a1, s5                           # s5 store the rows and columns of m0
    addi a2, s5, 4

    jal read_matrix
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    #   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    # Returns:
    #   a0 (int*)  is the pointer to the matrix in memory

    mv s6, a0                           # s6 is a pointer to m0 matrix

    # Load pretrained m1
    li t0, 8
    mv a0, t0
    jal malloc
    beq a0, x0, Exceptions_malloc_88

    mv s7, a0                           # s7 is a pointer which has 8 bytes memory
    
    mv a0, s2
    mv a1, s7                           # s7 store the rows and columns of m1
    addi a2, s7, 4

    jal read_matrix
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    #   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    # Returns:
    #   a0 (int*)  is the pointer to the matrix in memory

    mv s8, a0                           # s8 is a pointer to m1 matrix


    # Load input matrix
    li t0, 8
    mv a0, t0
    jal malloc
    beq a0, x0, Exceptions_malloc_88

    mv s9, a0                           # s9 is a pointer which has 8 bytes memory
    
    mv a0, s3
    mv a1, s9                           # s9 store the rows and columns of input matrix
    addi a2, s9, 4

    jal read_matrix
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    #   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    # Returns:
    #   a0 (int*)  is the pointer to the matrix in memory

    mv s10, a0                          # s10 is a pointer to input matrix


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # 1. LINEAR LAYER:    m0 * input
    lw t0, 0(s5)
    lw t1, 4(s9)
    mul a0, t0, t1
    slli a0, a0, 2

    jal malloc
    beq a0, x0, Exceptions_malloc_88
    mv s1, a0                           #  s1 is pointer of m0 * input result.

    # m0's pointer, rows and columns
    mv a0, s6
    lw a1, 0(s5)
    lw a2, 4(s5)
    
    # input's pointer, rows and columns
    mv a3, s10
    lw a4, 0(s9)
    lw a5, 4(s9)

    # the result pointer
    mv a6, s1

    jal matmul
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

    mv s2, s1                           #  s2 is pointer of ReLU(m0 * input)                          

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, s2
    lw t0, 0(s5)                        # t0 is the rows of m0
    lw t1, 4(s9)                        # t1 is the columns of input
    mul a1, t0, t1
    jal relu

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 0(s7)                        # t0 is the columns of m1
    lw t1, 4(s9)                        # t1 is the columns of input
    mul a0, t0, t1
    slli a0, a0, 2      

    jal malloc
    beq a0, x0, Exceptions_malloc_88

    mv s3, a0                           # s3 is a pointer to score matrix

    # m1's pointer, rows and columns
    mv a0, s8      
    lw a1, 0(s7)                        # a1 is the rows of m1
    lw a2, 4(s7)                        # a2 is the columns of m1

    # ReLU(m0 * input)'s pointer, rows and columns
    mv a3, s2
    lw a4, 0(s5)
    lw a5, 4(s9)
    mv a6, s3                           # load params

    jal matmul
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

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0, s4
    mv a1, s3
    lw a2, 0(s7)
    lw a3, 4(s9)

    jal write_matrix
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is the pointer to the start of the matrix in memory
    #   a2 (int)   is the number of rows in the matrix
    #   a3 (int)   is the number of columns in the matrix
    # Returns:
    #   None
    
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s3
    lw t0, 0(s5)
    lw t1, 4(s9)
    mul a1, t0, t1
    jal argmax

    mv s3, a0                            # store the greatest index of result

    bne s11, x0, no_print

    # Print classification
    mv a1, s3
    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

no_print:
    # Free the space


    mv a0, s5
    jal free

    mv a0, s6
    jal free

    mv a0, s7
    jal free

    mv a0, s8
    jal free

    mv a0, s9
    jal free

    mv a0, s10
    jal free

    mv a0, s11
    jal free

    mv a0, s3      # return the result

    # epilogue
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
    lw s5, 40(sp)
    lw s6, 44(sp)
    lw s7, 48(sp)
    lw s8, 52(sp)
    lw s9, 56(sp)
    lw s10, 60(sp)
    lw s11, 64(sp)
    addi sp, sp, 68

    ret

Exceptions_incorrect_input_89:
    li a1, 89
    j exit2

Exceptions_malloc_88:
    li a1, 88
    j exit2