all: load-from-disk.img

load-from-disk.img: main.asm disk_load.asm print_string.asm print_hex.asm
	nasm main.asm -f bin -o load-from-disk.img
