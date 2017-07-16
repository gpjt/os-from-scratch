#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

// Screen device attribute for our desired color scheme
#define WHITE_ON_BLACK 0x0f

// Screen device I/O ports
#define REG_SCREEN_CTRL	0x3d4
#define REG_SCREEN_DATA 0x3d5


void clear_screen();
void print(char* message);
void print_at(char* message, int col, int row);
void print_char(char character, int col, int row, int attribute_byte);
