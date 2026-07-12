# Bare-Metal GIC Support and UART RX Interrupts on Emulated i.MX8MP with QEMU.

## About

**Bare-Metal GIC UART Interrupts** demonstrates interrupt-driven serial communication on an **ARMv8-A** processor without an operating system. The project configures the **Generic Interrupt Controller (GICv3)** and an **NXP i.MX8 UART** to receive serial data using interrupts, storing incoming characters in a circular buffer. Outgoing serial data is transmitted using polling. A simple command-line interface illustrates how UART interrupts, exception handling, and bare-metal software components work together.

There is still a lot of garbage code within the source code.

### Features
- Bare-metal ARMv8-A startup code
- EL2 exception vector table
- GICv3 initialization and interrupt routing
- Interrupt-driven UART receive
- Circular receive buffer
- Polling-based UART transmit
- Simple serial command-line interface

### Hints

Our QEMU emulated platform doc is available here: https://www.qemu.org/docs/master/system/arm/imx8mp-evk.html

Support has just been added for i.MX8M Mini: https://www.qemu.org/docs/master/system/arm/imx8m.html

DDR beginning seen by QEMU is mapped on *0x40000000* address.

Our UART base register is mapped on *0x30860000* address.

Our UART register to transmit (32-bits wide) in mapped on *0x30860040* address.

You can download the toolchain here: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads

## Compiling

### Compiler
```bash
$ ./aarch64-none-elf-gcc -S -mcpu=cortex-a53 -ffreestanding -nostdlib string.c
$ ./aarch64-none-elf-gcc -S -mcpu=cortex-a53 -ffreestanding -nostdlib uart_imx8.c
$ ./aarch64-none-elf-gcc -S -mcpu=cortex-a53 -ffreestanding -nostdlib main.c
 ```

### Assembler
```bash
$ ./aarch64-none-elf-as -mcpu=cortex-a53 -o startup.o startup.s
$ ./aarch64-none-elf-as -mcpu=cortex-a53 -o vectors.o vectors.s
$ ./aarch64-none-elf-as -mcpu=cortex-a53 -o exceptions.o exceptions.s
$ ./aarch64-none-elf-as -mcpu=cortex-a53 -o string.o string.s
$ ./aarch64-none-elf-as -mcpu=cortex-a53 -o uart_imx8.o uart_imx8.s
$ ./aarch64-none-elf-as -mcpu=cortex-a53 -o main.o main.s
```

### Linker
```bash
$ ./aarch64-none-elf-ld -T linker.ld -o hello.elf startup.o vectors.o exceptions.o string.o uart_imx8.o main.o
 ```

### Raw Binary
```bash
$ ./aarch64-none-elf-objcopy -O binary hello.elf hello.bin
```

## Executing our Basic Shell
```bash
$ ./qemu/build/qemu-system-aarch64 -M imx8mp-evk -m 512M -kernel hello.bin -no-reboot -display none -serial stdio -monitor telnet:127.0.0.1:1234,server,nowait
Command> hello
Unknown command
Command> help
Commands:
  help
  uname
Command> uname
[Bare-Metal ARM UART Driver by Pierre GENARD]
Command>
```

## Debugging
```bash
$ telnet localhost 1234
```

## Author
**Pierre GENARD**
