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

    .align 2 # We will be storing words in the buffer, and .text should have it too.
buffer_ini:
    .space BUF_SZ

    .text
    .abicalls
    .global mips32_plot
    .ent mips32_plot

.macro push (%arg)
    addi $sp, $sp, -4
    sw %arg, 0($sp)
.end_macro

.macro pop (%reg) # %reg its a register that will hold the popped value
    lw %reg, 0($sp)
    addi $sp, $sp, 4
.end_macro

# Buffer stored in t1 / Buffer length in t2
.macro write_file (%fd)
    li $v0, 15		# system call for write to file
    move $a0, %fd 	# file descriptor
    la $a1, $t1		# address of buffer from which to write
    li $a2, $t2		# buffer length
    syscall		# write to file
    bltz $v0, io_error	# if v0 < 0, io error
.end_macro

# Going to need a register to store the buff location
.macro write_buffer (%data, %len)
    blt $t2, BUF_SZ, not_flush_buffer
    write_file $t3
	empty_buffer
    not_flush_buffer: sw %data, 0($t1)
    li $t1, %len
    addi $t2, $t2, %len
.end_macro

.macro empty_buffer
    lw $t1, buffer_ini # TODO esta chequeado ese label en el lw??
.end_macro

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
    
    #### Inicializamos el buffer ####

    empty_buffer

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
    lw $t6, 36($t0)		# parms->y_res on t6
    beq $t4, $t6, fflush	# if (y < parms->y_res) continue

    li $t7, 0			# x = 0 on t7
    lw $t8, 0($t0)		# cr = parms->UL_re on t8
UL_re_loop:
    lw $t6, 32($t0)		# parms->x_res on t6
    beq $t7, $t6, UL_im_icr	# if (x < parms->x_res) continue

    #### Save state in stack
    sw $t4, 32($fp)		# store y on mem(fp + 32)
    sw $t5, 4($fp)		# store ci on mem(fp + 4)
    sw $t7, 28($fp)		# store x on mem(fp + 28)
    sw $t8, 0($fp)		# store cr on mem(fp)
    ####

    move $t4, $t8		# zr = cr on t4
    move $t5, $t5		# zi = ci on t5

    ###############################################################
    # Determinamos el nivel de brillo asociado al punto
    # (cr, ci), usando la fórmula compleja recurrente 
    # f = f^3 + c.

    li $t9, 0			# c = 0 on t9
shades_loop:
    lw $t6, 40($t0)		# parms->shades on t6
    beq $t9, $t6, write_shade	# if (c < parms->shades) continue

    mul $t6, $t4, $t4		# zr * zr on t6
    mul $t7, $t5, $t5		# zi * zi on t7

    addu $t8, $t6, $t7		# absz = zr² + i² on 8
    addiu $t8, $t8, -4		# absz - 4 on t8 
    bgtz $t8, write_shade	# if (absz - 4 > 0) write_shade
    
    #### TODO
    # sr = zr*zr - zi*zi + cpr
    # si = 2 * zr * zi + cpi
    addu $t8 

    move $t4, 			# zr = sr
    move $t5,			# zi = si
    ####

    addi $t9, $t9, 1		# ++c
    j shades_loop

    ###############################################################

write_shade:
    # Shades are being calculated in t9. So we have to write the t9 color value
    # Appending in buffer color\n
    write_buffer $t9, 4
    lw $t6, line_break
    write_buffer $t6, 1

    #### Restore state
    lw $t4, 32($fp)
    lw $t5, 4($fp)
    lw $t7, 28($fp)
    lw $t8, 0($fp)
    ####

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

fflush:
    bgt $t2, 0, flush_buffer
    j success

io_error:
    li $v0, 15
    move $a0, 2
    la $a1, error_msg
    li $a2, 11
    syscall

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
