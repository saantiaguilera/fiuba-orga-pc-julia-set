	.file	1 "decoder.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.text
	.align	2
	.globl	decoder_init
	.ent	decoder_init
decoder_init:
	.frame	$fp,24,$31		# vars= 8, regs= 2/0, args= 0, extra= 8
	.mask	0x50000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,24
	.cprestore 0
	sw	$fp,20($sp)
	sw	$28,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	sw	$6,32($fp)
	lw	$2,24($fp)
	beq	$2,$0,$L7
	lw	$2,56($fp)
	beq	$2,$0,$L7
	lw	$2,60($fp)
	bne	$2,$0,$L6
$L7:
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,8($fp)
	b	$L5
$L6:
	lw	$2,28($fp)
	beq	$2,$0,$L9
	lw	$2,32($fp)
	bne	$2,$0,$L8
$L9:
	li	$2,-1			# 0xffffffffffffffff
	sw	$2,8($fp)
	b	$L5
$L8:
	lw	$3,24($fp)
	lw	$2,28($fp)
	sw	$2,0($3)
	lw	$3,24($fp)
	lw	$2,32($fp)
	sw	$2,4($3)
	lw	$2,24($fp)
	l.d	$f0,40($fp)
	s.d	$f0,8($2)
	lw	$2,24($fp)
	l.d	$f0,48($fp)
	s.d	$f0,16($2)
	lw	$3,24($fp)
	lw	$2,56($fp)
	sw	$2,24($3)
	lw	$3,24($fp)
	lw	$2,60($fp)
	sw	$2,28($3)
	sw	$0,8($fp)
$L5:
	lw	$2,8($fp)
	move	$sp,$fp
	lw	$fp,20($sp)
	addu	$sp,$sp,24
	j	$31
	.end	decoder_init
	.size	decoder_init, .-decoder_init
	.rdata
	.align	2
$LC1:
	.ascii	"P5 \000"
	.align	2
$LC2:
	.ascii	"%d %d \000"
	.align	2
$LC3:
	.ascii	"%d\n\000"
	.align	3
$LC0:
	.word	0
	.word	1073741824
	.text
	.align	2
	.globl	decoder_decode
	.ent	decoder_decode
decoder_decode:
	.frame	$fp,184,$31		# vars= 120, regs= 3/2, args= 24, extra= 8
	.mask	0xd0000000,-24
	.fmask	0x00f00000,-8
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,184
	.cprestore 24
	sw	$31,160($sp)
	sw	$fp,156($sp)
	sw	$28,152($sp)
	s.d	$f22,176($sp)
	s.d	$f20,168($sp)
	move	$fp,$sp
	sw	$4,184($fp)
	sw	$5,188($fp)
	lw	$2,184($fp)
	l.d	$f2,8($2)
	l.d	$f0,$LC0
	div.d	$f0,$f2,$f0
	s.d	$f0,80($fp)
	lw	$2,184($fp)
	l.d	$f2,16($2)
	l.d	$f0,$LC0
	div.d	$f0,$f2,$f0
	s.d	$f0,88($fp)
	lw	$2,184($fp)
	lw	$4,24($2)
	la	$25,complex_getX
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,80($fp)
	sub.d	$f0,$f2,$f0
	s.d	$f0,32($fp)
	lw	$2,184($fp)
	lw	$4,24($2)
	la	$25,complex_getY
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,88($fp)
	sub.d	$f0,$f2,$f0
	s.d	$f0,40($fp)
	lw	$2,184($fp)
	lw	$4,24($2)
	la	$25,complex_getX
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,80($fp)
	add.d	$f0,$f2,$f0
	s.d	$f0,48($fp)
	lw	$2,184($fp)
	lw	$4,24($2)
	la	$25,complex_getY
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,88($fp)
	add.d	$f0,$f2,$f0
	s.d	$f0,56($fp)
	lw	$3,184($fp)
	lw	$2,184($fp)
	l.s	$f0,0($2)
	cvt.d.w	$f2,$f0
	l.d	$f0,8($3)
	div.d	$f0,$f0,$f2
	s.d	$f0,64($fp)
	lw	$3,184($fp)
	lw	$2,184($fp)
	l.s	$f0,4($2)
	cvt.d.w	$f2,$f0
	l.d	$f0,16($3)
	div.d	$f0,$f0,$f2
	s.d	$f0,72($fp)
	lw	$4,188($fp)
	la	$5,$LC1
	la	$25,fprintf
	jal	$31,$25
	lw	$2,184($fp)
	lw	$3,184($fp)
	lw	$4,188($fp)
	la	$5,$LC2
	lw	$6,0($2)
	lw	$7,4($3)
	la	$25,fprintf
	jal	$31,$25
	lw	$4,188($fp)
	la	$5,$LC3
	li	$6,255			# 0xff
	la	$25,fprintf
	jal	$31,$25
	l.d	$f0,40($fp)
	s.d	$f0,96($fp)
