/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

int minus_one(int current, int size) {
	if (current != 0) {
		return current - 1;
	}else {
		return size - 1;
	}
}

int push_one(int current, int size) {
	if (current != size - 1) {
		return current + 1;
	}else {
		return 0;
	}
}

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	if (image == NULL) {
		return NULL;
	}
	Color* color = (Color *) malloc(sizeof(Color));
	char binary_string[19];
	ltoa(rule, binary_string, 2);
	uint8_t R_color = image ->image[row][col].R;
	uint8_t G_color = image ->image[row][col].G;
	uint8_t B_color = image ->image[row][col].B;
	int live;
	if (R_color != 0 && G_color != 0 && B_color != 0) {
		live = 1;
	} else {
		live = 0;
	}
	// search the neighbours living, and then sum up how much;
	// record the live one;
	// live == 1 and live == 0 have diff result;
	// the live one gone;
	
	return color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	//YOUR CODE HERE
	if (image == NULL) {
		return NULL;
	}
	uint32_t rows = image ->rows;
	uint32_t cols = image ->cols;
	// Allocate the memory of image and colors list;
	Image* image_new = (Image *) malloc(sizeof(Image));
	Color **colors = (Color **) malloc(rows * sizeof(Color *));
	if (colors == NULL) {
		perror("Allocate memory for color ERROR!\n");
		exit(EXIT_FAILURE);
	}
	for (int i = 0; i < cols; i++) {
		colors[i] = (Color *) malloc(cols * sizeof(Color));
	}
	// evaluate all pixel;
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			Color* proccessedPixel = evaluateOnePixel(image, i, j, rule);
			colors[i][j] = *proccessedPixel;
			free(proccessedPixel);
		}
	}
	image_new ->cols = cols;
	image_new ->rows = rows;
	image_new ->image = colors;
	return image_new;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	if (argc < 2) {
		printf("usage: ./gameOfLife filename rule\n");
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");
		return -1;
	}
	// get the file name
    char *filename = argv[1];

    // check if end with ".ppm"
    int len = strlen(filename);
    if (len < 4 || strcmp(filename + len - 4, ".ppm") != 0) {
        printf("Error: %s is not a valid PPM filename.\n", filename);
        return -1;
    }

	// check if arg[1] is exadecimal number;

	// get input game rule;
    char *input = argv[1];
	char* endptr;
	long int num = strtol(input, &endptr, 16);
	if (endptr == input || *endptr != '\0') {
		printf("rule should be a hex number.");
		return -1;
	}


}
