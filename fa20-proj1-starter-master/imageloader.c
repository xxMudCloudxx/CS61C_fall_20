/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) {
	//YOUR CODE HERE
	FILE *fp = fopen(filename, "r");
	if (fp == NULL) {
		return NULL;
	}
	// Allocate memory for image;
	Image *image = (Image *) malloc(sizeof(Image));
	if (image == NULL) {
		perror("Allocate memory for image ERROR!\n");
		exit(EXIT_FAILURE);
	}
	uint32_t rows, cols, scale;
	char header[3];
	// read the first line of header;
	fscanf(fp, "%2s", header);
	if (header[0] != 'P' || header[1] != '3') {
		perror("read the first line of header ERROR!\n");
	}
	// read width and the height;
	fscanf(fp, "%d %d", &cols, &rows);
	image ->cols = cols;
	image ->rows = rows;
	// read ther scale with colors;
	fscanf(fp, "%d", &scale);
	if (scale != 255) {
		perror("read ther scale with colors ERROR!\n");
		exit(EXIT_FAILURE);
	}
	
	// Allocate memory for colors;
	Color **colors = (Color **) malloc(rows * sizeof(Color *));
	for (int i = 0; i < cols; i++) {
		colors[i] = (Color *) malloc(cols * sizeof(Color));
	}

	// read all pixels in the image;
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j ++) {
			int r, g, b;
			fscanf(fp, "%d %d %d", &r, &g, &b);
			colors[i][j].R = r;
			colors[i][j].G = g;
			colors[i][j].B = b;
		}
	}
	
	image ->image = colors;
	fclose(fp);
	return image;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image) {
	//YOUR CODE HERE
	uint32_t rows, cols;
	// write header, rows, cols and scale;
	rows = image ->rows;
	cols = image ->cols;
	printf("P3\n");
	printf("%d %d\n", rows, cols);
	printf("255\n");
	Color **colors = image ->image;
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			Color color = colors[i][j];
			printf("%3d %3d %3d", color.R, color.G, color.B);
			if (j != rows -1) {
				printf("   ");
			}
		}
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image) {
	//YOUR CODE HERE
	if (image == NULL) {
		return;
	}
	for (int i = 0; i < image ->cols; i++) {
		free(image ->image[i]);
	}
	free(image ->image);
	free(image);
}