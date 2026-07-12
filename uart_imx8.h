#ifndef UART_IMX8_H
#define UART_IMX8_H

typedef enum {
        UART_OK = 0,
        UART_INVALID_ARGUMENT_BAUDRATE,
        UART_INVALID_ARGUMENT_WORDSIZE,
        UART_INVALID_ARGUMENT_STOP_BITS,
        UART_RECEIVE_ERROR,
        UART_NO_DATA
} uart_error;

typedef struct {
    unsigned char     data_bits;
    unsigned char     stop_bits;
    unsigned short     parity;
    unsigned int     baudrate;
} uart_config;

extern volatile unsigned char rx_buffer[];
extern volatile unsigned int rx_head;
extern volatile unsigned int rx_tail;
extern volatile unsigned int irq_count_3;
extern volatile unsigned int rx_count;

void uart_init(void);
void uart_putchar(unsigned char c);
void uart_write(const unsigned char* data);
unsigned char uart_getchar(void);
void uart_debug_status(void);
void uart_debug_irq_source(void);
void interrupt_enable_bits(void);
void uart_print_hex(unsigned int);
int uart_getline(char *buffer, unsigned int size);

#endif
