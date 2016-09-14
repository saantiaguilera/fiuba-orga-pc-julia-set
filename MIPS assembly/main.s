	.file	1 "main.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
	.ascii	"v%s\n\000"
	.align	2
$LC1:
	.ascii	"1.0.0\000"
	.text
	.align	2
	.globl	show_version
	.ent	show_version
show_version:
	.frame	$fp,40,$31		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$31,32($sp)
	sw	$fp,28($sp)
	sw	$28,24($sp)
	move	$fp,$sp
	la	$4,$LC0
	la	$5,$LC1
	la	$25,printf
	jal	$31,$25
	move	$sp,$fp
	lw	$31,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$31
	.end	show_version
	.size	show_version, .-show_version
	.rdata
	.align	2
$LC2:
	.ascii	"julia-set.help\000"
	.align	2
$LC3:
	.ascii	"r\000"
	.text
	.align	2
	.globl	show_help
	.ent	show_help
show_help:
	.frame	$fp,1080,$31		# vars= 1040, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,1080
	.cprestore 16
	sw	$31,1072($sp)
	sw	$fp,1068($sp)
	sw	$28,1064($sp)
	move	$fp,$sp
	la	$4,$LC2
	la	$5,$LC3
	la	$25,fopen
	jal	$31,$25
	sw	$2,24($fp)
$L19:
	addu	$2,$fp,32
	move	$4,$2
	li	$5,1			# 0x1
	li	$6,1024			# 0x400
	lw	$7,24($fp)
	la	$25,fread
	jal	$31,$25
	sw	$2,1056($fp)
	lw	$2,1056($fp)
	bgtz	$2,$L21
	b	$L20
$L21:
	addu	$2,$fp,32
	move	$4,$2
	la	$25,puts
	jal	$31,$25
	b	$L19
$L20:
	lw	$4,24($fp)
	la	$25,fclose
	jal	$31,$25
	move	$sp,$fp
	lw	$31,1072($sp)
	lw	$fp,1068($sp)
	addu	$sp,$sp,1080
	j	$31
	.end	show_help
	.size	show_help, .-show_help
	.align	2
	.globl	load_new_resolution
	.ent	load_new_resolution
load_new_resolution:
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
	sw	$6,56($fp)
	lw	$16,52($fp)
	lw	$4,56($fp)
	addu	$5,$fp,24
	li	$6,10			# 0xa
	la	$25,strtol
	jal	$31,$25
	sw	$2,0($16)
	lw	$16,48($fp)
	lw	$2,24($fp)
	addu	$2,$2,1
	move	$4,$2
	move	$5,$0
	li	$6,10			# 0xa
	la	$25,strtol
	jal	$31,$25
	sw	$2,0($16)
	lw	$2,52($fp)
	lw	$2,0($2)
	beq	$2,$0,$L24
	lw	$2,48($fp)
	lw	$2,0($2)
	bne	$2,$0,$L23
$L24:
	li	$2,1			# 0x1
	sw	$2,28($fp)
	b	$L22
$L23:
	sw	$0,28($fp)
$L22:
	lw	$2,28($fp)
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	lw	$16,32($sp)
	addu	$sp,$sp,48
	j	$31
	.end	load_new_resolution
	.size	load_new_resolution, .-load_new_resolution
	.rdata
	.align	2
$LC4:
	.ascii	"-\000"
	.align	2
$LC5:
	.ascii	"wb\000"
	.align	2
$LC6:
	.ascii	"fatal: cannot open output file.\n\000"
	.align	2
$LC7:
	.ascii	"fatal: could not generate julia set.\n\000"
	.text
	.align	2
	.globl	write_image
	.ent	write_image
