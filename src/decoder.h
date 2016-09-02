#ifndef DECODER_H_
#define DECODER_H_

#include <file>
#include "complex.h"

#define DEFAULT_IMAGE_WIDTH 640
#define DEFAULT_IMAGE_HEIGHT 480
#define DEFAULT_RENDER_WIDTH 4.0
#define DEFAULT_RENDER_HEIGHT 4.0
#define DEFAULT_RENDER_CENTER_X 0.0
#define DEFAULT_RENDER_CENTER_Y 0.0

#define DEFAULT_RATIO_X 0.285
#define DEFAULT_RAITO_Y -0.01

typedef struct _decoder {
	int imageWidth, imageHeight;
	float renderWidth, renderHeight;
	_complex renderCenter;
} _decoder;

int decoder_init(_decoder *self,
					int iw = PGM_WIDTH, int ih = PGM_HEIGHT,
					float rw = CMPLEX_RECT_SIDE, float rh = COMPLEX_RECT_SIDE,
					_complex *rc = 0);
int decoder_decode(FILE *output);
int decoder_close();

#endif
