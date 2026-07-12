	.arch armv8-a+crc
	.file	"main.c"
	.text
	.global	command
	.bss
	.align	3
	.type	command, %object
	.size	command, 64
command:
	.zero	64
	.global	buf_idx
	.align	2
	.type	buf_idx, %object
	.size	buf_idx, 4
buf_idx:
	.zero	4
	.global	irq_count
	.align	3
	.type	irq_count, %object
	.size	irq_count, 8
irq_count:
	.zero	8
	.text
	.align	2
	.type	route_irq_to_el2, %function
route_irq_to_el2:
	sub	sp, sp, #16
	// Start of user assembly
// 59 "main.c" 1
	mrs x0, HCR_EL2
// 0 "" 2
	// End of user assembly
	str	x0, [sp, 8]
	ldr	x0, [sp, 8]
	orr	x0, x0, 16
	str	x0, [sp, 8]
	ldr	x0, [sp, 8]
	// Start of user assembly
// 65 "main.c" 1
	msr HCR_EL2, x0
isb
// 0 "" 2
	// End of user assembly
	nop
	add	sp, sp, 16
	ret
	.size	route_irq_to_el2, .-route_irq_to_el2
	.section	.rodata
	.align	3
.LC0:
	.string	"GICD_CTLR="
	.align	3
.LC1:
	.string	"\n"
	.text
	.align	2
	.type	gic_enable_group1, %function
gic_enable_group1:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	mov	x0, 947912704
	ldr	w1, [x0]
	mov	x0, 947912704
	orr	w1, w1, 2
	str	w1, [x0]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	uart_write
	mov	x0, 947912704
	ldr	w0, [x0]
	bl	uart_print_hex
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	uart_write
	nop
	ldp	x29, x30, [sp], 16
	ret
	.size	gic_enable_group1, .-gic_enable_group1
	.align	2
	.type	gic_wait_rwp, %function
gic_wait_rwp:
	nop
.L4:
	mov	x0, 160
	movk	x0, 0x3880, lsl 16
	ldr	w0, [x0]
	and	w0, w0, 1
	cmp	w0, 0
	bne	.L4
	nop
	nop
	ret
	.size	gic_wait_rwp, .-gic_wait_rwp
	.align	2
	.global	gic_set_uart1_group1
	.type	gic_set_uart1_group1, %function
gic_set_uart1_group1:
	mov	x0, 132
	movk	x0, 0x3880, lsl 16
	mov	w1, 67108864
	str	w1, [x0]
	nop
	ret
	.size	gic_set_uart1_group1, .-gic_set_uart1_group1
	.align	2
	.global	gic_disable_distributor
	.type	gic_disable_distributor, %function
gic_disable_distributor:
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	mov	x0, 947912704
	ldr	w0, [x0]
	str	w0, [sp, 28]
	mov	x0, 947912704
	str	wzr, [x0]
	// Start of user assembly
// 103 "main.c" 1
	dsb sy
// 0 "" 2
// 104 "main.c" 1
	isb
// 0 "" 2
	// End of user assembly
	bl	gic_wait_rwp
	nop
	ldp	x29, x30, [sp], 32
	ret
	.size	gic_disable_distributor, .-gic_disable_distributor
	.align	2
	.global	gic_test_enable_write
	.type	gic_test_enable_write, %function
gic_test_enable_write:
	sub	sp, sp, #16
	mov	x0, 256
	movk	x0, 0x3880, lsl 16
	str	x0, [sp, 8]
	ldr	x0, [sp, 8]
	mov	w1, 67108864
	str	w1, [x0]
	nop
	add	sp, sp, 16
	ret
	.size	gic_test_enable_write, .-gic_test_enable_write
	.section	.rodata
	.align	3
.LC2:
	.string	"IROUTER="
	.text
	.align	2
	.global	gic_debug_route_uart1
	.type	gic_debug_route_uart1, %function
