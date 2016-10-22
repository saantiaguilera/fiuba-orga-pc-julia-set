#include <mips/regdef.h>
#include <sys/syscall.h>

#define BUF_SZ 8192

#define STACK_SZ 72

#define A0_OFFSET 72
#define RA_OFFSET 64
#define FP_OFFSET 60
#define GP_OFFSET 56
#define CPI_OFFSET 48
#define CPR_OFFSET 44
#define RES_OFFSET 40
#define C_OFFSET 36
#define Y_OFFSET 32
#define X_OFFSET 28
#define ABS_OFFSET 24
#define SI_OFFSET 20
#define SR_OFFSET 16
#define ZI_OFFSET 12
#define ZR_OFFSET 8
#define CI_OFFSET 4
#define CR_OFFSET 0

#define PARAM_UL_RE 0
#define PARAM_UL_IM 4
#define PARAM_LR_RE 8
#define PARAM_LR_IM 12
#define PARAM_D_RE 16
#define PARAM_D_IM 20
#define PARAM_CP_RE 24
#define PARAM_CP_IM 28
#define PARAM_X_RES 32
#define PARAM_Y_RES 36
#define PARAM_SHADES 40
#define PARAM_FD 44

    .text

.macro empty_buffer
    lw t1, buffer_ini # TODO esta chequeado ese label en el lw??
.end_macro

# Buffer stored in t1 / Buffer length in t2
.macro write_file (%fd)
    li v0, SYS_write	# system call for write to file
    move a0, %fd 		# file descriptor
    la a1, t1			# address of buffer from which to write
    li a2, t2			# buffer length
    syscall			# write to file
    bltz v0, io_error		# if v0 < 0, io error
.end_macro

# Going to need a register to store the buff location
.macro write_buffer (%data, %len)
    blt t2, BUF_SZ, not_flush_buffer
    write_file t3
	empty_buffer
    not_flush_buffer: sw %data, 0(t1)
    li t1, %len
    addi t2, t2, %len
.end_macro

    .abicalls
    .align 2
    .globl mips32_plot
    .ent mips32_plot


mips32_plot:
    ###############################################################
    # Push stack frame
    subu sp, sp, STACK_SZ	# push stack pointer down
    sw $fp, FP_OFFSET(sp)	# store $fp on mem(sp + FP_OFFSET)
    sw gp, GP_OFFSET(sp)	# store gp on mem(sp + GP_OFFSET)
    move $fp, sp		# $fp = sp
    sw a0, A0_OFFSET($fp)	# store params on mem($fp + A0_OFFSET) (callee's stack frame)
    ###############################################################

    move t0, a0		# params on t0

    lw t1, PARAM_CP_RE(t0)	# cpr = params->cp_re on t1
    sw t1, CPR_OFFSET($fp)	# store cpr on mem($fp + CPR_OFFSET)
    lw t2, PARAM_CP_IM(t0)	# cpi = params->cp_im on t2
    sw t2, CPI_OFFSET($fp)	# store cpi on mem($fp + CPI_OFFSET)

    #### Hace falta abrir el fd? ####

    lw t3, PARAM_FD(t0)	# params->fd on t3
    
    #### Inicializamos el buffer ####

    empty_buffer

    ###############################################################
    # Write PGM header, this is "P2\nx_res\ny_res\nshades\n"

    lw t4, (header)
    write_buffer t4 3

    lw t4, PARAM_X_RES(t0)
    write_buffer t4, 8
    lw t4, line_break
    write_buffer t4, 1
    
    lw t4, PARAM_Y_RES(t0)
    write_buffer t4, 8
    lw t4, line_break
    write_buffer t4, 1
	
    lw t4, PARAM_SHADES(t0)
    write_buffer t4, 8
    lw t4, line_break
    write_buffer t4, 1

    ###############################################################

    ###############################################################
    # Barremos la región rectangular del plano complejo comprendida 
    # entre (parms->UL_re, parms->UL_im) y (parms->LR_re, parms->LR_im).
    # El parámetro de iteración es el punto (cr, ci).

    li t4, 0			# y = 0 on t4
    lw t5, PARAM_UL_IM(t0)	# ci = parms->UL_im on t5
UL_im_loop:
    lw t6, PARAM_Y_RES(t0)	# parms->y_res on t6
    beq t4, t6, fflush	# if (y < parms->y_res) continue

    li t7, 0			# x = 0 on t7
    lw t8, PARAM_UL_RE(t0)	# cr = parms->UL_re on t8