write_image:
	.frame	$fp,112,$31		# vars= 48, regs= 3/0, args= 40, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,112
	.cprestore 40
	sw	$31,104($sp)
	sw	$fp,100($sp)
	sw	$28,96($sp)
	move	$fp,$sp
	sw	$4,112($fp)
	sw	$5,116($fp)
	sw	$6,120($fp)
	sw	$7,124($fp)
	sw	$0,48($fp)
	addu	$3,$fp,56
	l.d	$f0,144($fp)
	s.d	$f0,16($sp)
	l.d	$f0,136($fp)
	s.d	$f0,24($sp)
	lw	$2,124($fp)
	sw	$2,32($sp)
	lw	$2,128($fp)
	sw	$2,36($sp)
	move	$4,$3
	lw	$5,120($fp)
	lw	$6,116($fp)
	la	$25,decoder_init
	jal	$31,$25
	la	$4,$LC4
	lw	$5,112($fp)
	la	$25,strcmp
	jal	$31,$25
	bne	$2,$0,$L26
	la	$2,__sF+88
	sw	$2,88($fp)
	b	$L27
$L26:
	lw	$4,112($fp)
	la	$5,$LC5
	la	$25,fopen
	jal	$31,$25
	sw	$2,88($fp)
	lw	$2,88($fp)
	bne	$2,$0,$L27
	la	$4,__sF+176
	la	$5,$LC6
	la	$25,fprintf
	jal	$31,$25
	li	$2,8			# 0x8
	sw	$2,92($fp)
	b	$L25
$L27:
	addu	$2,$fp,56
	move	$4,$2
	lw	$5,88($fp)
	la	$25,decoder_decode
	jal	$31,$25
	beq	$2,$0,$L29
	la	$4,__sF+176
	la	$5,$LC7
	la	$25,fprintf
	jal	$31,$25
	li	$2,9			# 0x9
	sw	$2,48($fp)
$L29:
	la	$4,$LC4
	lw	$5,112($fp)
	la	$25,strcmp
	jal	$31,$25
	beq	$2,$0,$L30
	lw	$4,88($fp)
	la	$25,fclose
	jal	$31,$25
$L30:
	lw	$2,48($fp)
	sw	$2,92($fp)
$L25:
	lw	$2,92($fp)
	move	$sp,$fp
	lw	$31,104($sp)
	lw	$fp,100($sp)
	addu	$sp,$sp,112
	j	$31
	.end	write_image
	.size	write_image, .-write_image
	.rdata
	.align	2
$LC11:
	.ascii	"version\000"
	.align	2
$LC12:
	.ascii	"help\000"
	.align	2
$LC13:
	.ascii	"resolution\000"
	.align	2
$LC14:
	.ascii	"center\000"
	.align	2
$LC15:
	.ascii	"C\000"
	.align	2
$LC16:
	.ascii	"width\000"
	.align	2
$LC17:
	.ascii	"height\000"
	.align	2
$LC18:
	.ascii	"output\000"
	.data
	.align	2
$LC19:
	.word	$LC11
	.word	0
	.word	0
	.word	86
	.word	$LC12
	.word	0
	.word	0
	.word	104
	.word	$LC13
	.word	1
	.word	0
	.word	114
	.word	$LC14
	.word	1
	.word	0
	.word	99
	.word	$LC15
	.word	1
	.word	0
	.word	67
	.word	$LC16
	.word	1
	.word	0
	.word	119
	.word	$LC17
	.word	1
	.word	0
	.word	72
	.word	$LC18
	.word	1
	.word	0
	.word	111
	.globl	memcpy
	.rdata
	.align	2
$LC20:
	.ascii	"Vhr:c:C:w:H:o:\000"
	.align	2
$LC21:
	.ascii	"fatal: invalid resolution specification.\n\000"
	.align	2
$LC22:
	.ascii	"fatal: invalid center specification.\n\000"
	.align	2
$LC23:
	.ascii	"fatal: invalid C specification.\n\000"
	.align	2
$LC24:
	.ascii	"fatal: invalid complex plane width specification.\n\000"
	.align	2
$LC25:
	.ascii	"fatal: invalid complex plane height specification.\n\000"
	.align	2
$LC26:
	.ascii	"fatal: No output specified.\n\000"
	.align	2
