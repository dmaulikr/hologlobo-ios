//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "glMath.h"

#define IDENTITY_MATRIX {1.f, 0.f, 0.f, 0.f, 0.f, 1.f, 0.f, 0.f, 0.f, 0.f, 1.f, 0.f, 0.f, 0.f, 0.f, 1.f}
#define EMPTY_MATRIX {0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f, 0.f}

#ifndef M_PI
    #define M_PI 3.14159265358979323846
#endif

#ifndef DEG2RAD
    #define DEG2RAD (M_PI/180.0f)
#endif

#define GL_STATIC_STACK_SIZE 128

#pragma mark - Init/Dealloc

glMathContext_t * glMathAlloc(void) {
    
    return (glMathContext_t *)malloc(sizeof(glMathContext_t));
}

glMathContext_t * glMathInit(glMathContext_t * context) {
    
    if(context != NULL) {
    
#ifdef GL_MATH_DYNAMIC_STACK
        context->glMathMatrixStack = NULL;
#else
        context->glMathMatrixStack = (glMathStackNode_t *)malloc(GL_STATIC_STACK_SIZE * sizeof(glMathStackNode_t));
        
        if(context->glMathMatrixStack == NULL) {
            
            free(context);
            return NULL;
        }
        
        context->glMathMatrixStackHead = 0;
#endif
        
        mglMatrixMode(context, GL_MODELVIEW);
        mglLoadIdentity(context);
        
        mglMatrixMode(context, GL_PROJECTION);
        mglLoadIdentity(context);
        
        context->glMathInitialized = 1;
    }
    
    return context;
}

glMathContext_t * glMathNewContext(void) {
    
    return glMathInit(glMathAlloc());
}

void glMathRelease(glMathContext_t * context) {
    
    if(context != NULL && context->glMathInitialized) {
    
#ifdef GL_MATH_DYNAMIC_STACK
        while(context->glMathMatrixStack != NULL) {
            
            glMathStackNode_t * aux = context->glMathMatrixStack;
            context->glMathMatrixStack = aux->next;
            free(aux);
        }
#else
        free(context->glMathMatrixStack);
#endif
        
        context->glMathInitialized = 0;
    }
    
    if(context != NULL) {
        
        free(context);
    }
}

#pragma mark - Auxiliary

void _glMathAssert(int condition) {
    
    if(!condition) {
        exit(1);
    }
}

#ifndef _UNSAFE_GL_MATH_
#define glMathAssert(X) _glMathAssert(X)
#else
#define glMathAssert(X) 
#endif

#pragma mark - Matrix getter

GLfloat * glMathGetMatrix(glMathContext_t * context, glMathMatrixMode_t mode) {
    glMathAssert(context != NULL);
    
    return context->glMathMatrix[mode];
}

#pragma mark - Internal functions

void glMathCopyMatrix(GLfloat * dest, GLfloat * src) {
    
    memcpy(dest, src, 16 * sizeof(GLfloat));
}

