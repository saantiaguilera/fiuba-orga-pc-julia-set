#ifndef COMPLEX_H_
#define COMPLEX_H_

typedef struct _complex {
    double real;
    double img;
} _complex;

int complex_init(_complex *self, double real, double img);
int complex_add(_complex *self, const _complex *other);
int complex_mult(_complex *self, const _complex *other);
int strtoc(_complex *self, char* str);
double complex_abs(const _complex *self);

double complex_getX(const _complex *self);
double complex_getY(const _complex *self);

#endif
