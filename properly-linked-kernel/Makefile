all: image.img

image.img: boot_sect.bin kernel.bin
	cat boot_sect.bin kernel.bin > image.img

boot_sect.bin: boot_sect.asm print_string.asm disk_load.asm gdt.asm print_string_pm.asm switch_to_pm.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin

kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

kernel.o: kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o

kernel.bin: kernel.o kernel_entry.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary 

clean:
	rm *.o *.bin
