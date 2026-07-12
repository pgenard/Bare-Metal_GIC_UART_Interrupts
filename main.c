#include "uart_imx8.h"
#include "string.h"

#define GICD_BASE 0x38800000UL
#define GICR_BASE 0x38880000UL
#define UART1_SPI 26
#define UART1_IRQ 26
#define UART1_GIC_ID 58
#define UART1_SPI_ID 58
#define UART1_GIC_ID 58

#define GICD_ISENABLER(n) (*(volatile unsigned int *)(GICD_BASE + 0x100 + ((n / 32) * 4)))
#define GICD_IPRIORITYR(n) (*(volatile unsigned char *)(GICD_BASE + 0x400 + (n)))
#define GICD_IROUTER(n) (*(volatile unsigned long long *)(GICD_BASE + 0x6000 + ((n) * 8)))
#define GICD_ISPENDR(n) (*(volatile unsigned int *)(0x38800000UL + 0x200 + ((n / 32) * 4)))
#define GICD_IGROUPR(n) (*(volatile unsigned int *)(GICD_BASE + 0x080 + ((n / 32) * 4)))
#define GICD_IGROUPR_ADDR(n) (GICD_BASE + 0x080 + (((n) / 32) * 4))

#define GICD_TYPER (*(volatile unsigned int *)(GICD_BASE + 0x004))
#define GICD_IIDR  (*(volatile unsigned int *)(GICD_BASE + 0x0FC))
#define GICD_ISPENDR0 (*(volatile unsigned int *)(0x38800000UL + 0x200))
#define GICR_WAKER (*(volatile unsigned int *)(GICR_BASE + 0x0014))
#define GICD_CTLR (*(volatile unsigned int *)(GICD_BASE + 0x0000))
#define GICD_RWP (*(volatile unsigned int *)(GICD_BASE + 0x0A0))
#define GICD_IGROUPR0 (*(volatile unsigned int *)(GICD_BASE + 0x080))
#define GICD_STATUSR (*(volatile unsigned int *)(GICD_BASE + 0x00C))
#define GICR_ISENABLER0 (*(volatile unsigned int *)(GICR_SGI_BASE + 0x100))
#define GICR_IGROUPR0 (*(volatile unsigned int *)(GICR_SGI_BASE + 0x080))

#define GICR_SGI_BASE (GICR_BASE + 0x10000)

char command[64] = {0};
unsigned int buf_idx = 0u;

volatile unsigned long irq_count = 0;

static inline void enable_el2_irq(void)
{
    unsigned long hcr;

    asm volatile(
        "mrs %0, HCR_EL2"
        : "=r"(hcr));

    hcr |= (1 << 4);  // IMO
    hcr |= (1 << 3);  // FMO

    asm volatile(
        "msr HCR_EL2,%0\n"
        "isb"
        :
        : "r"(hcr));
}

static inline void route_irq_to_el2(void)
{
    unsigned long hcr;

    asm volatile(
        "mrs %0, HCR_EL2"
        : "=r"(hcr));

    hcr |= (1 << 4);   /* IMO */

    asm volatile(
        "msr HCR_EL2, %0\n"
        "isb"
        :
        : "r"(hcr));
}

static void gic_enable_group1(void)
{
    GICD_CTLR |= (1 << 1);

    uart_write("GICD_CTLR=");
    uart_print_hex(GICD_CTLR);
    uart_write("\n");
}

static void gic_wait_rwp(void)
{
    while (GICD_RWP & 1)
    {
        ;
    }
}

void gic_set_uart1_group1(void)
{
    GICD_IGROUPR(UART1_GIC_ID) =
        (1u << (UART1_GIC_ID % 32));

}

void gic_disable_distributor(void)
{
    unsigned int ctlr;

    ctlr = GICD_CTLR;
    GICD_CTLR = 0;

    asm volatile("dsb sy");
    asm volatile("isb");

    gic_wait_rwp();
}

void gic_test_enable_write(void)
{
    volatile unsigned int *reg =
        (volatile unsigned int *)(GICD_BASE + 0x100);

    *reg = 0x04000000;
}

