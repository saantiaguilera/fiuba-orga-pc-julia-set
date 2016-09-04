#ifndef COMPLEX_H_
#define COMPLEX_H_

typedef struct _complex {
    float real;
    float img;
} _complex;

int complex_init(_complex *self, float real, float img);
int complex_add(_complex *self, const _complex *other);
//int complex_sub(_complex *self, _complex *other);
int complex_mult(_complex *self, const _complex *other);
//int complex_div(_complex *self, _complex *other);
int strtoc(_complex *self, char* str);
float complex_abs(const _complex *self);

float complex_getX(const _complex *self);
float complex_getY(const _complex *self);

#endif
