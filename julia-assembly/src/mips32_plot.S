#include <mips/regdef.h>
#include <sys/syscall.h>

#define BUF_SZ 8192

#define STACK_SZ 76+BUF_SZ

#define A0_OFFSET 2128
#define FP_OFFSET BUF_SZ+76
#define GP_OFFSET BUF_SZ+72
#define DATA_OFFSET BUF_SZ+68
#define DATA_LEN_OFFSET BUF_SZ+64
#define BUFF_ADDR_OFFSET BUF_SZ+60
#define BUFF_LEN_OFFSET BUF_SZ+56
#define IP_OFFSET BUF_SZ+52
#define CPI_OFFSET BUF_SZ+48
#define CPR_OFFSET BUF_SZ+44
#define RES_OFFSET BUF_SZ+40
#define C_OFFSET BUF_SZ+36
#define Y_OFFSET BUF_SZ+32
#define X_OFFSET BUF_SZ+28
#define ABS_OFFSET BUF_SZ+24
#define SI_OFFSET BUF_SZ+20
#define SR_OFFSET BUF_SZ+16
#define ZI_OFFSET BUF_SZ+12
#define ZR_OFFSET BUF_SZ+8
#define CI_OFFSET BUF_SZ+4
#define CR_OFFSET BUF_SZ
#define BUFF_INIT 0

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
    .abicalls
    .globl mips32_plot
    .ent mips32_plot


mips32_plot:
    ###############################################################
    # Push stack frame
    subu sp, sp, STACK_SZ	# push stack pointer down
    
    sw $fp, FP_OFFSET(sp)	# store $fp on mem(sp + FP_OFFSET)
    sw gp, GP_OFFSET(sp)	# store gp on mem(sp + GP_OFFSET)
    
    move $fp, sp			# $fp = sp
    
    sw a0, A0_OFFSET($fp)	# store params on mem($fp + A0_OFFSET) 
    
    lw t0, PARAM_CP_RE(a0)	# cpr = params->cp_re on t0
    sw t0, CPR_OFFSET($fp)	# store cpr on mem($fp + CPR_OFFSET)
    lw t0, PARAM_CP_IM(a0)	# cpi = params->cp_im on t2
    sw t0, CPI_OFFSET($fp)	# store cpi on mem($fp + CPI_OFFSET)
    li t0, 0				# t0 = 0
    sw t0, C_OFFSET($fp)	# store c = 0 on mem($fp + C_OFFSET) 
    sw t0, X_OFFSET($fp)	# store x = 0 on mem($fp + X_OFFSET)
    sw t0, Y_OFFSET($fp)	# store y = 0 on mem($fp + Y_OFFSET)
    sw t0, ABSZ_OFFSET($fp)	# store absz = 0 on mem($fp + ABSZ_OFFSET)
    sw t0, SI_OFFSET($fp)	# store si = 0
    sw t0, SR_OFFSET($fp)	# store sr = 0
    sw t0, ZI_OFFSET($fp)	# store zi = 0
    sw t0, ZR_OFFSET($fp)	# store zr = 0
    lw t0, PARAM_UL_IM(a0)	# ci = parms->UL_im on t0
    sw t0, CI_OFFSET($fp)	# store ci on mem($fp + CI_OFFSET)
    lw t0, PARAM_UL_RE(a0)	# cr = parms->UL_re on t0
    sw t0, CR_OFFSET($fp)	# store cr on mem($fp + CR_OFFSET)
    
    li t0, 0
    sw t0, BUFF_LEN_OFFSET($fp)	# store buff_len = 0

    ###############################################################
    
    ###############################################################
    # Store PGM header on buffer, this is "P2\nx_res\ny_res\nshades\n"
    
    addiu t0, $fp, BUFFER_OFFSET	# buff_addr on t0
    lw t1, BUFF_LEN_OFFSET($fp)		# buff_len on t1

