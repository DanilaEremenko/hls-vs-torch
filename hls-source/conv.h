#ifndef LAB4_1_IO_H_
#define LAB4_1_IO_H_
#include <stdlib.h>
#define EXPANDED_HEIGHT 192
#define EXPANDED_WIDTH 354
#define TARGET_HEIGHT EXPANDED_HEIGHT - 2
#define TARGET_WIDTH EXPANDED_WIDTH - 2
#define CONV_SIZE 3
#define BATCH_SIZE 16
typedef float data_sc;
void conv(
	data_sc input_img[EXPANDED_HEIGHT][EXPANDED_WIDTH],
	data_sc output_img[TARGET_HEIGHT][TARGET_WIDTH],
	data_sc conv_matrix[CONV_SIZE][CONV_SIZE]);

#endif
