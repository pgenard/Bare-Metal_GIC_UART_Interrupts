	.arch armv8-a+crc
	.file	"uart_imx8.c"
	.text
	.section	.rodata
	.align	2
	.type	refclock, %object
	.size	refclock, 4
refclock:
	.word	24000000
	.global	rx_buffer
	.bss
	.align	3
	.type	rx_buffer, %object
	.size	rx_buffer, 128
rx_buffer:
	.zero	128
	.global	rx_head
	.align	2
	.type	rx_head, %object
	.size	rx_head, 4
rx_head:
	.zero	4
	.global	rx_tail
	.align	2
	.type	rx_tail, %object
	.size	rx_tail, 4
rx_tail:
	.zero	4
	.global	irq_count_2
	.align	2
	.type	irq_count_2, %object
	.size	irq_count_2, 4
irq_count_2:
	.zero	4
	.global	last_char
	.type	last_char, %object
	.size	last_char, 1
last_char:
	.zero	1
	.global	rx_char
	.type	rx_char, %object
	.size	rx_char, 1
rx_char:
	.zero	1
	.global	rx_available
	.align	2
	.type	rx_available, %object
	.size	rx_available, 4
rx_available:
	.zero	4
	.global	irq_count_3
	.align	2
	.type	irq_count_3, %object
	.size	irq_count_3, 4
irq_count_3:
	.zero	4
	.global	rx_count
	.align	2
	.type	rx_count, %object
	.size	rx_count, 4
rx_count:
	.zero	4
	.text
	.align	2
	.global	uart_getline
	.type	uart_getline, %function
uart_getline:
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	wzr, [sp, 44]
.L5:
	bl	uart_getchar
	strb	w0, [sp, 43]
	ldrb	w0, [sp, 43]
	bl	uart_putchar
	ldrb	w0, [sp, 43]
	cmp	w0, 13
	bne	.L2
	mov	w0, 10
	bl	uart_putchar
	ldr	w0, [sp, 44]
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	strb	wzr, [x0]
	ldr	w0, [sp, 44]
	b	.L6
.L2:
	ldr	w0, [sp, 20]
	sub	w0, w0, #1
	ldr	w1, [sp, 44]
	cmp	w1, w0
	bcs	.L5
	ldr	w0, [sp, 44]
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldrb	w1, [sp, 43]
	strb	w1, [x0]
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
	b	.L5
.L6:
	ldp	x29, x30, [sp], 48
	ret
	.size	uart_getline, .-uart_getline
	.align	2
	.global	uart_putchar
	.type	uart_putchar, %function
uart_putchar:
	sub	sp, sp, #16
	strb	w0, [sp, 15]
	nop
.L8:
	mov	x0, 152
	movk	x0, 0x3086, lsl 16
	ldr	w0, [x0]
	and	w0, w0, 16384
	cmp	w0, 0
	beq	.L8
	mov	x0, 64
	movk	x0, 0x3086, lsl 16
	ldrb	w1, [sp, 15]
	str	w1, [x0]
	nop
	add	sp, sp, 16
	ret
	.size	uart_putchar, .-uart_putchar
	.align	2
	.global	uart_getchar
	.type	uart_getchar, %function
uart_getchar:
	sub	sp, sp, #16
	nop
.L10:
	adrp	x0, rx_head
	add	x0, x0, :lo12:rx_head
	ldr	w1, [x0]
	adrp	x0, rx_tail
	add	x0, x0, :lo12:rx_tail
	ldr	w0, [x0]
	cmp	w1, w0
	beq	.L10
	adrp	x0, rx_tail
	add	x0, x0, :lo12:rx_tail
	ldr	w2, [x0]
	adrp	x0, rx_buffer
	add	x1, x0, :lo12:rx_buffer
	uxtw	x0, w2
	ldrb	w0, [x1, x0]
	strb	w0, [sp, 15]
	adrp	x0, rx_tail
	add	x0, x0, :lo12:rx_tail
	ldr	w0, [x0]
	add	w1, w0, 1
	adrp	x0, rx_tail
	add	x0, x0, :lo12:rx_tail
	str	w1, [x0]
	adrp	x0, rx_tail
	add	x0, x0, :lo12:rx_tail
	ldr	w0, [x0]
	cmp	w0, 127
	bls	.L11
	adrp	x0, rx_tail
	add	x0, x0, :lo12:rx_tail
	str	wzr, [x0]
.L11:
	ldrb	w0, [sp, 15]
	add	sp, sp, 16
	ret
	.size	uart_getchar, .-uart_getchar
	.align	2
	.global	uart_init
	.type	uart_init, %function
