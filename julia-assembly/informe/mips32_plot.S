#include <mips/regdef.h>
#include <sys/syscall.h>

#define ASCII_0 48

#define BUF_SZ 8192

#define STACK_SZ BUF_SZ+56

#define A0_OFFSET BUF_SZ+56
#define FP_OFFSET BUF_SZ+52
#define GP_OFFSET BUF_SZ+48
#define CPI_OFFSET BUF_SZ+44
#define CPR_OFFSET BUF_SZ+40
#define C_OFFSET BUF_SZ+36
#define Y_OFFSET BUF_SZ+32
#define X_OFFSET BUF_SZ+28
#define SI_OFFSET BUF_SZ+24
#define SR_OFFSET BUF_SZ+20
#define ZI_OFFSET BUF_SZ+16
#define ZR_OFFSET BUF_SZ+12
#define CI_OFFSET BUF_SZ+8
#define CR_OFFSET BUF_SZ+4
#define BUFF_LEN_OFFSET BUF_SZ
#define BUFF_OFFSET 0

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
    
    l.s $f0, PARAM_CP_RE(a0) 
    s.s $f0, CPR_OFFSET($fp)	# store cpr on mem($fp + CPR_OFFSET)
    #lw t0, PARAM_CP_RE(a0)	# cpr = params->cp_re on t0
    #sw t0, CPR_OFFSET($fp)	# store cpr on mem($fp + CPR_OFFSET)
    l.s $f0, PARAM_CP_IM(a0) 
    s.s $f0, CPI_OFFSET($fp)	# store cpr on mem($fp + CPR_OFFSET)
    #lw t0, PARAM_CP_IM(a0)	# cpi = params->cp_im on t2
    #sw t0, CPI_OFFSET($fp)	# store cpi on mem($fp + CPI_OFFSET)
    li t0, 0				# t0 = 0
    sw t0, C_OFFSET($fp)	# store c = 0 on mem($fp + C_OFFSET) 
    sw t0, X_OFFSET($fp)	# store x = 0 on mem($fp + X_OFFSET)
    sw t0, Y_OFFSET($fp)	# store y = 0 on mem($fp + Y_OFFSET)
    sw t0, SI_OFFSET($fp)	# store si = 0
    sw t0, SR_OFFSET($fp)	# store sr = 0
    sw t0, ZI_OFFSET($fp)	# store zi = 0
    sw t0, ZR_OFFSET($fp)	# store zr = 0
    # This change its not really necessary, so it can be reverted
    l.s $f0, PARAM_UL_IM(a0)	# ci = parms->UL_im on t0
    #lw t0, PARAM_UL_IM(a0)	# ci = parms->UL_im on t0
    s.s $f0, CI_OFFSET($fp)	# store ci on mem($fp + CI_OFFSET)
    #sw t0, CI_OFFSET($fp)	# store ci on mem($fp + CI_OFFSET)
    l.s $f0, PARAM_UL_RE(a0)	# cr = parms->UL_re on t0
    #lw t0, PARAM_UL_RE(a0)	# cr = parms->UL_re on t0
    s.s $f0, CR_OFFSET($fp)	# store cr on mem($fp + CR_OFFSET)
    #sw t0, CR_OFFSET($fp)	# store cr on mem($fp + CR_OFFSET)
    
    li t0, 0
    sw t0, BUFF_LEN_OFFSET($fp)	# store buff_len = 0

    ###############################################################
    
    ###############################################################
    # Store PGM header on buffer, this is "P2\nx_res\ny_res\nshades\n"
    
    addiu t0, $fp, BUFF_OFFSET	# buff_addr on t0
    lw t1, BUFF_LEN_OFFSET($fp)		# buff_len on t1

title:
    li t2, 0			# i = 0
