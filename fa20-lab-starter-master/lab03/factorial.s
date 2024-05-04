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
    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)
    addi t1, x0, 1
    add t2, a0, x0
Loop:
    beq t2, t1, Done
    sub t2, t2, t1
    mul a0, a0, t2
    j Loop
Done:
    lw t2, 4(sp)
    lw t1, 0(sp)
    addi sp, sp, 8
    jr ra