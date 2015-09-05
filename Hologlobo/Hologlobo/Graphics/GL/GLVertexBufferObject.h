//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

#warning TODO Add normals...

typedef struct {
    GLfloat position[3];
    GLfloat colour[4];
    GLfloat texCoord[2];
} GLVertex;

@interface GLVertexBufferObject : NSObject

@property (nonatomic, readonly) GLVertex * vertices;
@property (nonatomic, readonly) GLuint * indices;

@property (nonatomic, readonly) unsigned nVertices;
@property (nonatomic, readonly) unsigned nIndices;

@property (nonatomic, readonly) GLuint vertexBuffer;
@property (nonatomic, readonly) GLuint indexBuffer;

- (void)bindWithPosition:(GLuint)positionAttrib colour:(GLuint)colourAttrib texCoord:(GLuint)texCoordAttrib;
- (void)draw;

- (void)drawWithPosition:(GLuint)positionAttrib colour:(GLuint)colourAttrib texCoord:(GLuint)texCoordAttrib;

@end

void gloBegin(void);
void gloVertex3f(GLfloat x, GLfloat y, GLfloat z);
void gloVertex2i(GLint x, GLint y);
void gloColor3f(GLfloat r, GLfloat g, GLfloat b);
void gloColor4f(GLfloat r, GLfloat g, GLfloat b, GLfloat a);
void gloTexCoord2i(GLint s, GLint t);
void gloTexCoord2f(GLfloat s, GLfloat t);
GLVertexBufferObject * gloEnd(void);