$LC27:
	.ascii	"JULIA SET\n"
	.ascii	" resolution_height = %d\n"
	.ascii	" resolution_width = %d\n"
	.ascii	" re_center = %f\n"
	.ascii	" im_center = %f\n"
	.ascii	" re_C = %f\n"
	.ascii	" im_C = %f\n"
	.ascii	" complex_plane_height = %f\n"
	.ascii	" complex_plane_width = %f\n"
	.ascii	" output_file = %s\n\000"
	.align	3
$LC8:
	.word	-1546188227
	.word	1070742896
	.align	3
$LC9:
	.word	1202590843
	.word	1065646817
	.align	3
$LC10:
	.word	0
	.word	1074790400
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,304,$31		# vars= 208, regs= 3/0, args= 72, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,304
	.cprestore 72
	sw	$31,296($sp)
	sw	$fp,292($sp)
	sw	$28,288($sp)
	move	$fp,$sp
	sw	$4,304($fp)
	sw	$5,308($fp)
	sb	$0,87($fp)
	sb	$0,86($fp)
	sb	$0,85($fp)
	sb	$0,84($fp)
	sb	$0,83($fp)
	sb	$0,82($fp)
	sb	$0,81($fp)
	sb	$0,80($fp)
	li	$2,480			# 0x1e0
	sw	$2,88($fp)
	li	$2,640			# 0x280
	sw	$2,92($fp)
	addu	$2,$fp,96
	sw	$0,16($sp)
	sw	$0,20($sp)
	move	$4,$2
	move	$6,$0
	move	$7,$0
	la	$25,complex_init
	jal	$31,$25
	addu	$2,$fp,112
	l.d	$f2,$LC8
	l.d	$f0,$LC9
	s.d	$f0,16($sp)
	move	$4,$2
	mfc1	$6,$f2
	mfc1	$7,$f3
	la	$25,complex_init
	jal	$31,$25
	l.d	$f0,$LC10
	s.d	$f0,128($fp)
	l.d	$f0,$LC10
	s.d	$f0,136($fp)
	sw	$0,144($fp)
	sw	$0,148($fp)
	addu	$2,$fp,152
	la	$3,$LC19
	move	$4,$2
	move	$5,$3
	li	$6,128			# 0x80
	la	$25,memcpy
	jal	$31,$25
$L32:
	addu	$2,$fp,152
	sw	$0,16($sp)
	lw	$4,304($fp)
	lw	$5,308($fp)
	la	$6,$LC20
	move	$7,$2
	la	$25,getopt_long
	jal	$31,$25
	sw	$2,148($fp)
	lw	$3,148($fp)
	li	$2,-1			# 0xffffffffffffffff
	bne	$3,$2,$L34
	b	$L33
$L34:
	lw	$2,148($fp)
	addu	$2,$2,-67
	sw	$2,284($fp)
	lw	$3,284($fp)
	sltu	$2,$3,53
	beq	$2,$0,$L32
	lw	$2,284($fp)
	sll	$3,$2,2
	la	$2,$L51
	addu	$2,$3,$2
	lw	$2,0($2)
	.cpadd	$2
	j	$2
	.rdata
	.align	2
$L51:
	.gpword	$L42
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L47
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L36
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L40
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L37
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L50
	.gpword	$L32
	.gpword	$L32
	.gpword	$L38
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L32
	.gpword	$L44
	.text
$L36:
	li	$2,1			# 0x1
	sb	$2,81($fp)
	b	$L32
$L37:
	li	$2,1			# 0x1
	sb	$2,80($fp)
	b	$L32
$L38:
	li	$2,1			# 0x1
	sb	$2,82($fp)
	addu	$2,$fp,88
	addu	$3,$fp,92
	move	$4,$2
	move	$5,$3
	lw	$6,optarg
	la	$25,load_new_resolution
	jal	$31,$25
	beq	$2,$0,$L32
	la	$4,__sF+176
	la	$5,$LC21
	la	$25,fprintf
	jal	$31,$25
	li	$2,2			# 0x2
	sw	$2,280($fp)
	b	$L31
