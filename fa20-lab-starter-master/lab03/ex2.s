.globl main

.data
# 初始化数组
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
fun:
    addi t0, a0, 1
    sub t1, x0, a0
    mul a0, t0, t1
    jr ra

main:
    # BEGIN PROLOGUE
    addi sp, sp, -20
    sw s0, 0(sp)    # SUM
    sw s1, 4(sp)    # SOURCE指针
    sw s2, 8(sp)    # DEST指针
    sw s3, 12(sp)
    sw ra, 16(sp)
    # END PROLOGUE
	addi t0, x0, 0	# K
    addi s0, x0, 0
    la s1, source
    la s2, dest
loop:
    slli s3, t0, 2   # 偏移量
    add t1, s1, s3   # source偏移后的地址
    lw t2, 0(t1)     # source[k]的值
    # CONDITION
    beq t2, x0, exit
    add a0, x0, t2   # a0存储source[k]的值，以便后面传参
    # JUMP FUN
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t2, 4(sp)
    jal fun          # a0存储着fun返回的值
    lw t0, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    # BACK
    add t2, x0, a0   # t2代a0
    add t3, s2, s3   # 偏移后的地址
    sw t2, 0(t3)     
    add s0, s0, t2

    addi t0, t0, 1
    jal x0, loop
exit:
    add a0, x0, s0
    # BEGIN EPILOGUE
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    # END EPILOGUE
    jr ra