gic_debug_route_uart1:
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	mov	x0, 25040
	movk	x0, 0x3880, lsl 16
	ldr	x0, [x0]
	str	x0, [sp, 24]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	uart_write
	ldr	x0, [sp, 24]
	bl	uart_print_hex
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	uart_write
	nop
	ldp	x29, x30, [sp], 32
	ret
	.size	gic_debug_route_uart1, .-gic_debug_route_uart1
	.align	2
	.global	gic_debug_irq26
	.type	gic_debug_irq26, %function
gic_debug_irq26:
	sub	sp, sp, #16
	mov	w0, 58
	str	w0, [sp, 12]
	nop
	add	sp, sp, 16
	ret
	.size	gic_debug_irq26, .-gic_debug_irq26
	.section	.rodata
	.align	3
.LC3:
	.string	"ISPENDR="
	.text
	.align	2
	.global	gic_debug_pending_uart1
	.type	gic_debug_pending_uart1, %function
gic_debug_pending_uart1:
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	mov	x0, 516
	movk	x0, 0x3880, lsl 16
	ldr	w0, [x0]
	str	w0, [sp, 28]
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	uart_write
	ldr	w0, [sp, 28]
	bl	uart_print_hex
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	uart_write
	nop
	ldp	x29, x30, [sp], 32
	ret
	.size	gic_debug_pending_uart1, .-gic_debug_pending_uart1
	.align	2
	.global	gic_redistributor_wake
	.type	gic_redistributor_wake, %function
gic_redistributor_wake:
	sub	sp, sp, #16
	mov	x0, 20
	movk	x0, 0x3888, lsl 16
	ldr	w0, [x0]
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	and	w0, w0, -3
	str	w0, [sp, 12]
	mov	x0, 20
	movk	x0, 0x3888, lsl 16
	ldr	w1, [sp, 12]
	str	w1, [x0]
	nop
.L12:
	mov	x0, 20
	movk	x0, 0x3888, lsl 16
	ldr	w0, [x0]
	and	w0, w0, 4
	cmp	w0, 0
	bne	.L12
	nop
	nop
	add	sp, sp, 16
	ret
	.size	gic_redistributor_wake, .-gic_redistributor_wake
	.align	2
	.global	gic_distributor_enable
	.type	gic_distributor_enable, %function
gic_distributor_enable:
	sub	sp, sp, #16
	mov	x0, 947912704
	ldr	w0, [x0]
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	orr	w0, w0, 32
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	orr	w0, w0, 2
	str	w0, [sp, 12]
	mov	x0, 947912704
	ldr	w1, [sp, 12]
	str	w1, [x0]
	// Start of user assembly
// 175 "main.c" 1
	dsb sy
// 0 "" 2
// 176 "main.c" 1
	isb
// 0 "" 2
	// End of user assembly
	nop
	add	sp, sp, 16
	ret
	.size	gic_distributor_enable, .-gic_distributor_enable
	.section	.rodata
	.align	3
.LC4:
	.string	"ISPENDR0 = 0x"
	.text
	.align	2
	.global	debug_pending
	.type	debug_pending, %function
debug_pending:
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	mov	x0, 512
	movk	x0, 0x3880, lsl 16
	ldr	w0, [x0]
	str	w0, [sp, 28]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	uart_write
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	uart_write
	nop
	ldp	x29, x30, [sp], 32
	ret
	.size	debug_pending, .-debug_pending
	.align	2
	.global	gic_enable_uart1
	.type	gic_enable_uart1, %function
gic_enable_uart1:
	mov	x0, 260
	movk	x0, 0x3880, lsl 16
	mov	w1, 67108864
	str	w1, [x0]
	nop
	ret
	.size	gic_enable_uart1, .-gic_enable_uart1
	.align	2
	.global	gic_route_uart1
	.type	gic_route_uart1, %function
gic_route_uart1:
	mov	x0, 25040
	movk	x0, 0x3880, lsl 16
	str	xzr, [x0]
	nop
	ret
	.size	gic_route_uart1, .-gic_route_uart1
	.align	2
	.global	gic_set_priority
	.type	gic_set_priority, %function
gic_set_priority:
	sub	sp, sp, #16
	str	w0, [sp, 12]
	ldr	w1, [sp, 12]
	mov	x0, 1024
	movk	x0, 0x3880, lsl 16
	add	x0, x1, x0
	mov	x1, x0
	mov	w0, -128
	strb	w0, [x1]
	nop
	add	sp, sp, 16
	ret
	.size	gic_set_priority, .-gic_set_priority
	.align	2
	.type	gic_cpu_enable, %function