title:
    li t2, 0			# i = 0
title_loop:
    li t3, 3
    bge t2, t3, x_res	# if (i >= 3) finish 
    la t3, header
    lb t3, t2(t3)		# header[i]
    sb t3, t1(t0)		# store header[i] on buff_addr[buff_len]
    addiu t1, t1, 1		# buff_len++
    addiu t2, t2, 1		# i++
    j title_loop

x_res:
    lw t2, PARAM_X_RES(a0)	# load parms->x_res on t2
    sw t2, t1(t0)			# store x_res on buff
    addiu t1, t1, 4			# buff_len++

    la t2, line_break		# load line_break addr
    lb t2, 0(t2)			# load line_break
    sb t2, t1(t0)			# store libe_break on buff
    addiu t1, t1, 1			# buff_len++

y_res:
    lw t2, PARAM_Y_RES(a0)
    sw t2, t1(t0)
    addiu t1, t1, 4
   
    la t2, line_break
    lb t2, 0(t2)
    sb t2, t1(t0)
    addiu t1, t1, 1

shades:
    lw t2, PARAM_SHADES(a0)
    sw t2, t1(t0)
    addiu t1, t1, 4

    la t2, line_break
    lb t2, 0(t2)
    sb t2, t1(t0)
    addiu t1, t1, 1

    
    sw t1, BUFF_LEN_OFFSET($fp)
 
    ###############################################################

    ###############################################################
    # Barremos la región rectangular del plano complejo comprendida 
    # entre (parms->UL_re, parms->UL_im) y (parms->LR_re, parms->LR_im).
    # El parámetro de iteración es el punto (cr, ci).

    lw t0, A0_OFFSET($fp)	# parms on t0

    lw t4, Y_OFFSET($fp)	# y on t4
    lw t5, CI_OFFSET($fp)	# ci on t5
UL_im_loop:
    lw t6, PARAM_Y_RES(t0)	# parms->y_res on t6
    bge t4, t6, flush_end	# if (y < parms->y_res) continue

    li t7, 0				# x = 0 on t7
    lw t8, CR_OFFSET($fp)	# cr on t8
UL_re_loop:
    lw t6, PARAM_X_RES(t0)	# parms->x_res on t6
    bge t7, t6, UL_im_icr	# if (x < parms->x_res) continue

    #### Save state in stack
    sw t4, Y_OFFSET($fp)	# store y on mem($fp + Y_OFFSET)
    sw t5, CI_OFFSET($fp)	# store ci on mem($fp + CI_OFFSET)
    sw t7, X_OFFSET($fp)	# store x on mem($fp + X_OFFSET)
    sw t8, CR_OFFSET($fp)	# store cr on mem($fp + CR_OFFSET)
    ####

    move t4, t8				# zr = cr on t4
    move t5, t5				# zi = ci on t5

    ###############################################################
    # Determinamos el nivel de brillo asociado al punto
    # (cr, ci), usando la fórmula compleja recurrente 
    # f = f^3 + c.

    li t9, 0                # c = 0 on t9
shades_loop:
    lw t6, PARAM_SHADES(t0)	# parms->shades on t6
    beq t9, t6, update_buffer	# if (c < parms->shades) continue

    mul t6, t4, t4		    # zr * zr on t6
    mul t7, t5, t5		    # zi * zi on t7

    addu t8, t6, t7		    # absz = zr² + zi² on t8
    addiu t8, t8, -4		# absz - 4 on t8 
    bgtz t8, update_buffer	# if (absz - 4 > 0) write_shade
    
    #### Save zr zi in stack
    sw t4, ZR_OFFSET($fp)
    sw t5, ZI_OFFSET($fp)
    ####
    
    # sr = zr*zr - zi*zi + cpr
    subu t4, t6, t7		    # zr² - zi² on t4
    lw t5, CPR_OFFSET($fp)
    addu t4, t4, t5         # (zr² - zi²) + cpr
    sw t4, SR_OFFSET($fp)	# save sr in stack
    
    #### Restore zr zi
    lw t5, ZI_OFFSET($fp)
    lw t6, ZR_OFFSET($fp)
    ####
    
    # si = 2 * zr * zi + cpi
    mul t7, t5, t6		    # (zr * zi)
    sll t7, t7, 1		    # 2 * (zr * zi) 
    lw t4, CPI_OFFSET($fp)
    addu t7, t7, t4         # (2*zr*zi) + cpi
    sw t7, SI_OFFSET($fp)	# save si in stack

    lw t4, SR_OFFSET($fp)	# zr = sr
    lw t5, SI_OFFSET($fp)	# zi = si

    addi t9, t9, 1          # ++c
    sw t9, C_OFFSET($fp)	# save c in stack
    j shades_loop

    ###############################################################

