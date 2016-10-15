#include <mips/regdef.h>
#include <sys/syscall.h>

#ifndef BUF_SZ
#define BUF_SZ 8192
#endif

	.text
	.abicalls
	.global mips32_plot
	.ent mips32_plot

mips32_plot:

    ###############################################################
    # Push stack frame
    subu $sp, $sp, 64	# push stack pointer down
    sw $fp, 60($sp)		# store fp on mem(sp + 60)
    sw $gp, 56($sp)		# store gp on mem(sp + 56)
    move $fp, $sp		# fp = sp
    sw $a0, 64($fp)		# store params on mem(fp + 64) (callee's stack frame)
    ###############################################################

	move $t0, $a0	# params on t0

	lw $t1, 24($t0)	# cpr = params->cp_re on t1
	lw $t2, 28($t0) # cpi = params->cp_im on t2
	
	#### Hace falta abrir el fd? ####
	
	lw $t3, 56($t0) # params->fd on t3
	
	###############################################################
    # Write PGM header
    li   $v0, 15		# system call for write to file
    move $a0, $t3		# file descriptor
    la   $a1, 	# address of buffer from which to write
    li   $a2, 	# hardcoded buffer length
    syscall				# write to file
    ###############################################################

	#### todo ####

return:

    ###############################################################
    # Pop stack frame
    lw $fp, 60($sp)		# loads mem(sp + 60) on fp
    lw $gp, 56($sp)		# loads mem(sp + 56) on gp
    addiu $sp, $sp, 64	# pop stack pointer up
    ###############################################################

    jr $ra # return

.end
