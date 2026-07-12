	.arch armv8-a+crc
	.file	"string.c"
	.text
	.align	2
	.global	strlen
	.type	strlen, %function
strlen:
	sub	sp, sp, #32
	str	x0, [sp, 8]
	str	wzr, [sp, 28]
	b	.L2
.L3:
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L2:
	ldr	x0, [sp, 8]
	add	x1, x0, 1
	str	x1, [sp, 8]
	ldrb	w0, [x0]
	cmp	w0, 0
	bne	.L3
	ldr	w0, [sp, 28]
	add	sp, sp, 32
	ret
	.size	strlen, .-strlen
	.align	2
	.global	strcmp
	.type	strcmp, %function
strcmp:
	sub	sp, sp, #16
	str	x0, [sp, 8]
	str	x1, [sp]
	b	.L6
.L8:
	ldr	x0, [sp, 8]
	add	x0, x0, 1
	str	x0, [sp, 8]
	ldr	x0, [sp]
	add	x0, x0, 1
	str	x0, [sp]
.L6:
	ldr	x0, [sp, 8]
	ldrb	w0, [x0]
	cmp	w0, 0
	beq	.L7
	ldr	x0, [sp, 8]
	ldrb	w1, [x0]
	ldr	x0, [sp]
	ldrb	w0, [x0]
	cmp	w1, w0
	beq	.L8
.L7:
	ldr	x0, [sp, 8]
	ldrb	w0, [x0]
	mov	w1, w0
	ldr	x0, [sp]
	ldrb	w0, [x0]
	sub	w0, w1, w0
	add	sp, sp, 16
	ret
	.size	strcmp, .-strcmp
	.align	2
	.global	strncmp
	.type	strncmp, %function
strncmp:
	sub	sp, sp, #48
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	w2, [sp, 12]
	b	.L11
.L14:
	ldr	x0, [sp, 24]
	add	x1, x0, 1
	str	x1, [sp, 24]
	ldrb	w0, [x0]
	strb	w0, [sp, 47]
	ldr	x0, [sp, 16]
	add	x1, x0, 1
	str	x1, [sp, 16]
	ldrb	w0, [x0]
	strb	w0, [sp, 46]
	ldrb	w1, [sp, 47]
	ldrb	w0, [sp, 46]
	cmp	w1, w0
	beq	.L12
	ldrb	w1, [sp, 47]
	ldrb	w0, [sp, 46]
	sub	w0, w1, w0
	b	.L13
.L12:
	ldrb	w0, [sp, 47]
	cmp	w0, 0
	bne	.L11
	mov	w0, 0
	b	.L13
.L11:
	ldr	w0, [sp, 12]
	sub	w1, w0, #1
	str	w1, [sp, 12]
	cmp	w0, 0
	bne	.L14
	mov	w0, 0
.L13:
	add	sp, sp, 48
	ret
	.size	strncmp, .-strncmp
	.ident	"GCC: (Arm GNU Toolchain 14.3.Rel1 (Build arm-14.174)) 14.3.1 20250623"
