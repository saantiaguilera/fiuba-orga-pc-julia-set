#include <stdlib.h>

#include <stdio.h>
#include "complex.h"
#include "math.h"

int complex_init(_complex *self, float real, float img) {
    self->real = real;
    self->img = img;
    return 0;
}

int complex_add(_complex *self, const _complex *other) {
    self->real += other->real;
    self->img += other->img;
    return 0; 
}

int complex_mult(_complex *self, const _complex *other) {
    self->real = self->real * other->real - 
        self->img * other->img;
    self->img = self->real * other->img + 
        self->img * other->real;
    return 0;
}

int strtoc(_complex *self, char* str) {
	char* end;
	self->real = strtof(str, &end);
	self->img = strtof(end, &end);
	if (*end != 'i') return 1;
	return 0;
}

float complex_getX(const _complex *self) {
	return self->real;
}

float complex_getY(const _complex *self) {
	return self->img;
}

float complex_abs(const _complex *self) {
	float real = self->real * self->real;
	float img = self->img * self->img;

	return sqrt(real + img);
}