uart_init:
	mov	x0, 128
	movk	x0, 0x3086, lsl 16
	str	wzr, [x0]
	mov	x0, 144
	movk	x0, 0x3086, lsl 16
	mov	w1, 1
	str	w1, [x0]
	mov	x0, 164
	movk	x0, 0x3086, lsl 16
	mov	w1, 2303
	str	w1, [x0]
	mov	x0, 168
	movk	x0, 0x3086, lsl 16
	mov	w1, 3124
	str	w1, [x0]
	mov	x0, 132
	movk	x0, 0x3086, lsl 16
	mov	w1, 8487
	str	w1, [x0]
	mov	x0, 140
	movk	x0, 0x3086, lsl 16
	ldr	w1, [x0]
	mov	x0, 140
	movk	x0, 0x3086, lsl 16
	orr	w1, w1, 1
	str	w1, [x0]
	mov	x0, 128
	movk	x0, 0x3086, lsl 16
	mov	w1, 513
	str	w1, [x0]
	nop
	ret
	.size	uart_init, .-uart_init
	.align	2
	.global	uart_write
	.type	uart_write, %function
uart_write:
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x0, [sp, 24]
	b	.L15
.L16:
	ldr	x0, [sp, 24]
	add	x1, x0, 1
	str	x1, [sp, 24]
	ldrb	w0, [x0]
	bl	uart_putchar
.L15:
	ldr	x0, [sp, 24]
	ldrb	w0, [x0]
	cmp	w0, 0
	bne	.L16
	nop
	nop
	ldp	x29, x30, [sp], 32
	ret
	.size	uart_write, .-uart_write
	.align	2
	.global	uart_irq_handler
	.type	uart_irq_handler, %function
uart_irq_handler:
	sub	sp, sp, #16
	adrp	x0, irq_count_3
	add	x0, x0, :lo12:irq_count_3
	ldr	w0, [x0]
	add	w1, w0, 1
	adrp	x0, irq_count_3
	add	x0, x0, :lo12:irq_count_3
	str	w1, [x0]
	b	.L18
.L20:
	mov	x0, 814088192
	ldr	w0, [x0]
	strb	w0, [sp, 11]
	adrp	x0, rx_head
	add	x0, x0, :lo12:rx_head
	ldr	w0, [x0]
	add	w0, w0, 1
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	cmp	w0, 127
	bls	.L19
	str	wzr, [sp, 12]
.L19:
	adrp	x0, rx_tail
	add	x0, x0, :lo12:rx_tail
	ldr	w0, [x0]
	ldr	w1, [sp, 12]
	cmp	w1, w0
	beq	.L18
	adrp	x0, rx_head
	add	x0, x0, :lo12:rx_head
	ldr	w2, [x0]
	adrp	x0, rx_buffer
	add	x1, x0, :lo12:rx_buffer
	uxtw	x0, w2
	ldrb	w2, [sp, 11]
	strb	w2, [x1, x0]
	adrp	x0, rx_head
	add	x0, x0, :lo12:rx_head
	ldr	w1, [sp, 12]
	str	w1, [x0]
	adrp	x0, rx_count
	add	x0, x0, :lo12:rx_count
	ldr	w0, [x0]
	add	w1, w0, 1
	adrp	x0, rx_count
	add	x0, x0, :lo12:rx_count
	str	w1, [x0]
.L18:
	mov	x0, 152
	movk	x0, 0x3086, lsl 16
	ldr	w0, [x0]
	and	w0, w0, 1
	cmp	w0, 0
	bne	.L20
	nop
	nop
	add	sp, sp, 16
	ret
	.size	uart_irq_handler, .-uart_irq_handler
	.section	.rodata
	.align	3
.LC0:
	.string	"0123456789ABCDEF"
	.text
	.align	2
	.global	uart_print_hex
	.type	uart_print_hex, %function
uart_print_hex:
	stp	x29, x30, [sp, -64]!
	mov	x29, sp
	str	w0, [sp, 28]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	str	x0, [sp, 48]
	str	wzr, [sp, 60]
	b	.L22
.L23:
	mov	w1, 7
	ldr	w0, [sp, 60]
	sub	w0, w1, w0
	lsl	w0, w0, 2
	ldr	w1, [sp, 28]
	lsr	w0, w1, w0
	uxtw	x0, w0
	and	x0, x0, 15
	ldr	x1, [sp, 48]
	add	x0, x1, x0
	ldrb	w2, [x0]
	ldrsw	x0, [sp, 60]
	add	x1, sp, 32
	strb	w2, [x1, x0]
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L22:
	ldr	w0, [sp, 60]
	cmp	w0, 7
	ble	.L23
	strb	wzr, [sp, 40]
	add	x0, sp, 32
	bl	uart_write
	nop
	ldp	x29, x30, [sp], 64
	ret
	.size	uart_print_hex, .-uart_print_hex
	.ident	"GCC: (Arm GNU Toolchain 14.3.Rel1 (Build arm-14.174)) 14.3.1 20250623"
