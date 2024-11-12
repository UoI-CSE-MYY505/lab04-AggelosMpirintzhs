
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 3
            jal  recCheck

            li   a7, 10
            ecall

str_ge: 
    lbu t0, 0(a0)
    lbu t1, 0(a1)
    beq t1,zero,biggerequal
    beq t0,zero,smaller
    
    bgt t0, t1, biggerequal
    bgt t1, t0, smaller
    
    addi a0, a0, 1 
    addi a1, a1, 1
    j str_ge
    biggerequal:
        addi a0, zero, 1
        jr ra
    smaller:
        addi a0 zero, 0
        jr ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
    addi sp, sp, -12    # adjust the stack
    sw ra, 0(sp)    # save return address
    sw a0, 4(sp)    # save array address
    sw a1, 8(sp)    # save size
    
    addi t0, zero, 1    # just to compare with the size
    
    beq a1, t0, exit1
    bne a1, t0, exit2
    addi sp, sp 12    # pop the stack
    jr ra
    exit1:
        addi sp, sp, 12    # re-adjust the stack
        addi a0, zero, 1    # return 1 to a0
        jr ra
    exit2:
        addi a1, a0, 4    # a1 = a0 + 4
        lw a0, 0(a0)    # get the first word
        lw a1, 0(a1)    # get the second word
        jal str_ge 
        
        addi t0, zero, 1    # for comparison to a1(size)
        bne a0, t0, else
        add a0, zero, zero
        lw ra, 0(sp)
        addi sp, sp 12    
        jr ra
    else:
        lw ra,0(sp)        # return the return adress
        lw a0,4(sp)        # return the adress of the array
        lw a1,8(sp)        # return the size address
        addi a1, a1, -1
        addi a0, a0, 4
        jal recCheck
        lw ra, 0(sp)    
        addi sp, sp, 12
        jr ra
