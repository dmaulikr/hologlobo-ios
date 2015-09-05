//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#include "Vectors.h"

#include <stdio.h>
#include <math.h>

/* Some vector algebra... */

Vector3 newVector(double x, double y, double z) {
    Vector3 ret;
    ret.v[0] = x; ret.v[1] = y; ret.v[2] = z;
    return ret;
}

Vector3 sumVector(Vector3 a, Vector3 b) {
    Vector3 c;
    c.v[0] = a.v[0] + b.v[0]; c.v[1] = a.v[1] + b.v[1]; c.v[2] = a.v[2] + b.v[2];
    return c;
}

Vector3 subVector(Vector3 a, Vector3 b) {
    Vector3 c;
    c.v[0] = a.v[0] - b.v[0]; c.v[1] = a.v[1] - b.v[1]; c.v[2] = a.v[2] - b.v[2];
    return c;
}

double dotVector(Vector3 a, Vector3 b) {
    return a.v[0] * b.v[0] + a.v[1] * b.v[1] + a.v[2] * b.v[2];
}

Vector3 crossVector(Vector3 a, Vector3 b) {
    Vector3 c;
    c.v[0] = a.v[1] * b.v[2] - a.v[2] * b.v[1];
    c.v[1] = a.v[2] * b.v[0] - a.v[0] * b.v[2];
    c.v[2] = a.v[0] * b.v[1] - a.v[1] * b.v[0];
    return c;
}

Vector3 scalarVector(double a, Vector3 b) {
    Vector3 c;
    c.v[0] = a * b.v[0]; c.v[1] = a * b.v[1]; c.v[2] = a * b.v[2];
    return c;
}

Vector3 divScalarVector(Vector3 a, double b) {
    Vector3 c;
    if(b == 0)
        b = 0.0001;
    c.v[0] = a.v[0] / b; c.v[1] = a.v[1] / b; c.v[2] = a.v[2] / b;
    return c;
}

double normVector(Vector3 a) {
    return sqrt(dotVector(a, a));
}

Vector3 normalizeVector(Vector3 a) {
    return divScalarVector(a, normVector(a));
}

int equalVector(Vector3 a, Vector3 b) {
    return (a.v[0] == b.v[0]) && (a.v[1] == b.v[1]) && (a.v[2] == b.v[2]);
}

void debugPrintVector(Vector3 a) {
    printf("(%lf, %lf, %lf)", a.v[0], a.v[1], a.v[2]);
}

