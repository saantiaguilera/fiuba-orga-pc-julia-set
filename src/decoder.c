
#include "decoder.h"

#define WHITE 255
#define BLACK 0
#define MAX_ABS_OFFSET 2

int decoder_init(_decoder *self, int iw, int ih, double rw, double rh, 
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

int decoder_decode(_decoder *self, FILE *output) {
	//Concurrency is for poor computers
	double startX, startY, endX, endY, stepX, stepY;

	double halfWidth = self->renderWidth / 2;
	double halfHeight = self->renderHeight /2;
	startX = complex_getX(self->renderCenter) - (halfWidth);
	startY = complex_getY(self->renderCenter) - (halfHeight);
	endX = complex_getX(self->renderCenter) + (halfWidth);
	endY = complex_getY(self->renderCenter) + (halfHeight);
		
	stepX = self->renderWidth / self->imageWidth;
	stepY = self->renderHeight / self->imageHeight;

	fprintf(output, "P5 ");
	fprintf(output, "%d %d ", self->imageWidth, self->imageHeight);
	fprintf(output, "%d\n", WHITE);

	for (double indexY = startY ; indexY < endY ; indexY += stepY) {
		for (double indexX = startX ; indexX < endX ; indexX += stepX) {
			//Here im at 1 px of the image.
			_complex point;
			complex_init(&point, indexX, indexY);

			//Using as N = Black in that image format
			int color;
			for (color = BLACK ; 
				color < WHITE - 1 && complex_abs(&point) <= MAX_ABS_OFFSET ;
					++color) {
				double newX = (complex_getX(&point) * complex_getX(&point)
						- complex_getY(&point) * complex_getY(&point)
						+ complex_getX(self->ratio));
				double newY = (2 * complex_getX(&point) * complex_getY(&point)
						+ complex_getY(self->ratio));
				
				complex_init(&point, newX, newY);
			}

			//Since our color ranges from 0..255, it can be stored in 1 byte (char) according to POSIX
			fwrite((const void *) &color, 1, 1, output);
		}
	}

	return 0;
}