gic_cpu_enable:
	sub	sp, sp, #16
	// Start of user assembly
// 208 "main.c" 1
	mrs x0, ICC_SRE_EL2
// 0 "" 2
	// End of user assembly
	str	x0, [sp, 8]
	// Start of user assembly
// 211 "main.c" 1
	mrs x0, ICC_SRE_EL2
orr x0, x0, #1
msr ICC_SRE_EL2, x0
isb
// 0 "" 2
	// End of user assembly
	str	x0, [sp, 8]
	mov	x0, 255
	str	x0, [sp, 8]
	ldr	x0, [sp, 8]
	// Start of user assembly
// 220 "main.c" 1
	msr ICC_PMR_EL1, x0
isb
// 0 "" 2
	// End of user assembly
	mov	x0, 1
	str	x0, [sp, 8]
	ldr	x0, [sp, 8]
	// Start of user assembly
// 228 "main.c" 1
	msr ICC_IGRPEN1_EL1, x0
isb
// 0 "" 2
	// End of user assembly
	nop
	add	sp, sp, 16
	ret
	.size	gic_cpu_enable, .-gic_cpu_enable
	.section	.rodata
	.align	3
.LC5:
	.string	"help"
	.align	3
.LC6:
	.string	"Commands:\n"
	.align	3
.LC7:
	.string	"  help\n"
	.align	3
.LC8:
	.string	"  uname\n"
	.align	3
.LC9:
	.string	"uname"
	.align	3
.LC10:
	.string	"[Bare-Metal ARM UART Driver by Pierre GENARD]\n"
	.align	3
.LC11:
	.string	"Unknown command\n"
	.text
	.align	2
	.type	parse_command, %function
parse_command:
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x0, [sp, 24]
	adrp	x0, .LC5
	add	x1, x0, :lo12:.LC5
	ldr	x0, [sp, 24]
	bl	strcmp
	cmp	w0, 0
	bne	.L20
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	uart_write
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	uart_write
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	uart_write
	b	.L23
.L20:
	adrp	x0, .LC9
	add	x1, x0, :lo12:.LC9
	ldr	x0, [sp, 24]
	bl	strcmp
	cmp	w0, 0
	bne	.L22
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	uart_write
	b	.L23
.L22:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	uart_write
.L23:
	nop
	ldp	x29, x30, [sp], 32
	ret
	.size	parse_command, .-parse_command
	.section	.rodata
	.align	3
.LC12:
	.string	"Command> "
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	bl	uart_init
	bl	gic_redistributor_wake
	bl	gic_distributor_enable
	bl	gic_set_uart1_group1
	mov	w0, 58
	bl	gic_set_priority
	bl	gic_route_uart1
	bl	gic_enable_uart1
	// Start of user assembly
// 266 "main.c" 1
	msr DAIFClr, #0xf
isb
// 0 "" 2
	// End of user assembly
	bl	route_irq_to_el2
	bl	gic_cpu_enable
	// Start of user assembly
// 274 "main.c" 1
	msr daifclr, #2
isb
// 0 "" 2
// 279 "main.c" 1
	msr daifclr, #2
isb
// 0 "" 2
	// End of user assembly
	mov	x0, 516
	movk	x0, 0x3880, lsl 16
	ldr	w0, [x0]
	str	w0, [sp, 28]
	// Start of user assembly
// 286 "main.c" 1
	msr daifclr, #2
isb
// 0 "" 2
	// End of user assembly
.L25:
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	uart_write
	mov	w1, 64
	adrp	x0, command
	add	x0, x0, :lo12:command
	bl	uart_getline
	str	w0, [sp, 24]
	adrp	x0, command
	add	x0, x0, :lo12:command
	bl	parse_command
	b	.L25
	.size	main, .-main
	.ident	"GCC: (Arm GNU Toolchain 14.3.Rel1 (Build arm-14.174)) 14.3.1 20250623"
