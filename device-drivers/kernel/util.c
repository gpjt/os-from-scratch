/*
	Copy num_bytes from source to dest.
*/
void memory_copy(char* source, char* dest, int num_bytes) {
	for (int ii=0; ii < num_bytes; ii++) {
		dest[ii] = source[ii];
	}
}