title_loop:
    li t3, 3
    bge t2, t3, x_res	# if (i >= 3) finish 
    la t3, header
    addu t3, t3, t2
    lb t3, 0(t3)		# header[i]
    addu t4, t0, t1
    sb t3, 0(t4)		# store header[i] on buff_addr[buff_len]
    addiu t1, t1, 1		# buff_len++
    addiu t2, t2, 1		# i++
    j title_loop

x_res:
    lw t2, PARAM_X_RES(a0)	# load parms->x_res on t2
    move t7, t2             # t7 = t2
    li t3, 10
    li t4, -1               # t4 = x_res_len
x_res_len:
    div t7, t3              # x_res /= 10
    addi t4, t4, 1          # x_res_len++
    bne t7, zero, x_res_len # if not zero, loop
    add t1, t1, t4          # start at the end
loop_x:
    div  t2, t3             # x_res /= 10
    mflo t2
    mfhi t5                 # get remainder
    addi t5, t5, ASCII_0    # convert to ASCII digit
    addu t6, t0, t1         # t6 = buff_addr + buff_len 
    sb   t5, 0(t6)          # store it
    sub t1, t1, 1           # adjust buf ptr 
    bne  t2, zero, loop_x   # if not zero, loop
    add t1, t1, t4          # correct buf ptr so it points the x_res end
    addi t1, t1, 2          # two more so \n doesnt overwrite last char

    la t2, line_break		# load line_break addr
    lb t2, 0(t2)			# load line_break
    addu t3, t0, t1
    sb t2, 0(t3)			# store line_break on buff
    addiu t1, t1, 1			# buff_len++

y_res:
    lw t2, PARAM_Y_RES(a0)
    move t7, t2             # t7 = t2
    li t3, 10
    li t4, -1               # t4 = y_res_len
y_res_len:
    div t7, t3              # y_res /= 10
    addi t4, t4, 1          # y_res_len++
    bne t7, zero, y_res_len # if not zero, loop
    add t1, t1, t4          # start at the end
loop_y:
    div  t2, t3             # y_res /= 10
    mflo t2
    mfhi t5                 # get remainder
    addi t5, t5, ASCII_0    # convert to ASCII digit
    addu t6, t0, t1         # t6 = buff_addr + buff_len 
    sb   t5, 0(t6)          # store it
    sub t1, t1, 1           # adjust buf ptr 
    bne  t2, zero, loop_y   # if not zero, loop
    add t1, t1, t4          # correct buf ptr so it points the x_res end
    addi t1, t1, 2          # two more so \n doesnt overwrite last char

    la t2, line_break		# load line_break addr
    lb t2, 0(t2)			# load line_break
    addu t3, t0, t1
    sb t2, 0(t3)			# store line_break on buff
    addiu t1, t1, 1			# buff_len++

shades:
    lw t2, PARAM_SHADES(a0)
    move t7, t2             # t7 = t2
    li t3, 10
    li t4, -1               # t4 = shds_len
shds_len:
    div t7, t3              # shds /= 10
    addi t4, t4, 1          # shds_len++
    bne t7, zero, shds_len  # if not zero, loop
    add t1, t1, t4          # start at the end
loop_shds:
    div  t2, t3             # shds /= 10
    mflo t2
    mfhi t5                 # get remainder
    addi t5, t5, ASCII_0    # convert to ASCII digit
    addu t6, t0, t1         # t6 = buff_addr + buff_len 
    sb   t5, 0(t6)          # store it
    sub t1, t1, 1           # adjust buf ptr 
    bne t2, zero, loop_shds # if not zero, loop
    add t1, t1, t4          # correct buf ptr so it points the x_res end
    addi t1, t1, 2          # two more so \n doesnt overwrite last char

    la t2, line_break		# load line_break addr
    lb t2, 0(t2)			# load line_break
    addu t3, t0, t1
    sb t2, 0(t3)			# store line_break on buff
    addiu t1, t1, 1			# buff_len++
    

    sw t1, BUFF_LEN_OFFSET($fp)
 
    ###############################################################

    ###############################################################
    # Barremos la región rectangular del plano complejo comprendida 
    # entre (parms->UL_re, parms->UL_im) y (parms->LR_re, parms->LR_im).
    # El parámetro de iteración es el punto (cr, ci).



    li t4, 0			# y = 0 on t4
    sw t4, Y_OFFSET($fp)

    lw t0, A0_OFFSET($fp)	# parms on t0
    l.s $f0, PARAM_UL_IM(t0)	# ci = parms->UL_im
    s.s $f0, CI_OFFSET($fp)

