#include "drivers/screen.h"

void main() {
	clear_screen();
	print("First line\n");
	print("Second ");
	print("line\n");
	print_at("Center", 37, 13);
}
