#include "decoder.h"

#define WHITE 0
#define BLACK 255
#define MAX_ABS_OFFSET 2

int decoder_init(_decoder *self, int iw, int ih, float rw, float rh, 
        _complex *c, _complex *r) {
	if (self == 0 || c == 0 || r == 0)  //Cant be nulls
		return -1;

	if (iw == 0 || ih == 0) 
		return -1; //Image cant be 0x0 px 
	
	self->imageWidth = iw;
	self->imageHeight = ih;
	self->renderWidth = rw;
	self->renderHeight = rh;
	self->renderCenter = c;
	self->ratio = r;

	return 0;
}

//TODO use uints / check endianess ??

int decoder_decode(_decoder *self, FILE *output) {
	//Concurrency is for poor computers
	float startX, startY, endX, endY, stepX, stepY;

	startX = complex_getX(self->renderCenter) - (self->renderWidth / 2);
	startY = complex_getY(self->renderCenter) - (self->renderHeight / 2);
	endX = complex_getX(self->renderCenter) + (self->renderWidth / 2);
	endY = complex_getY(self->renderCenter) + (self->renderHeight / 2);
	
	stepX = self->renderWidth / self->imageWidth;
	stepY = self->renderHeight / self->imageHeight;

	fprintf(output, "P5\n");
	fprintf(output, "%d %d\n", self->imageWidth, self->imageHeight);
	fprintf(output, "255\n");

	for (float indexY = startY ; indexY < endY ; indexY += stepY) {
		for (float indexX = startX ; indexX < endX ; indexX += stepX) {
			//Here im at 1 px of the image.
			_complex point;
			complex_init(&point, indexX, indexY);

			//Using as N = Black in that image format
			int color = WHITE;
			for (color = WHITE ; 
				color < BLACK || complex_abs(&point) > MAX_ABS_OFFSET ;
					++color) {
				float newX = (complex_getX(&point) * complex_getX(&point) 
						+ complex_getX(self->ratio));
				float newY = (complex_getY(&point) * complex_getY(&point)
						+ complex_getY(self->ratio));

				complex_init(&point, newX, newY);
			}

			//Here we should write the file with counter
			fprintf(output, "%d ", color);		
		}

		fprintf(output, "\n");
	}

	//Here we should close the file
	return 0;
}