void glMathMultMatrix(GLfloat * dest, GLfloat * src1, GLfloat * src2) {
    
    GLfloat m[16];
    GLfloat * m1 = src1, * m2 = src2;
    
	m[0] = m1[0] * m2[0] + m1[4] * m2[1] + m1[8] * m2[2] + m1[12] * m2[3];
	m[1] = m1[1] * m2[0] + m1[5] * m2[1] + m1[9] * m2[2] + m1[13] * m2[3];
	m[2] = m1[2] * m2[0] + m1[6] * m2[1] + m1[10] * m2[2] + m1[14] * m2[3];
	m[3] = m1[3] * m2[0] + m1[7] * m2[1] + m1[11] * m2[2] + m1[15] * m2[3];
	
	m[4] = m1[0] * m2[4] + m1[4] * m2[5] + m1[8] * m2[6] + m1[12] * m2[7];
	m[5] = m1[1] * m2[4] + m1[5] * m2[5] + m1[9] * m2[6] + m1[13] * m2[7];
	m[6] = m1[2] * m2[4] + m1[6] * m2[5] + m1[10] * m2[6] + m1[14] * m2[7];
	m[7] = m1[3] * m2[4] + m1[7] * m2[5] + m1[11] * m2[6] + m1[15] * m2[7];
	
	m[8] = m1[0] * m2[8] + m1[4] * m2[9] + m1[8] * m2[10] + m1[12] * m2[11];
	m[9] = m1[1] * m2[8] + m1[5] * m2[9] + m1[9] * m2[10] + m1[13] * m2[11];
	m[10] = m1[2] * m2[8] + m1[6] * m2[9] + m1[10] * m2[10] + m1[14] * m2[11];
	m[11] = m1[3] * m2[8] + m1[7] * m2[9] + m1[11] * m2[10] + m1[15] * m2[11];
	
	m[12] = m1[0] * m2[12] + m1[4] * m2[13] + m1[8] * m2[14] + m1[12] * m2[15];
	m[13] = m1[1] * m2[12] + m1[5] * m2[13] + m1[9] * m2[14] + m1[13] * m2[15];
	m[14] = m1[2] * m2[12] + m1[6] * m2[13] + m1[10] * m2[14] + m1[14] * m2[15];
	m[15] = m1[3] * m2[12] + m1[7] * m2[13] + m1[11] * m2[14] + m1[15] * m2[15];
    
    glMathCopyMatrix(dest, m);
}

void glMathPushMatrix(glMathContext_t * context, GLfloat * m) {
    glMathAssert(context != NULL);
    
#ifdef GL_MATH_DYNAMIC_STACK
    glMathStackNode_t * aux;
    
    if((aux = (glMathStackNode_t *)malloc(sizeof(glMathStackNode_t))) == NULL)
        exit(1);
    
    glMathCopyMatrix(aux->matrix, m);
    
    aux->next = context->glMathMatrixStack;
    context->glMathMatrixStack = aux;

#else
    
    glMathCopyMatrix(context->glMathMatrixStack[context->glMathMatrixStackHead], m);
    context->glMathMatrixStackHead++;
    
    if(context->glMathMatrixStackHead > GL_STATIC_STACK_SIZE) {
        
        fprintf(stderr, "glMath: Stack Overflow!\n");
        return;
    }
    
#endif
}

void glMathPopMatrix(glMathContext_t * context) {
    glMathAssert(context != NULL);
    
#ifdef GL_MATH_DYNAMIC_STACK
    glMathStackNode_t * aux = context->glMathMatrixStack;
    
    if(aux == NULL)
        return;
    
    glMathCopyMatrix(context->glMathMatrix[context->glMathMatrixMode], aux->matrix);
    
    context->glMathMatrixStack = aux->next;
    free(aux);

#else
    
    context->glMathMatrixStackHead--;
    
    if(context->glMathMatrixStackHead < 0) {
        
        fprintf(stderr, "glMath: Stack Underflow!\n");
        return;
    }
    
    glMathCopyMatrix(context->glMathMatrix[context->glMathMatrixMode], context->glMathMatrixStack[context->glMathMatrixStackHead]);
#endif
}

void glMathNormVector3(GLfloat * dest, GLfloat * src) {
    
    GLfloat norm = sqrt(src[0] * src[0] + src[1] * src[1] + src[2] * src[2]);
    dest[0] = src[0]/norm; dest[1] = src[1]/norm; dest[2] = src[2]/norm;
}

void glMathCrossVector3(GLfloat * dest, GLfloat * src1, GLfloat * src2) {
    
    GLfloat ret[3];
    register int i;
    
    ret[0] = src1[1] * src2[2] - src1[2] * src2[1];
    ret[1] = src1[2] * src2[0] - src1[0] * src2[2];
    ret[2] = src1[0] * src2[1] - src1[1] * src2[0];
    
    for(i = 0; i < 3; i++)
        dest[i] = ret[i];
}