void gic_debug_route_uart1(void)
{
    unsigned long long route;

    route = GICD_IROUTER(UART1_GIC_ID);

    uart_write("IROUTER=");
    uart_print_hex((unsigned int)(route & 0xffffffff));
    uart_write("\n");
}

void gic_debug_irq26(void)
{
    unsigned int id;

    id = 58;
}

void gic_debug_pending_uart1(void)
{
    unsigned int value;

    value = GICD_ISPENDR(UART1_SPI_ID);

    uart_write("ISPENDR=");
    uart_print_hex(value);
    uart_write("\n");
}

void gic_redistributor_wake(void)
{
    unsigned int waker;

    /* Clear ProcessorSleep (bit 1) */
    waker = GICR_WAKER;
    waker &= ~(1u << 1);
    GICR_WAKER = waker;

    /* Wait until ChildrenAsleep == 0 */
    while (GICR_WAKER & (1u << 2));
}

void gic_distributor_enable(void)
{
    unsigned int ctlr;

    /*
     * Enable Affinity Routing for Non-secure Group 1 interrupts
     * and enable Group 1 interrupts.
     */
    ctlr = GICD_CTLR;

    ctlr |= (1u << 5);   /* ARE_NS */
    ctlr |= (1u << 1);   /* EnableGrp1NS */

    GICD_CTLR = ctlr;

    /* Ensure write completes */
    asm volatile("dsb sy");
    asm volatile("isb");
}

void debug_pending(void)
{
    unsigned int pending = GICD_ISPENDR0;

    uart_write("ISPENDR0 = 0x");
    // uart_print_hex(pending);
    uart_write("\n");
}

void gic_enable_uart1(void)
{
    GICD_ISENABLER(UART1_GIC_ID) =
        (1u << (UART1_GIC_ID % 32));
}

void gic_route_uart1(void)
{
    GICD_IROUTER(58) = 0;
}

void gic_set_priority(unsigned int irq)
{
    GICD_IPRIORITYR(irq) = 0x80;
}

static inline void gic_cpu_enable(void)
{
    unsigned long x;

    asm volatile("mrs %0, ICC_SRE_EL2" : "=r"(x));
    
    /* Enable system register interface */
    asm volatile(
        "mrs %0, ICC_SRE_EL2\n"
        "orr %0, %0, #1\n"
        "msr ICC_SRE_EL2, %0\n"
        "isb"
        : "=r"(x));
    
    /* Accept all priorities */
    x = 0xff;
    asm volatile(
        "msr ICC_PMR_EL1, %0\n"
        "isb"
        :
        : "r"(x));
    
    /* Enable Group 1 interrupts */
    x = 1;
    asm volatile(
        "msr ICC_IGRPEN1_EL1, %0\n"
        "isb"
        :
        : "r"(x));
}

static void parse_command(const char *cmd)
{
    if (!strcmp(cmd, "help"))
    {
        uart_write("Commands:\n");
        uart_write("  help\n");
        uart_write("  uname\n");
    }
    else if (!strcmp(cmd, "uname"))
    {
        uart_write("[Bare-Metal ARM UART Driver by Pierre GENARD]\n");
    }
    else
    {
        uart_write("Unknown command\n");
    }
}

int main() {
        uart_init();

        gic_redistributor_wake();
        gic_distributor_enable();      // enable ARE_NS + Group1
	gic_set_uart1_group1();
	
        gic_set_priority(58);
        gic_route_uart1();
        gic_enable_uart1();

	unsigned int z1;

	asm volatile(
        "msr DAIFClr, #0xf\n"
        "isb"
        );
 
	route_irq_to_el2();
        gic_cpu_enable();

asm volatile(
    "msr daifclr, #2\n"
    "isb"
);

asm volatile(
    "msr daifclr, #2\n"
    "isb"
);
 
       unsigned int pending = GICD_ISPENDR(UART1_GIC_ID);

       asm volatile(
         "msr daifclr, #2\n"
         "isb"
       );
 
       while (1) {
         uart_write("Command> ");

         unsigned int ret = uart_getline(command, sizeof(command));
 
         if (ret >= 0) {
           parse_command(command);
	 } 
      }

      return 0;
}
