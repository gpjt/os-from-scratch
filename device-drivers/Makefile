C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard  kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}

all: image.img

image.img: boot/boot_sect.bin kernel.bin
	cat $^ > $@

kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary 

boot/boot_sect.bin: boot/boot_sect.asm boot/print_string.asm boot/disk_load.asm boot/gdt.asm boot/print_string_pm.asm boot/switch_to_pm.asm
	nasm -i boot/ boot/boot_sect.asm -f bin -o boot/boot_sect.bin

kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm kernel/kernel_entry.asm -f elf -o kernel/kernel_entry.o

%.o: %.c ${HEADERS}
	gcc -m32 -ffreestanding -I. -c $< -o $@

clean:
	rm -fr *.o *.bin *.img
	rm -fr kernel/*.o boot/*.bin drivers/*.o