#pragma mark - External functions

void mglMatrixMode(glMathContext_t * context, glMathMatrixMode_t mode) {
    glMathAssert(context != NULL);
    
    if(mode == GL_MODELVIEW || mode == GL_PROJECTION)
        context->glMathMatrixMode = mode;
}

void mglMultMatrixf(glMathContext_t * context, GLfloat * m) {
    glMathAssert(context != NULL);
    
    glMathMultMatrix(context->glMathMatrix[context->glMathMatrixMode], context->glMathMatrix[context->glMathMatrixMode], m);
}

void mglLoadMatrixf(glMathContext_t * context, GLfloat * m) {
    glMathAssert(context != NULL);
    
    glMathCopyMatrix(context->glMathMatrix[context->glMathMatrixMode], m);
}

void mglLoadIdentity(glMathContext_t * context) {
    glMathAssert(context != NULL);
    
    GLfloat m[16] = IDENTITY_MATRIX;
    mglLoadMatrixf(context, m);
}

void mglPushMatrix(glMathContext_t * context) {
    glMathAssert(context != NULL);
    
    glMathPushMatrix(context, context->glMathMatrix[context->glMathMatrixMode]);
}

void mglPopMatrix(glMathContext_t * context) {
    glMathAssert(context != NULL);
    
    glMathPopMatrix(context);
}

void mglOrtho(glMathContext_t * context, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat zNear, GLfloat zFar) {
    glMathAssert(context != NULL);
    
    GLfloat tx = -(right + left)/(right - left);
    GLfloat ty = -(top + bottom)/(top - bottom);
    GLfloat tz = -(zFar + zNear)/(zFar - zNear);
    
    GLfloat m[16] = EMPTY_MATRIX;
    
    m[0] = 2.0/(right - left);
    m[5] = 2.0/(top - bottom);
    m[10] = -2.0/(zFar - zNear);
    m[12] = tx;
    m[13] = ty;
    m[14] = tz;
    m[15] = 1.0;
    
    mglMultMatrixf(context, m);
}

void mgluOrtho2D(glMathContext_t * context, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top) {
    glMathAssert(context != NULL);
    
    mglOrtho(context, left, right, bottom, top, -1.0, 1.0);
}

void mglFrustum(glMathContext_t * context, GLfloat left, GLfloat right, GLfloat bottom, GLfloat top, GLfloat zNear, GLfloat zFar) {
    glMathAssert(context != NULL);
    
    GLfloat A = (right + left)/(right - left);
    GLfloat B = (top + bottom)/(top - bottom);
    GLfloat C = -(zFar + zNear)/(zFar - zNear);
    GLfloat D = -(2.0 * zFar * zNear)/(zFar - zNear);
    
    GLfloat m[16] = EMPTY_MATRIX;
    
    m[0] = (2.0 * zNear)/(right - left);
    m[5] = (2.0 * zNear)/(top - bottom);
    m[8] = A;
    m[9] = B;
    m[10] = C;
    m[11] = -1.0;
    m[14] = D;
    
    mglMultMatrixf(context, m);
}

void mgluPerspective(glMathContext_t * context, GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar) {
    glMathAssert(context != NULL);
    
    GLfloat aux = tan((fovy/2.0) * DEG2RAD);
    GLfloat top = zNear * aux;
    GLfloat bottom = -top;
    GLfloat right = zNear * aspect * aux;
    GLfloat left = -right;
    
    mglFrustum(context, left, right, bottom, top, zNear, zFar);
}