update_buffer:
    lw t1, BUFF_LEN_OFFSET($fp) # buff_len on t1
    
    # Hay lugar para 5 bytes en el buffer?
    lw t4, BUFF_SZ
    subu t4, t4, t1	# BUF_SZ - buff_len
    li t5, 5
    bge t4, t5, write_buffer # if (BUF_SZ - buff_len >= 5) store
    
write_buffer:
	lw t0, A0_OFFSET($fp)		# parms on t0
    lw t1, $fp, BUFFER_OFFSET	# buff_addr on t1
    lw t2, BUFF_LEN_OFFSET($fp) # buff_len on t2
    
	li v0, SYS_write			# system call for write to file
	lw t0, PARAM_FD(t0)			# file descriptor 
	addiu a1, fp, BUFFER_OFFSET	# address of buffer from which to write
	li a2, BUZ_SZ				# hardcoded buffer length
	syscall						# write to file
	
store_shade:
    lw t1, $fp, BUFFER_OFFSET	# buff_addr on t1
    lw t2, BUFF_LEN_OFFSET($fp) # buff_len on t2
    lw t3, C_OFFSET($fp)		# recover c from stack
    
    sw t3, t2(t1)				# buff_addr[buff_len] = c
    addiu t2, t2, 4				# buff_len += 4
    
    la t3, line_break
    lb t3, t3
    sb t3, t2(t1)				# buff_addr[buff_len] = \n
    addiu t2, t2, 1				# buff_len++
    
    sw t2, BUFF_LEN_OFFSET($fp)	# update buff_len on stack

    #### Restore state
    lw t4, Y_OFFSET($fp)
    lw t5, CI_OFFSET($fp)
    lw t7, X_OFFSET($fp)
    lw t8, CR_OFFSET($fp)
    lw t0, A0_OFFSET($fp)	# parms on t0
    ####

UL_re_icr:
    addi t7, t7, 1 		    # ++x
    lw t6, PARAM_D_RE(t0)	# parms->d_re on t6
    add t8, t8, t6		    # cr += parms->d_re
    j UL_re_loop

UL_im_icr:
    addi t4, t4, 1 		    # ++y
    lw t6, PARAM_D_IM(t0)	# parms->d_im on t6
    subu t5, t5, t6		    # ci -= parms->d_im
    j UL_im_loop

flush_end:
    beqz t2, success
	li v0, SYS_write			# system call for write to file
    lw t0, A0_OFFSET($fp)		# t0 = params
    lw a0, PARAM_FD(a0) 		# file descriptor
    lw a1, BUFF_INIT($fp)	    # address of buffer from which to write
    lw a2, BUFF_LEN_OFFSET($fp)	# buffer length, alt move a2, t1
    syscall				        # write to file
    bltz v0, io_error			# if v0 < 0, io error
    j success

io_error:
    li v0, SYS_write
    li a0, 2
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

    .data
header: 
	.asciiz "P2\n"
line_break:
	.ascii "\n"
error_msg:
	.asciiz "i/o error.\n"
