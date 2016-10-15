#include <mips/regdef.h>
#include <sys/syscall.h>

#ifndef BUF_SZ
#define BUF_SZ 8192
#endif

	.data
header: 
	.asciiz "P2\n"
line_break:
	.ascii "\n"

	.text
	.abicalls
	.global mips32_plot
	.ent mips32_plot

mips32_plot:

    ###############################################################
    # Push stack frame
    subu $sp, $sp, 64	# push stack pointer down
    sw $fp, 60($sp)	# store fp on mem(sp + 60)
    sw $gp, 56($sp)	# store gp on mem(sp + 56)
    move $fp, $sp	# fp = sp
    sw $a0, 64($fp)	# store params on mem(fp + 64) (callee's stack frame)
    ###############################################################

    move $t0, $a0	# params on t0

    lw $t1, 24($t0)	# cpr = params->cp_re on t1
    sw $t1, 44($fp)	# store cpr on mem(sp + 44)
    lw $t2, 28($t0)	# cpi = params->cp_im on t2
    sw $t2, 48($fp)	# store cpi on mem(sp + 48)

    #### Hace falta abrir el fd? ####

    lw $t3, 44($t0)	# params->fd on t3

    ###############################################################
    # Write PGM header

    # Write "P2\n"
    li $v0, 15		# system call for write to file
    move $a0, $t3	# file descriptor
    la $a1, header	# address of buffer from which to write
    li $a2, 3		# buffer length
    syscall		# write to file
    bltz $v0, io_error	# if v0 < 0, io error

    # Write params->x_res
    li $v0, 15		# system call for write to file
    move $a0, $t3	# file descriptor
    la $a1, 32($t0)	# address of buffer from which to write
    li $a2, 8		# buffer length
    syscall		# write to file
    bltz $v0, io_error	# if v0 < 0, io error

    # Write "\n"
    li $v0, 15		# system call for write to file
    move $a0, $t3	# file descriptor
    la $a1, line_break	# address of buffer from which to write
    li $a2, 1		# buffer length
    syscall		# write to file
    bltz $v0, io_error	# if v0 < 0, io error

    # Write params->y_res
    li $v0, 15		# system call for write to file
    move $a0, $t3	# file descriptor
    la $a1, 36($t0)	# address of buffer from which to write
    li $a2, 8		# buffer length
    syscall		# write to file
    bltz $v0, io_error	# if v0 < 0, io error

    # Write "\n"
    li $v0, 15		# system call for write to file
    move $a0, $t3	# file descriptor
    la $a1, line_break	# address of buffer from which to write
    li $a2, 1		# buffer length
    syscall		# write to file
    bltz $v0, io_error	# if v0 < 0, io error

    # Write params->shades
    li $v0, 15		# system call for write to file
    move $a0, $t3	# file descriptor
    la $a1, 40($t0)	# address of buffer from which to write
    li $a2, 8		# buffer length
    syscall		# write to file
    bltz $v0, io_error	# if v0 < 0, io error

    # Write "\n"
    li $v0, 15		# system call for write to file
    move $a0, $t3	# file descriptor
    la $a1, line_break	# address of buffer from which to write
    li $a2, 1		# buffer length
    syscall		# write to file
    bltz $v0, io_error	# if v0 < 0, io error

    ###############################################################

    ###############################################################
    # Barremos la región rectangular del plano complejo comprendida 
    # entre (parms->UL_re, parms->UL_im) y (parms->LR_re, parms->LR_im).
    # El parámetro de iteración es el punto (cr, ci).

    li $t4, 0			# y = 0 on t4
    lw $t5, 4($t0)		# ci = parms->UL_im on t5
UL_im_loop:
    lw $t6, 36($t0)		# parms->y_res on t6
    beq $t4, $t6, flush		# if (y < parms->y_res) continue

    li $t7, 0			# x = 0 on t7
    lw $t8, 0($t0)		# cr = parms->UL_re on t8
UL_re_loop:
    lw $t6, 32($t0)		# parms->x_res on t6
    beq $t7, $t6, UL_im_icr	# if (x < parms->x_res) continue

    move $t1, $t8		# zr = cr on t1
    move $t2, $t5		# zi = ci on t2

    ###############################################################
    # Determinamos el nivel de brillo asociado al punto
    # (cr, ci), usando la fórmula compleja recurrente 
    # f = f^3 + c.

    li $t9, 0			# c = 0 on t9
shades_loop:
    lw $t6, 40($t0)		# parms->shades on t6
    beq $t9, $t6, write		# if (c < parms->shades) continue

    #TODO shades loop content

    addi $t9, $t9, 1		# ++c
    j shades_loop

    ###############################################################

write:
    #TODO

UL_re_icr:
    addi $t7, $t7, 1 		# ++x
    lw $t6, 16($t0)		# parms->d_re on t6
    add $t8, $t8, $t6		# cr += parms->d_re
    j UL_re_loop

UL_im_icr:
    addi $t4, $t4, 1 		# ++y
    lw $t6, 20($t0)		# parms->d_im on t6
    subu $t5, $t5, $t6		# ci -= parms->d_im
    j UL_im_loop

    ###############################################################

flush:
    #TODO
    j success

io_error:

    ###############################################################
    # Write "i/o error.\n" on stderr
    li $v0, 15		# system call for write to file
    li $a0, 2		# file descriptor
    la $a1, error_msg	# address of buffer from which to write
    li $a2, 11		# buffer length
    syscall		# write to file
    ###############################################################

    li $v0, 1	# return value 1
    j return

success:
    li $v0, 0	# return value 0

return:

    ###############################################################
    # Pop stack frame
    lw $fp, 60($sp)	# loads mem(sp + 60) on fp
    lw $gp, 56($sp)	# loads mem(sp + 56) on gp
    addiu $sp, $sp, 64	# pop stack pointer up
    ###############################################################

    jr $ra

.end
