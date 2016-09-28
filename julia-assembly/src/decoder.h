#ifndef DECODER_H_
#define DECODER_H_

#include <stdio.h>
#include "complex.h"

#define DEFAULT_IMAGE_WIDTH 640
#define DEFAULT_IMAGE_HEIGHT 480
#define DEFAULT_RENDER_WIDTH 4.0
#define DEFAULT_RENDER_HEIGHT 4.0
#define DEFAULT_RENDER_CENTER_X 0.0
#define DEFAULT_RENDER_CENTER_Y 0.0

#define ERROR_PROCESSING_SET 9

/*
Be careful the fractal in the pdf is not generated with the constant given.
This are the constants for generating the pdf fractal. Below are the
pdf constants for easy access if you want to change them
*/
#define DEFAULT_RATIO_X 0.285
#define DEFAULT_RATIO_Y 0.01

/*
PDF Constants
#define DEFAULT_RATIO_X 0.285
#define DEFAULT_RATIO_Y -0.01
*/

typedef struct _decoder {
	int imageWidth, imageHeight;
	double renderWidth, renderHeight;
	_complex *renderCenter;
	_complex *ratio;
} _decoder;

int decoder_init(_decoder *self,
		int imgWidth, int imgHeight,
		double rndWidth, double rndHeight,
		_complex *rndCenter, _complex *ratio);
int decoder_decode(_decoder *self, FILE *output);

#endif