UL_re_loop:
    lw t6, PARAM_X_RES(t0)	# parms->x_res on t6
    beq t7, t6, UL_im_icr	# if (x < parms->x_res) continue

    #### Save state in stack
    sw t4, Y_OFFSET($fp)	# store y on mem($fp + Y_OFFSET)
    sw t5, CI_OFFSET($fp)	# store ci on mem($fp + CI_OFFSET)
    sw t7, X_OFFSET($fp)	# store x on mem($fp + X_OFFSET)
    sw t8, CR_OFFSET($fp)	# store cr on mem($fp)
    ####

    move t4, t8		# zr = cr on t4
    move t5, t5		# zi = ci on t5

    ###############################################################
    # Determinamos el nivel de brillo asociado al punto
    # (cr, ci), usando la fórmula compleja recurrente 
    # f = f^3 + c.

    li t9, 0			# c = 0 on t9
shades_loop:
    lw t6, PARAM_SHADES(t0)	# parms->shades on t6
    beq t9, t6, write_shade	# if (c < parms->shades) continue

    mul t6, t4, t4		# zr * zr on t6
    mul t7, t5, t5		# zi * zi on t7

    addu t8, t6, t7		# absz = zr² + zi² on t8
    addiu t8, t8, -4		# absz - 4 on t8 
    bgtz t8, write_shade	# if (absz - 4 > 0) write_shade
    
    #### TODO
    # sr = zr*zr - zi*zi + cpr
    # si = 2 * zr * zi + cpi
    sw t4, ZR_OFFSET($fp)
    sw t5, ZI_OFFSET($fp)
    subu t4, t6, t7		# zr**2 - zi**2 in t4 (sr)
    lw t5, CPR_OFFSET($fp)
    addu t4, t4, t5      # (zr*zr-zi*zi) + cpr
    lw t5, ZI_OFFSET($fp)
    lw t6, ZR_OFFSET($fp)
    mul t7, t5, t6		# (zr * zi)
    add t7, t7, t7		# 2 * (zr*zi) 
    lw t4, CPI_OFFSET($fp)
    addu t7, t7, t4      # (2*zr*zi) + cpi 

    # Se puede obviar si las operaciones finales se hacen sobre t4 y t5
    # respectivamente
    move t4, t4		# zr = sr
    move t5, t7		# zi = si
    ####

    addi t9, t9, 1		# ++c
    j shades_loop

    ###############################################################

write_shade:
    # Shades are being calculated in t9. So we have to write the t9 color value
    # Appending in buffer color\n
    write_buffer t9, 4
    lw t6, line_break
    write_buffer t6, 1

    #### Restore state
    lw t4, Y_OFFSET($fp)
    lw t5, CI_OFFSET($fp)
    lw t7, X_OFFSET($fp)
    lw t8, CR_OFFSET($fp)
    ####

UL_re_icr:
    addi t7, t7, 1 		# ++x
    lw t6, PARAM_D_RE(t0)	# parms->d_re on t6
    add t8, t8, t6		# cr += parms->d_re
    j UL_re_loop

UL_im_icr:
    addi t4, t4, 1 		# ++y
    lw t6, PARAM_D_IM(t0)	# parms->d_im on t6
    subu t5, t5, t6		# ci -= parms->d_im
    j UL_im_loop

fflush:
    bgt t2, 0, flush_buffer
    j success

io_error:
    li v0, SYS_write
    li a0, 2 #TODO stderr tiene fd 2 ????
    la a1, error_msg
    li a2, 11
    syscall

    li v0, -1			# return value -1
    j return

success:
    li v0, 0			# return value 0

return:
    ###############################################################
    # Pop stack frame
    move sp, $fp
    lw $fp, FP_OFFSET(sp)	# loads mem(sp + FP_OFFSET) on $fp
    lw gp, GP_OFFSET(sp)	# loads mem(sp + GP_OFFSET) on gp
    addiu sp, sp, STACK_SZ	# pop stack pointer up
    ###############################################################

    jr ra
    
	.end mips32_plot

	.rdata
    .align 2
header: 
	.asciiz "P2\n"
line_break:
	.ascii "\n"
error_msg:
	.asciiz "i/o error.\n"

buffer_ini:
    .space BUF_SZ