UL_im_loop:
    lw t4, Y_OFFSET($fp)	# y on t4

    lw t0, A0_OFFSET($fp)	# parms on t0
    lw t6, PARAM_Y_RES(t0)	# parms->y_res on t6

    bge t4, t6, flush_end	# if (y < parms->y_res) continue

    li t7, 0			# x = 0 on t7
    sw t7, X_OFFSET($fp)	# store x on mem($fp + X_OFFSET)

    l.s $f0, PARAM_UL_RE(t0)	# cr = parms->UL_re
    s.s $f0, CR_OFFSET($fp)

UL_re_loop:
    lw t7, X_OFFSET($fp)	# x on t7
    
    lw t0, A0_OFFSET($fp)	# parms on t0   
    lw t6, PARAM_X_RES(t0)	# parms->x_res on t6
    bge t7, t6, UL_im_icr	# if (x < parms->x_res) continue


    l.s $f0, CI_OFFSET($fp)	# ci on f0
    mov.s $f2, $f0 		# zi = ci 
    s.s $f2, ZI_OFFSET($fp)

    l.s $f1, CR_OFFSET($fp)	# cr on f1 
    mov.s $f3, $f1		# zr = cr
    s.s $f3, ZR_OFFSET($fp)

    ###############################################################
    # Determinamos el nivel de brillo asociado al punto
    # (cr, ci), usando la fórmula compleja recurrente 
    # f = f^3 + c.

    li t9, 0            	# c = 0 on t9
    sw t9, C_OFFSET($fp)
shades_loop:
    lw t0, A0_OFFSET($fp)	# parms on t0
    lw t6, PARAM_SHADES(t0)	# parms->shades on t6

    lw t9, C_OFFSET($fp)
    beq t9, t6, update_buffer	# if (c < parms->shades) continue

    mul.s $f4, $f2, $f2		# zi * zi 
    mul.s $f5, $f3, $f3		# zr * zr

    add.s $f6, $f4, $f5		# absz =  zr**2 + zi**2
    li.s $f7, -4
    add.s $f6, $f6, $f7		# absz - 4 on t8 
    li.s $f8, 0
    c.le.s $f8, $f6
    bc1t update_buffer
    
    #### Save zr zi in stack
    s.s $f3, ZR_OFFSET($fp)
    s.s $f2, ZI_OFFSET($fp)
    ####
    
    # sr = zr*zr - zi*zi + cpr
    sub.s $f2, $f5, $f4		# zr**2 - zi**2 on t4
    l.s $f3, CPR_OFFSET($fp) 
    add.s $f2, $f2, $f3         # (zr**2 - zi**2) + cpr
    s.s $f2, SR_OFFSET($fp)	# save sr in stack
    
    #### Restore zr zi
    l.s $f3, ZR_OFFSET($fp)
    l.s $f2, ZI_OFFSET($fp)
    ####
    
    # si = 2 * zr * zi + cpi
    mul.s $f4, $f2, $f3		# (zr * zi)
    li.s $f5, 2
    mul.s $f4, $f4, $f5
    l.s $f5, CPI_OFFSET($fp)
    add.s $f4, $f4, $f5         # (2*zr*zi) + cpi
    s.s $f4, SI_OFFSET($fp)	# save si in stack

    l.s $f3, SR_OFFSET($fp)	# zr = sr
    l.s $f2, SI_OFFSET($fp)	# zi = si

    addi t9, t9, 1     		# ++c
    sw t9, C_OFFSET($fp)	# save c in stack
    j shades_loop

    ###############################################################

