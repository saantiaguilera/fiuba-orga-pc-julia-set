#include "decoder.h"

int decoder_init(_decoder *self, int iw, int ih, float rw, float rh, _complex *c) {
	if (self == 0 || c == 0)  //Cant be nulls
		return -1;
	
	self->imageWidth = iw;
	self->imageHeight = ih;
	self->renderWidth = rw;
	self->renderHeight = rh;
	self->renderCenter = c;

	return 0;
}

int decoder_decode(_decoder *self, FILE *output) {
	//Concurrency is for poor computers
	float startX, startY, endX, endY, stepX, stepY;
}

int decoder_close(_decoder *self) {
}

