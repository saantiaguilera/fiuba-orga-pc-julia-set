#ifndef COMPLEX_H_
#define COMPLEX_H_

typedef struct _complex {
    float real;
    float imaginary;
} _complex;

int complex_init(_complex *self, float real, float imaginary);
int complex_add(_complex *self, _complex *other);
//int complex_sub(_complex *self, _complex *other);
int complex_mult(_complex *self, _complex *other);
//int complex_div(_complex *self, _complex *other);
int strtoc(_complex *self, char* str);

float getX(_complex *self);
float getY(_complex *self);

#endif