update_buffer:
    lw t1, BUFF_LEN_OFFSET($fp) # buff_len on t1
    
    # Hay lugar para 2 bytes en el buffer?
    li t4, BUF_SZ
    subu t4, t4, t1				# BUF_SZ - buff_len
    li t5, 4
    bge t4, t5, store_shade		# if (BUF_SZ - buff_len >= 4) KB!! store
    
write_buffer:  
	li v0, SYS_write			# system call for write to file
	lw t0, A0_OFFSET($fp)		# parms on t0
	lw a0, PARAM_FD(t0)			# file descriptor 
	addiu a1, $fp, BUFF_OFFSET	# address of buffer from which to write
	lw a2, BUFF_LEN_OFFSET($fp)	# buffer length
	syscall						# write to file
	bltz v0, io_error			# if v0 < 0, io error

	sw zero, BUFF_LEN_OFFSET($fp)	# reset buffer
	
store_shade:
    addiu t1, $fp, BUFF_OFFSET	# buff_addr on t1
    lw t2, BUFF_LEN_OFFSET($fp) # buff_len on t2
    lw t3, C_OFFSET($fp)		# recover c from stack
    move t4, t3
    li t5, 10
    li t6, -1                   # t6 = shade_len
shade_len:
    div t4, t5                  # shade /= 10
    addi t6, t6, 1              # shade_len++
    bnez t4, shade_len          # if shade != 0, loop
    add t2, t2, t6              # start at the end
loop_shade:
    div t3, t5                  # shade /= 10
    mflo t3
    mfhi t7                     # get remainder
    addi t7, t7, ASCII_0		# ascii conversion
    addu t8, t1, t2             # t8 = buff_addr (t1) + buff_len (t2) 
    sb t7, 0(t8)                # store it
    sub t2, t2, 1               # adjust buf ptr
    bnez t3, loop_shade         # if c != 0, loop 
    add t2, t2, t6              # correct buf ptr so it point at shade end
    addi t2, t2, 2              # two more so \n doesnt overwrite last char
   
    la t3, line_break
    lb t3, 0(t3)
    addu t4, t1, t2
    sb t3, 0(t4)				# buff_addr[buff_len] = \n
    addiu t2, t2, 1				# buff_len++
    
    sw t2, BUFF_LEN_OFFSET($fp)	# update buff_len on stack

UL_re_icr:
    lw t7, X_OFFSET($fp)
    addi t7, t7, 1		# ++x
    sw t7, X_OFFSET($fp)	# store x on mem($fp + X_OFFSET)
    
    l.s $f1, CR_OFFSET($fp)
    l.s $f4, PARAM_D_RE(t0)	# parms->d_re on t6
    add.s $f1, $f1, $f4		# cr += parms->d_re
    s.s $f1, CR_OFFSET($fp)	# store cr on mem($fp + CR_OFFSET)
    j UL_re_loop

UL_im_icr:
    lw t4, Y_OFFSET($fp)
    addi t4, t4, 1 		# ++y
    sw t4, Y_OFFSET($fp)	# store y on mem($fp + Y_OFFSET)
    
    l.s $f4, PARAM_D_IM(t0)	# parms->d_im on t6
    l.s $f0, CI_OFFSET($fp)
    sub.s $f0, $f0, $f4		# ci -= parms->d_im
    s.s $f0, CI_OFFSET($fp)	# store ci on mem($fp + CI_OFFSET)
    j UL_im_loop

flush_end:
	li v0, SYS_write			# system call for write to file
	lw t0, A0_OFFSET($fp)		# parms on t0
	lw a0, PARAM_FD(t0)			# file descriptor 
	addiu a1, $fp, BUFF_OFFSET	# address of buffer from which to write
	lw a2, BUFF_LEN_OFFSET($fp)	# buffer length
	syscall						# write to file
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
