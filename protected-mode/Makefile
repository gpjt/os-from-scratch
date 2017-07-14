all: protected-mode.img

protected-mode.img: main.asm print_string.asm gdt.asm print_string_pm.asm switch_to_pm.asm
	nasm main.asm -f bin -o protected-mode.img
