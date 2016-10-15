#include <mips/regdef.h>

	.text
	.abicalls
	.global mips32_plot
	.ent mips32_plot

mips32_plot:
    ###############################################################
    # Push stack frame
    subu $sp, $sp, 64	# push stack pointer down
    sw $fp, 60($sp)		# store $fp on mem($sp + 60)
    sw $gp, 56($sp)		# store $gp on mem($sp + 56)
    move $fp, $sp		# $fp = $sp
    sw $a0, 64($fp)		# store $a0 on mem($fp + 64)
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
    lw $fp, 60($sp)		# loads mem($sp + 60) on $fp
    lw $gp, 56($sp)		# loads mem($sp + 56) on $gp
    addiu $sp, $sp, 64	# pop stack pointer up
    ###############################################################

    jr $ra # return

.end
