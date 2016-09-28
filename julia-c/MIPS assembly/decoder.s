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
	.ascii	"P2 \000"
	.align	2
$LC2:
	.ascii	"%d %d \000"
	.align	2
$LC3:
	.ascii	"%d\n\000"
	.align	2
$LC4:
	.ascii	"%d \000"
	.align	2
$LC5:
	.ascii	"\n\000"
	.align	3
$LC0:
	.word	0
	.word	1073741824
	.text
	.align	2
	.globl	decoder_decode
	.ent	decoder_decode
decoder_decode:
	.frame	$fp,200,$31		# vars= 136, regs= 3/2, args= 24, extra= 8
	.mask	0xd0000000,-24
	.fmask	0x00f00000,-8
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,200
	.cprestore 24
	sw	$31,176($sp)
	sw	$fp,172($sp)
	sw	$28,168($sp)
	s.d	$f22,192($sp)
	s.d	$f20,184($sp)
	move	$fp,$sp
	sw	$4,200($fp)
	sw	$5,204($fp)
	lw	$2,200($fp)
	l.d	$f2,8($2)
	l.d	$f0,$LC0
	div.d	$f0,$f2,$f0
	s.d	$f0,80($fp)
	lw	$2,200($fp)
	l.d	$f2,16($2)
	l.d	$f0,$LC0
	div.d	$f0,$f2,$f0
	s.d	$f0,88($fp)
	lw	$2,200($fp)
	lw	$4,24($2)
	la	$25,complex_getX
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,80($fp)
	sub.d	$f0,$f2,$f0
	s.d	$f0,32($fp)
	lw	$2,200($fp)
	lw	$4,24($2)
	la	$25,complex_getY
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,88($fp)
	sub.d	$f0,$f2,$f0
	s.d	$f0,40($fp)
	lw	$2,200($fp)
	lw	$4,24($2)
	la	$25,complex_getX
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,80($fp)
	add.d	$f0,$f2,$f0
	s.d	$f0,48($fp)
	lw	$2,200($fp)
	lw	$4,24($2)
	la	$25,complex_getY
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,88($fp)
	add.d	$f0,$f2,$f0
	s.d	$f0,56($fp)
	lw	$3,200($fp)
	lw	$2,200($fp)
	l.s	$f0,0($2)
	cvt.d.w	$f2,$f0
	l.d	$f0,8($3)
	div.d	$f0,$f0,$f2
	s.d	$f0,64($fp)
	lw	$3,200($fp)
	lw	$2,200($fp)
	l.s	$f0,4($2)
	cvt.d.w	$f2,$f0
	l.d	$f0,16($3)
	div.d	$f0,$f0,$f2
	s.d	$f0,72($fp)
	lw	$4,204($fp)
	la	$5,$LC1
	la	$25,fprintf
	jal	$31,$25
	lw	$2,200($fp)
	lw	$3,200($fp)
	lw	$4,204($fp)
	la	$5,$LC2
	lw	$6,0($2)
	lw	$7,4($3)
	la	$25,fprintf
	jal	$31,$25
	lw	$4,204($fp)
	la	$5,$LC3
	li	$6,255			# 0xff
	la	$25,fprintf
	jal	$31,$25
	sw	$0,96($fp)
	l.d	$f0,40($fp)
	s.d	$f0,104($fp)
$L11:
	l.d	$f2,104($fp)
	l.d	$f0,56($fp)
	c.lt.d	$f2,$f0
	bc1t	$L14
	b	$L12
$L14:
	l.d	$f0,32($fp)
	s.d	$f0,112($fp)
$L15:
	l.d	$f2,112($fp)
	l.d	$f0,48($fp)
	c.lt.d	$f2,$f0
	bc1t	$L18
	b	$L13
$L18:
	addu	$2,$fp,120
	l.d	$f0,104($fp)
	s.d	$f0,16($sp)
	move	$4,$2
	lw	$6,112($fp)
	lw	$7,116($fp)
	la	$25,complex_init
	jal	$31,$25
	sw	$0,136($fp)
$L19:
	lw	$2,136($fp)
	slt	$2,$2,254
	beq	$2,$0,$L20
	addu	$2,$fp,120
	move	$4,$2
	la	$25,complex_abs
	jal	$31,$25
	mov.d	$f2,$f0
	l.d	$f0,$LC0
	c.le.d	$f2,$f0
	bc1t	$L22
	b	$L20
$L22:
	addu	$2,$fp,120
	move	$4,$2
	la	$25,complex_getX
	jal	$31,$25
	mov.d	$f20,$f0
	addu	$2,$fp,120
	move	$4,$2
	la	$25,complex_getX
	jal	$31,$25
	mul.d	$f22,$f20,$f0
	addu	$2,$fp,120
	move	$4,$2
	la	$25,complex_getY
	jal	$31,$25
	mov.d	$f20,$f0
	addu	$2,$fp,120
	move	$4,$2
	la	$25,complex_getY
	jal	$31,$25
	mul.d	$f0,$f20,$f0
	sub.d	$f20,$f22,$f0
	lw	$2,200($fp)
	lw	$4,28($2)
	la	$25,complex_getX
	jal	$31,$25
	add.d	$f0,$f20,$f0
	s.d	$f0,144($fp)
	addu	$2,$fp,120
	move	$4,$2
	la	$25,complex_getX
	jal	$31,$25
	add.d	$f20,$f0,$f0
	addu	$2,$fp,120
	move	$4,$2
	la	$25,complex_getY
	jal	$31,$25
	mul.d	$f20,$f20,$f0
	lw	$2,200($fp)
	lw	$4,28($2)
	la	$25,complex_getY
	jal	$31,$25
	add.d	$f0,$f20,$f0
	s.d	$f0,152($fp)
	addu	$2,$fp,120
	l.d	$f0,152($fp)
	s.d	$f0,16($sp)
	move	$4,$2
	lw	$6,144($fp)
	lw	$7,148($fp)
	la	$25,complex_init
	jal	$31,$25
	lw	$2,136($fp)
	addu	$2,$2,1
	sw	$2,136($fp)
	b	$L19
$L20:
	lw	$4,204($fp)
	la	$5,$LC4
	lw	$6,136($fp)
	la	$25,fprintf
	jal	$31,$25
	sw	$2,160($fp)
	lw	$2,160($fp)
	blez	$2,$L24
	lw	$2,96($fp)
	lw	$3,160($fp)
	addu	$2,$2,$3
	sw	$2,96($fp)
	b	$L25
$L24:
	li	$2,9			# 0x9
	sw	$2,164($fp)
	b	$L10
$L25:
	lw	$2,96($fp)
	slt	$2,$2,67
	bne	$2,$0,$L17
	lw	$4,204($fp)
	la	$5,$LC5
	la	$25,fprintf
	jal	$31,$25
	sw	$0,96($fp)
$L17:
	l.d	$f0,112($fp)
	l.d	$f2,64($fp)
	add.d	$f0,$f0,$f2
	s.d	$f0,112($fp)
	b	$L15
$L13:
	l.d	$f0,104($fp)
	l.d	$f2,72($fp)
	add.d	$f0,$f0,$f2
	s.d	$f0,104($fp)
	b	$L11
$L12:
	sw	$0,164($fp)
$L10:
	lw	$2,164($fp)
	move	$sp,$fp
	lw	$31,176($sp)
	lw	$fp,172($sp)
	l.d	$f22,192($sp)
	l.d	$f20,184($sp)
	addu	$sp,$sp,200
	j	$31
	.end	decoder_decode
	.size	decoder_decode, .-decoder_decode
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
