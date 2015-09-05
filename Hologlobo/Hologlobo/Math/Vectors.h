//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#ifndef _Vectors_h
#define _Vectors_h

typedef struct {
    double v[3];
} Vector3;

Vector3 newVector(double, double, double);
Vector3 sumVector(Vector3, Vector3);
Vector3 subVector(Vector3, Vector3);
double dotVector(Vector3, Vector3);
Vector3 crossVector(Vector3, Vector3);
Vector3 scalarVector(double, Vector3);
Vector3 divScalarVector(Vector3, double);
double normVector(Vector3);
Vector3 normalizeVector(Vector3);
int equalVector(Vector3, Vector3);
void debugPrintVector(Vector3);

#endif
