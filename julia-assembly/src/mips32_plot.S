.text
.abicalls
.align 2 #Ni idea si hay que poner esto
.global mips32_plot
.ent mips32_plot

mips32_plot:
    subu sp, sp, 8
    sw $fp, 4(sp)
    sw $gp, 0(sp)
    move $fp, sp
    sw a0, 8($fp)
    
    sw v0, 0(a0) # param->fd en v0






return:
    lw $fp, 4(sp)
    lw $gp, 0(sp)
    addiu sp, sp, 8
    jr ra 

.end
