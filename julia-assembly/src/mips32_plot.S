.text
.abicalls
.align 2 #Ni idea si hay que poner esto
.global mips32_plot
.ent mips32_plot

mips32_plot:
    ###############################################################
    # Push stack frame
    subu sp, sp, 8
    sw $fp, 4(sp)
    sw $gp, 0(sp)
    move $fp, sp
    sw a0, 8($fp)
    ###############################################################



write:
    ###############################################################
    # Write to file just opened
    li   $v0, 15       # system call for write to file
    move $a0, $s6      # file descriptor 
    la   $a1, buffer   # address of buffer from which to write
    li   $a2, 44       # hardcoded buffer length
    syscall            # write to file
    ###############################################################

return:
    ###############################################################
    # Pop stack frame
    lw $fp, 4(sp)
    lw $gp, 0(sp)
    addiu sp, sp, 8
    ###############################################################

    jr $ra # return

.end
