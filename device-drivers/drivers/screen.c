/* 
	Print a character on the screen at row, col (or pass in 
 	-1 for cursor position)
 */
void print_char(char character, int col, int row, int attribute_byte) {
	unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;

	if (attribute_byte == 0) {
		attribute_byte = WHITE_ON_BLACK;
	}

	int offset;
	if (col >= 0 && row >= 0) {
		offset = get_screen_offset(col, row);
	} else {
		offset = get_cursor();
	}

	if (character == "\n") {
		// It's a newline.  We move to the *end of the current row*,
		// which we get by dividing the current offset (into memory)
		// by the number of bytes per row (twice MAX_ROWS).  After 
		// this if statement, we move on to the next offset -- so 
		// once that's done, we'll be on the first column of the next
		// row.
		int current_row = offet / (2 * MAX_ROWS);
		offset = get_screen_offset(79, current_row);
	} else {
		vidmem[offset] = character;
		vidmem[offset + 1] = attribute_byte;
	}

	// On to the next character
	offset += 2;

	// Make the appropriate adjustments when we reach the bottom of 
	// the screen -- move everything up a line, basically.
	offset = handle_scrolling(offset);

	// Update the (visible!) cursor position.
	set_cursor(offset);
}
