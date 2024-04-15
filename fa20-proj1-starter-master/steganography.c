/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	if (image == NULL) {
		return NULL;
	}
	Color* color = (Color *) malloc(sizeof(Color));
	uint8_t B_color = image ->image[row][col].B;
	if (B_color % 2 == 1) {
		color ->R = 255;
		color ->B = 255;
		color ->G = 255;
	} else {
		color ->R = 0;
		color ->B = 0;
		color ->G = 0;
	}
	return color;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image) {
	//YOUR CODE HERE
	if (image == NULL) {
		return NULL;
	}
	uint32_t rows = image ->rows;
	uint32_t cols = image ->cols;
	// Allocate the memory of image and colors list;
	Image* image_new = (Image *) malloc(sizeof(Image));
	Color **colors = (Color **) malloc(rows * sizeof(Color *));
	for (int i = 0; i < cols; i++) {
		colors[i] = (Color *) malloc(cols * sizeof(Color));
	}
	// evaluate all pixel;
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			Color* proccessedPixel = evaluateOnePixel(image, i, j);
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
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv) {
	//YOUR CODE HERE
	if (argc < 2) {
		printf("incorrect aruguments num");
		return -1;
	}
	Image* image = readData(argv[1]);
	if (image == NULL) {
		printf("read error");
		return -1;
	}
	Image* processedImage = steganography(image);
	if (processedImage == NULL) {
		printf("process error");
		return -1;
	}
	writeData(processedImage);
	freeImage(image);
	freeImage(processedImage);
	return 0;
}
