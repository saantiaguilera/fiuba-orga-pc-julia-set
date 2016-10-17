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
error_msg:
	.asciiz "i/o error.\n"
buffer_ini:
    .space BUF_SZ

    .text
    .abicalls
    .global mips32_plot
    .ent mips32_plot

.macro write_file
    li $v0, 15		# system call for write to file
    move $a0, $t2 		# file descriptor
    la $a1, $t0		# address of buffer from which to write
    li $a2, $t1	# buffer length
    syscall			# write to file
    bltz $v0, io_error	# if v0 < 0, io error
    empty_buffer
.end_macro

# Going to need a register to store the buff location
# $t1 using the buffer length
.macro write_buffer (%data, %len)
    bgt $t1, BUF_SZ, flush_buffer # Store sp location in stack or somewhere so write can jump back
    sw $data, ($t0) # CHANGE INTO PROPER REG
    addi $t0, 0, $len
    addi $t1, $t1, $len
.end_macro

.macro empty_buffer
    lw $t0, buffer_ini # CHANGE INTO PROPER REG
.end_macro

flush_buffer:
    write_file
    # j line 37

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
    sw $t1, 44($fp)	# store cpr on mem(fp + 44)
    lw $t2, 28($t0)	# cpi = params->cp_im on t2
    sw $t2, 48($fp)	# store cpi on mem(fp + 48)

    #### Hace falta abrir el fd? ####

    lw $t3, 44($t0)	# params->fd on t3

    ###############################################################
    # Write PGM header, this is "P2\nx_res\ny_res\nshades\n"

    lw $t4, (header)
    write_buffer $t4 3

    lw $t4, 32($t0)
    write_buffer $t4, 8
	lw $t4, line_break
	write_buffer $t4, 1
    
	lw $t4, 36($t0)
    write_buffer $t4, 8
    lw $t4, line_break
	write_buffer $t4, 1
	
	lw $t4, 40($t0)
    write_buffer $t4, 8
	lw $t4, line_break
	write_buffer $t4, 1

	###############################################################

    ###############################################################
    # Barremos la región rectangular del plano complejo comprendida 
    # entre (parms->UL_re, parms->UL_im) y (parms->LR_re, parms->LR_im).
    # El parámetro de iteración es el punto (cr, ci).

    li $t4, 0			# y = 0 on t4
    lw $t5, 4($t0)		# ci = parms->UL_im on t5
UL_im_loop:
    lw $t6, 36($t0)		    # parms->y_res on t6
    beq $t4, $t6, fflush	# if (y < parms->y_res) continue

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
    la $t8, 40($t0) # CHANGE INTO PROPER REG
    li $t9, 36($fp)# CHANGE INTO PROPER REG
    write_file $f3, $t8, $t9# CHANGE INTO PROPER REG
    lb $t8, line_break# CHANGE INTO PROPER REG
    write_file $f3, $t8, 1# CHANGE INTO PROPER REG

    ###############################################################
    # Write "c\n"

    sw $t9, 36($fp)	# store c on mem(fp + 36)

    # Write c
    li $v0, 15		# system call for write to file
    move $a0, $t3	# file descriptor
    la $a1, 40($t0)	# address of buffer from which to write
    li $a2, 36($fp)	# buffer length
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

fflush:
    #TODO it flushes remaining data into file, but if thats the case it results
    # in an error    
    bgt $t1, 0, write_file 
    j success

fflush_error:
    writem $t3, buffer_ini, $t0 # fd, buffer_ini, used size of buff
    j io_error


io_error:

    write_file 2, error_msg, 11
    ###############################################################
    # Write "i/o error.\n" on stderr
    li $v0, 15		# system call for write to file
    li $a0, 2		# file descriptor
    la $a1, error_msg	# address of buffer from which to write
    li $a2, 11		# buffer length
    syscall		# write to file
    ###############################################################

    li $v0, -1	# return value -1
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
