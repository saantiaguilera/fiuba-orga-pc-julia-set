#include <stdlib.h>

#include <stdio.h>
#include "complex.h"
#include "math.h"

int complex_init(_complex *self, double real, double img) {
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
	self->real = strtod(str, &end);
	self->img = strtod(end, &end);
	if (*end != 'i') return 1;
	return 0;
}

double complex_getX(const _complex *self) {
	return self->real;
}

double complex_getY(const _complex *self) {
	return self->img;
}

double complex_abs(const _complex *self) {
	double real = self->real * self->real;
	double img = self->img * self->img;

	return sqrt(real + img);
}