void mglRotatef(glMathContext_t * context, GLfloat angle, GLfloat x, GLfloat y, GLfloat z) {
    glMathAssert(context != NULL);
    
    GLfloat c = cosf(DEG2RAD * angle), s = sinf(DEG2RAD * angle);
    GLfloat nx, ny, nz, norm;
    
    norm = sqrt(x*x + y*y + z*z);
    
    if(norm == 0.f)
        return;
    
    nx = x/norm;
    ny = y/norm;
    nz = z/norm;
    
    GLfloat m[16] = EMPTY_MATRIX;
    
    m[0] = nx*nx*(1.0 - c) + c;
    m[1] = ny*nx*(1.0 - c) + nz*s;
    m[2] = nx*nz*(1.0 - c) - ny*s;
    m[4] = nx*ny*(1.0 - c) - nz*s;
    m[5] = ny*ny*(1.0 - c) + c;
    m[6] = ny*nz*(1.0 - c) + nx*s;
    m[8] = nx*nz*(1.0 - c) + ny*s;
    m[9] = ny*nz*(1.0 - c) - nx*s;
    m[10] = nz*nz*(1.0 - c) + c;
    m[15] = 1.0;
    
    mglMultMatrixf(context, m);
}

void mglTranslatef(glMathContext_t * context, GLfloat x, GLfloat y, GLfloat z) {
    glMathAssert(context != NULL);
    
    GLfloat m[16] = EMPTY_MATRIX;
    
    m[0] = 1.0;
    m[5] = 1.0;
    m[10] = 1.0;
    m[12] = x;
    m[13] = y;
    m[14] = z;
    m[15] = 1.0;
    
    mglMultMatrixf(context, m);
}

void mglScalef(glMathContext_t * context, GLfloat x, GLfloat y, GLfloat z) {
    glMathAssert(context != NULL);
    
    GLfloat m[16] = EMPTY_MATRIX;
    
    m[0] = x;
    m[5] = y;
    m[10] = z;
    m[15] = 1.0;
    
    mglMultMatrixf(context, m);
}

void mgluLookAt(glMathContext_t * context, GLfloat eyeX, GLfloat eyeY, GLfloat eyeZ, GLfloat centerX, GLfloat centerY, GLfloat centerZ, GLfloat upX, GLfloat upY, GLfloat upZ) {
    glMathAssert(context != NULL);
    
    GLfloat dir[3] = {centerX - eyeX, centerY - eyeY, centerZ - eyeZ}, up[3] = {upX, upY, upZ};
    GLfloat n[3], u[3], v[3];
    
    glMathNormVector3(n, dir);
    
    glMathCrossVector3(u, n, up);
    glMathNormVector3(u, u);
    
    glMathCrossVector3(v, u, n);
    
    GLfloat m[16] = EMPTY_MATRIX;
    
    m[0] = u[0];
    m[1] = v[0];
    m[2] = -n[0];
    
    m[4] = u[1];
    m[5] = v[1];
    m[6] = -n[1];
    
    m[8] = u[2];
    m[9] = v[2];
    m[10] = -n[2];
    
    m[15] = 1.0;
    
    mglMultMatrixf(context, m);
    mglTranslatef(context, -eyeX, -eyeY, -eyeZ);
}

void mgluLookAtDir(glMathContext_t * context, GLfloat eyeX, GLfloat eyeY, GLfloat eyeZ, GLfloat dirX, GLfloat dirY, GLfloat dirZ, GLfloat upX, GLfloat upY, GLfloat upZ) {
    glMathAssert(context != NULL);
    
    GLfloat dir[3] = {dirX, dirY, dirZ}, up[3] = {upX, upY, upZ};
    GLfloat n[3], u[3], v[3];
    
    glMathNormVector3(n, dir);
    
    glMathCrossVector3(u, n, up);
    glMathNormVector3(u, u);
    
    glMathCrossVector3(v, u, n);
    
    GLfloat m[16] = EMPTY_MATRIX;
    
    m[0] = u[0];
    m[1] = v[0];
    m[2] = -n[0];
    
    m[4] = u[1];
    m[5] = v[1];
    m[6] = -n[1];
    
    m[8] = u[2];
    m[9] = v[2];
    m[10] = -n[2];
    
    m[15] = 1.0;
    
    mglMultMatrixf(context, m);
    mglTranslatef(context, -eyeX, -eyeY, -eyeZ);
}
