#include <stdio.h>
#include <stdlib.h>

typedef struct {
	float UL_re;
	float UL_im;
	float LR_re;
	float LR_im;
	float d_re;
	float d_im;
	float cp_re;
	float cp_im;

	size_t x_res;
	size_t y_res;
	size_t shades;

	int fd;
} param_t;