$L40:
	li	$2,1			# 0x1
	sb	$2,83($fp)
	addu	$2,$fp,96
	move	$4,$2
	lw	$5,optarg
	la	$25,strtoc
	jal	$31,$25
	beq	$2,$0,$L32
	la	$4,__sF+176
	la	$5,$LC22
	la	$25,fprintf
	jal	$31,$25
	li	$3,3			# 0x3
	sw	$3,280($fp)
	b	$L31
$L42:
	li	$2,1			# 0x1
	sb	$2,84($fp)
	addu	$2,$fp,112
	move	$4,$2
	lw	$5,optarg
	la	$25,strtoc
	jal	$31,$25
	beq	$2,$0,$L32
	la	$4,__sF+176
	la	$5,$LC23
	la	$25,fprintf
	jal	$31,$25
	li	$2,4			# 0x4
	sw	$2,280($fp)
	b	$L31
$L44:
	li	$2,1			# 0x1
	sb	$2,85($fp)
	lw	$4,optarg
	la	$25,atof
	jal	$31,$25
	s.d	$f0,136($fp)
	l.d	$f2,136($fp)
	mtc1	$0,$f0
	mtc1	$0,$f1
	c.eq.d	$f2,$f0
	bc1t	$L46
	b	$L32
$L46:
	la	$4,__sF+176
	la	$5,$LC24
	la	$25,fprintf
	jal	$31,$25
	li	$3,5			# 0x5
	sw	$3,280($fp)
	b	$L31
$L47:
	li	$2,1			# 0x1
	sb	$2,86($fp)
	lw	$4,optarg
	la	$25,atof
	jal	$31,$25
	s.d	$f0,128($fp)
	l.d	$f2,128($fp)
	mtc1	$0,$f0
	mtc1	$0,$f1
	c.eq.d	$f2,$f0
	bc1t	$L49
	b	$L32
$L49:
	la	$4,__sF+176
	la	$5,$LC25
	la	$25,fprintf
	jal	$31,$25
	li	$2,6			# 0x6
	sw	$2,280($fp)
	b	$L31
$L50:
	li	$2,1			# 0x1
	sb	$2,87($fp)
	lw	$2,optarg
	sw	$2,144($fp)
	b	$L32
$L33:
	lbu	$2,81($fp)
	beq	$2,$0,$L53
	la	$25,show_version
	jal	$31,$25
	b	$L54
$L53:
	lbu	$2,80($fp)
	beq	$2,$0,$L55
	la	$25,show_help
	jal	$31,$25
	b	$L54
$L55:
	lbu	$2,87($fp)
	bne	$2,$0,$L57
	la	$4,__sF+176
	la	$5,$LC26
	la	$25,fprintf
	jal	$31,$25
	li	$3,7			# 0x7
	sw	$3,280($fp)
	b	$L31
$L57:
	l.d	$f0,96($fp)
	s.d	$f0,16($sp)
	l.d	$f0,104($fp)
	s.d	$f0,24($sp)
	l.d	$f0,112($fp)
	s.d	$f0,32($sp)
	l.d	$f0,120($fp)
	s.d	$f0,40($sp)
	l.d	$f0,128($fp)
	s.d	$f0,48($sp)
	l.d	$f0,136($fp)
	s.d	$f0,56($sp)
	lw	$2,144($fp)
	sw	$2,64($sp)
	la	$4,$LC27
	lw	$5,88($fp)
	lw	$6,92($fp)
	la	$25,printf
	jal	$31,$25
	addu	$3,$fp,96
	addu	$2,$fp,112
	sw	$2,16($sp)
	l.d	$f0,128($fp)
	s.d	$f0,24($sp)
	l.d	$f0,136($fp)
	s.d	$f0,32($sp)
	lw	$4,144($fp)
	lw	$5,88($fp)
	lw	$6,92($fp)
	move	$7,$3
	la	$25,write_image
	jal	$31,$25
	sw	$2,280($fp)
	b	$L31
$L54:
	sw	$0,280($fp)
$L31:
	lw	$2,280($fp)
	move	$sp,$fp
	lw	$31,296($sp)
	lw	$fp,292($sp)
	addu	$sp,$sp,304
	j	$31
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
