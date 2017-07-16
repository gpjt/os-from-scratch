#include "drivers/screen.h"

void main() {
	clear_screen();
	// print("Welcome to a trivial 32-bit OS\n");
	// print_at("Center", 37, 13);
	print_char('C', 37, 13, WHITE_ON_BLACK);
	print_char('e', -1, -1, WHITE_ON_BLACK);
	print_char('n', -1, -1, WHITE_ON_BLACK);
	print_char('t', -1, -1, WHITE_ON_BLACK);
	print_char('e', -1, -1, WHITE_ON_BLACK);
	print_char('r', -1, -1, WHITE_ON_BLACK);
}
