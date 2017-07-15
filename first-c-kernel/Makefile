all: image.img

image.img: boot_sect.bin kernel.bin
	cat boot_sect.bin kernel.bin > image.img

boot_sect.bin: boot_sect.asm print_string.asm disk_load.asm gdt.asm print_string_pm.asm switch_to_pm.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin

kernel.o: kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o

kernel.bin: kernel.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 --oformat binary kernel.o


clean:
	rm *.o *.bin