$L11:
	l.d	$f2,96($fp)
	l.d	$f0,56($fp)
	c.lt.d	$f2,$f0
	bc1t	$L14
	b	$L12
$L14:
	l.d	$f0,32($fp)
	s.d	$f0,104($fp)
$L15:
	l.d	$f2,104($fp)
	l.d	$f0,48($fp)
	c.lt.d	$f2,$f0
	bc1t	$L18
	b	$L13
$L18:
	addu	$2,$fp,112
	l.d	$f0,96($fp)
	s.d	$f0,16($sp)
	move	$4,$2
	lw	$6,104($fp)
	lw	$7,108($fp)
	la	$25,complex_init
	jal	$31,$25
	sw	$0,128($fp)
$L19:
	lw	$2,128($fp)
	slt	$2,$2,254
	beq	$2,$0,$L20
	addu	$2,$fp,112
	move	$4,$2
	la	$25,complex_abs
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,$LC0
	c.le.d	$f2,$f0
	bc1t	$L22
	b	$L20
$L22:
	addu	$2,$fp,112
	move	$4,$2
	la	$25,complex_getX
	jal	$31,$25
	mov.d	$f20,$f0
	addu	$2,$fp,112
	move	$4,$2
	la	$25,complex_getX
	jal	$31,$25
	mul.d	$f22,$f20,$f0
	addu	$2,$fp,112
	move	$4,$2
	la	$25,complex_getY
	jal	$31,$25
	mov.d	$f20,$f0
	addu	$2,$fp,112
	move	$4,$2
	la	$25,complex_getY
	jal	$31,$25
	mul.d	$f0,$f20,$f0
	sub.d	$f20,$f22,$f0
	lw	$2,184($fp)
	lw	$4,28($2)
	la	$25,complex_getX
	jal	$31,$25
	add.d	$f0,$f20,$f0
	s.d	$f0,136($fp)
	addu	$2,$fp,112
	move	$4,$2
	la	$25,complex_getX
	jal	$31,$25
	add.d	$f20,$f0,$f0
	addu	$2,$fp,112
	move	$4,$2
	la	$25,complex_getY
	jal	$31,$25
	mul.d	$f20,$f20,$f0
	lw	$2,184($fp)
	lw	$4,28($2)
	la	$25,complex_getY
	jal	$31,$25
	add.d	$f0,$f20,$f0
	s.d	$f0,144($fp)
	addu	$2,$fp,112
	l.d	$f0,144($fp)
	s.d	$f0,16($sp)
	move	$4,$2
	lw	$6,136($fp)
	lw	$7,140($fp)
	la	$25,complex_init
	jal	$31,$25
	lw	$2,128($fp)
	addu	$2,$2,1
	sw	$2,128($fp)
	b	$L19
$L20:
	addu	$2,$fp,128
	move	$4,$2
	li	$5,1			# 0x1
	li	$6,1			# 0x1
	lw	$7,188($fp)
	la	$25,fwrite
	jal	$31,$25
	l.d	$f2,104($fp)
	l.d	$f0,64($fp)
	add.d	$f0,$f2,$f0
	s.d	$f0,104($fp)
	b	$L15
$L13:
	l.d	$f0,96($fp)
	l.d	$f2,72($fp)
	add.d	$f0,$f0,$f2
	s.d	$f0,96($fp)
	b	$L11
$L12:
	move	$2,$0
	move	$sp,$fp
	lw	$31,160($sp)
	lw	$fp,156($sp)
	l.d	$f22,176($sp)
	l.d	$f20,168($sp)
	addu	$sp,$sp,184
	j	$31
	.end	decoder_decode
	.size	decoder_decode, .-decoder_decode
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
