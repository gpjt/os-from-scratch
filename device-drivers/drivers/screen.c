#include "kernel/low_level.h"
#include "kernel/util.h"
#include "drivers/screen.h"


/*
	Get the screen offset for col, row
*/
int get_screen_offset(int col, int row) {
	return ((row * 80) + col) * 2;
}


/*
	Get the current cursor position as an offset into video 
	memory by talking to the display device.
*/
int get_cursor() {
	// The device has a number of registers.  We're interested in:
	// register 14: the high byte of the cursor offset
	// register 15: the low byte of the cursor offset
	// The first thing to do is to tell the device which 
	// register we're interested in.  14 first: 
	port_byte_out(REG_SCREEN_CTRL, 14);
	// Then we read it, and (as it's the high byte) shift left by 8
	int offset = port_byte_in(REG_SCREEN_DATA);
	// Now we select 15
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset |= port_byte_in(REG_SCREEN_DATA);
	// This has given us an offset in terms of characters from the
	// top left; we want something in bytes, and there are two
	// bytes per character
	return offset * 2;
}


/* 
	Set the current cursor position by talking to the display device
*/
int set_cursor(int offset) {
	// Convert from bytes offset into video memory to a character 
	// from top left offset (two bytes per character)
	offset /= 2;
	// Similarly to getting the cursor, we want to write the high
	// byte of offset to register 14, then the low byte to register 
	// 15.
	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset & 0xf));
}


/*
	Scroll the whole screen up a line if required, given a current 
	offset into video memory, and returning the new offset.
*/
int handle_scrolling(int offset) {
	if (offset < MAX_ROWS * MAX_COLS * 2) {
		// We're not outside screen memory yet, so no need to 
		// do anything
		return offset;
	} 

	// Row by row, copy all but the first row up one (NB starting at 1)
	for (int row=1; row < MAX_ROWS; row++) {
		memory_copy(
			(char*) (get_screen_offset(0, row) + VIDEO_ADDRESS),
			(char*) (get_screen_offset(0, row + 1) + VIDEO_ADDRESS),
			MAX_COLS * 2
		);
	}

	// Blank the last line by overwriting with zero bytes (not spaces!)
	char* last_line = (char*) (get_screen_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS);
	for (int col=0; col < MAX_COLS * 2; col++) {
		last_line[col] = 0;
	}

	// Move the cursor back one row.
	offset -= 2 * MAX_COLS;

	return offset;
}


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

	if (character == '\n') {
		// It's a newline.  We move to the *end of the current row*,
		// which we get by dividing the current offset (into memory)
		// by the number of bytes per row (twice MAX_ROWS).  After 
		// this if statement, we move on to the next offset -- so 
		// once that's done, we'll be on the first column of the next
		// row.
		int current_row = offset / (2 * MAX_ROWS);
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


/*
	Print a string at a fixed screen location (set col and row to -1)
	for "print at cursor"
*/
void print_at(char* message, int col, int row) {
	// If we're given an offset, then move to it, and clear out
	// col and row (because we'll use the cursor from then on)
	if (col >= 0 && row >= 0) {
		set_cursor(get_screen_offset(col, row));
		col = -1;
		row = -1;
	}
	for (int ii=0; message[ii] != 0; ii++) {
		print_char(message[ii], col, row, WHITE_ON_BLACK);
	}
}


/*
	Print a string at the current cursor position
*/
void print(char* message) {
	print_at(message, -1, -1);
}


/* 
	Clear the screen and reset the cursor
*/
void clear_screen() {
	for (int row=0; row < MAX_ROWS; row++) {
		for (int col=0; col < MAX_COLS; col++) {
			print_char(' ', col, row, WHITE_ON_BLACK);
		}
	}

	set_cursor(get_screen_offset(0, 0));
}

