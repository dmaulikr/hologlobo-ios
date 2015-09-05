//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#ifndef _glMath_h
#define _glMath_h

typedef float GLfloat;

/* Matrices */
typedef enum {
    GL_MODELVIEW = 0,
    GL_PROJECTION
} glMathMatrixMode_t;

#ifdef GL_MATH_DYNAMIC_STACK
typedef struct matrixStackNode {
    GLfloat matrix[16];
    struct matrixStackNode * next;
} glMathStackNode_t;
#else
typedef GLfloat glMathStackNode_t[16];
#endif

typedef struct {
    
    /* Matrices */
    GLfloat glMathMatrix[2][16];
    glMathStackNode_t * glMathMatrixStack;
#ifndef GL_MATH_DYNAMIC_STACK
    int glMathMatrixStackHead;
#endif
    
    /* State */
    glMathMatrixMode_t glMathMatrixMode;
    int glMathInitialized;
    
} glMathContext_t;

glMathContext_t * glMathAlloc(void);
glMathContext_t * glMathInit(glMathContext_t * context);
glMathContext_t * glMathNewContext(void);
void glMathRelease(glMathContext_t * context);

GLfloat * glMathGetMatrix(glMathContext_t * context, glMathMatrixMode_t mode);

void mglMatrixMode(glMathContext_t * context, glMathMatrixMode_t mode);
void mglMultMatrixf(glMathContext_t * context, GLfloat * m);
void mglLoadMatrixf(glMathContext_t * context, GLfloat * m);
void mglLoadIdentity(glMathContext_t * context);

void mglPushMatrix(glMathContext_t * context);
void mglPopMatrix(glMathContext_t * context);

/* Projection */

void mglOrtho(glMathContext_t * context, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat zNear, GLfloat zFar);
void mgluOrtho2D(glMathContext_t * context, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top);
void mglFrustum(glMathContext_t * context, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat zNear, GLfloat zFar);
void mgluPerspective(glMathContext_t * context, GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar);

/* Modelview */

void mglRotatef(glMathContext_t * context, GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
void mglTranslatef(glMathContext_t * context, GLfloat x, GLfloat y, GLfloat z);
void mglScalef(glMathContext_t * context, GLfloat x, GLfloat y, GLfloat z);
void mgluLookAt(glMathContext_t * context, GLfloat eyeX, GLfloat eyeY, GLfloat eyeZ, GLfloat centerX, GLfloat centerY, GLfloat centerZ, GLfloat upX, GLfloat upY, GLfloat upZ);
void mgluLookAtDir(glMathContext_t * context, GLfloat eyeX, GLfloat eyeY, GLfloat eyeZ, GLfloat dirX, GLfloat dirY, GLfloat dirZ, GLfloat upX, GLfloat upY, GLfloat upZ);

#endif
