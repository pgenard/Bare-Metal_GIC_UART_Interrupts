.section .text

.extern irq_count
	
.global sync_sp0
.global irq_sp0
.global fiq_sp0
.global serr_sp0

.global sync_spx
.global irq_spx
.global fiq_spx
.global serr_spx

.global sync_lower64
.global irq_lower64
.global fiq_lower64
.global serr_lower64

.global sync_lower32
.global irq_lower32
.global fiq_lower32
.global serr_lower32

.macro HANDLER name

\name:

    mrs x0, ESR_EL2
    mrs x1, ELR_EL2
    mrs x2, FAR_EL2
    mrs x3, SPSR_EL2

1:
    wfe
    b 1b

.endm

HANDLER sync_sp0
	
.global irq_sp0
irq_sp0:
    mov x0, #'0'
    bl uart_putchar
    eret

	
HANDLER fiq_sp0
HANDLER serr_sp0

sync_spx:
    mov x0, #'S'
    bl uart_putchar
1:  b 1b

.global irq_spx
irq_spx:
    sub sp, sp, #32

    str x30, [sp,#0]

    mrs x0, ICC_IAR1_EL1
    str x0, [sp,#8]

    bl uart_irq_handler

    ldr x0,[sp,#8]
    msr ICC_EOIR1_EL1,x0
    isb

    ldr x30,[sp,#0]

    add sp,sp,#32
    eret

serr_spx:
    mov x0, #'E'
    bl uart_putchar
1:  b 1b

fiq_spx:
    mov x0, #'F'
    bl uart_putchar
1:  b 1b

HANDLER sync_lower64
HANDLER irq_lower64
HANDLER fiq_lower64
HANDLER serr_lower64

HANDLER sync_lower32
HANDLER irq_lower32
HANDLER fiq_lower32
HANDLER serr_lower32
