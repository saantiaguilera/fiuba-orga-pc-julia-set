#include <stdlib.h>

#include "complex.h"
#include "math.h"

int complex_init(_complex *self, float real, float imaginary) {
    self->real = real;
    self->imaginary = imaginary;
    return 0;
}

int complex_add(_complex *self, const _complex *other) {
    self->real += other->real;
    self->imaginary += other->imaginary;
    return 0; 
}

int complex_mult(_complex *self, const _complex *other) {
    self->real = self->real * other->real - 
        self->imaginary * other->imaginary;
    self->imaginary = self->real * other->imaginary + 
        self->imaginary * other->real;
    return 0;
}

int strtoc(_complex *self, char* str) {
	char* end;
	self->real = strtof(str, &end);
	self->imaginary = strtof(end, NULL);
	return 0;
}

float complex_getX(_complex *self) {
	return self->real;
}

float complex_getY(_complex *self) {
	return self->imaginary;
}

unsigned int complex_abs(const _complex *self) {
	return sqrt(self->real * self->real + self->imaginary * self->imaginary);
}
