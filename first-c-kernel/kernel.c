void main() {
	// Create a char* pointing to the first text cell of video memory
	char* video_memory = (char *) 0xb8000;
	// Write an "X" -- NB no colour flags
	*video_memory = 'X';
}