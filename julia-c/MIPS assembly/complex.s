	.file	1 "complex.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	complex_init
	.ent	complex_init
complex_init:
	.frame	$fp,16,$31		# vars= 0, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,16
	.cprestore 0
	sw	$fp,12($sp)
	sw	$28,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$6,24($fp)
	sw	$7,28($fp)
	lw	$2,16($fp)
	l.d	$f0,24($fp)
	s.d	$f0,0($2)
	lw	$2,16($fp)
	l.d	$f0,32($fp)
	s.d	$f0,8($2)
	move	$2,$0
	move	$sp,$fp
	lw	$fp,12($sp)
	addu	$sp,$sp,16
	j	$31
	.end	complex_init
	.size	complex_init, .-complex_init
	.align	2
	.globl	complex_add
	.ent	complex_add
complex_add:
	.frame	$fp,16,$31		# vars= 0, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,16
	.cprestore 0
	sw	$fp,12($sp)
	sw	$28,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	lw	$4,16($fp)
	lw	$2,16($fp)
	lw	$3,20($fp)
	l.d	$f2,0($2)
	l.d	$f0,0($3)
	add.d	$f0,$f2,$f0
	s.d	$f0,0($4)
	lw	$4,16($fp)
	lw	$2,16($fp)
	lw	$3,20($fp)
	l.d	$f2,8($2)
	l.d	$f0,8($3)
	add.d	$f0,$f2,$f0
	s.d	$f0,8($4)
	move	$2,$0
	move	$sp,$fp
	lw	$fp,12($sp)
	addu	$sp,$sp,16
	j	$31
	.end	complex_add
	.size	complex_add, .-complex_add
	.align	2
	.globl	complex_mult
	.ent	complex_mult
complex_mult:
	.frame	$fp,16,$31		# vars= 0, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,16
	.cprestore 0
	sw	$fp,12($sp)
	sw	$28,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	lw	$4,16($fp)
	lw	$2,16($fp)
	lw	$3,20($fp)
	l.d	$f2,0($2)
	l.d	$f0,0($3)
	mul.d	$f4,$f2,$f0
	lw	$2,16($fp)
	lw	$3,20($fp)
	l.d	$f2,8($2)
	l.d	$f0,8($3)
	mul.d	$f0,$f2,$f0
	sub.d	$f0,$f4,$f0
	s.d	$f0,0($4)
	lw	$4,16($fp)
	lw	$2,16($fp)
	lw	$3,20($fp)
	l.d	$f2,0($2)
	l.d	$f0,8($3)
	mul.d	$f4,$f2,$f0
	lw	$2,16($fp)
	lw	$3,20($fp)
	l.d	$f2,8($2)
	l.d	$f0,0($3)
	mul.d	$f0,$f2,$f0
	add.d	$f0,$f4,$f0
	s.d	$f0,8($4)
	move	$2,$0
	move	$sp,$fp
	lw	$fp,12($sp)
	addu	$sp,$sp,16
	j	$31
	.end	complex_mult
	.size	complex_mult, .-complex_mult
	.align	2
	.globl	strtoc
	.ent	strtoc
strtoc:
	.frame	$fp,48,$31		# vars= 8, regs= 4/0, args= 16, extra= 8
	.mask	0xd0010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$31,44($sp)
	sw	$fp,40($sp)
	sw	$28,36($sp)
	sw	$16,32($sp)
	move	$fp,$sp
	sw	$4,48($fp)
	sw	$5,52($fp)
	lw	$16,48($fp)
	lw	$4,52($fp)
	addu	$5,$fp,24
	la	$25,strtod
	jal	$31,$25
	s.d	$f0,0($16)
	lw	$16,48($fp)
	lw	$4,24($fp)
	addu	$5,$fp,24
	la	$25,strtod
	jal	$31,$25
	s.d	$f0,8($16)
	lw	$2,24($fp)
	lb	$3,0($2)
	li	$2,105			# 0x69
	beq	$3,$2,$L21
	li	$2,1			# 0x1
	sw	$2,28($fp)
	b	$L20
$L21:
	sw	$0,28($fp)
$L20:
	lw	$2,28($fp)
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	lw	$16,32($sp)
	addu	$sp,$sp,48
	j	$31
	.end	strtoc
	.size	strtoc, .-strtoc
	.align	2
	.globl	complex_getX
	.ent	complex_getX
complex_getX:
	.frame	$fp,16,$31		# vars= 0, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,16
	.cprestore 0
	sw	$fp,12($sp)
	sw	$28,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	lw	$2,16($fp)
	l.d	$f0,0($2)
	move	$sp,$fp
	lw	$fp,12($sp)
	addu	$sp,$sp,16
	j	$31
	.end	complex_getX
	.size	complex_getX, .-complex_getX
	.align	2
	.globl	complex_getY
	.ent	complex_getY
complex_getY:
	.frame	$fp,16,$31		# vars= 0, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,16
	.cprestore 0
	sw	$fp,12($sp)
	sw	$28,8($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	lw	$2,16($fp)
	l.d	$f0,8($2)
	move	$sp,$fp
	lw	$fp,12($sp)
	addu	$sp,$sp,16
	j	$31
	.end	complex_getY
	.size	complex_getY, .-complex_getY
	.align	2
	.globl	complex_abs
	.ent	complex_abs
complex_abs:
	.frame	$fp,56,$31		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$31,48($sp)
	sw	$fp,44($sp)
	sw	$28,40($sp)
	move	$fp,$sp
	sw	$4,56($fp)
	lw	$2,56($fp)
	lw	$3,56($fp)
	l.d	$f2,0($2)
	l.d	$f0,0($3)
	mul.d	$f0,$f2,$f0
	s.d	$f0,24($fp)
	lw	$2,56($fp)
	lw	$3,56($fp)
	l.d	$f2,8($2)
	l.d	$f0,8($3)
	mul.d	$f0,$f2,$f0
	s.d	$f0,32($fp)
	l.d	$f2,24($fp)
	l.d	$f0,32($fp)
	add.d	$f0,$f2,$f0
	mov.d	$f12,$f0
	la	$25,sqrt
	jal	$31,$25
	move	$sp,$fp
	lw	$31,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$31
	.end	complex_abs
	.size	complex_abs, .-complex_abs
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
