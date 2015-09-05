//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "GLVertexBufferObject.h"

@interface GLVertexObject : NSObject {
@public
    GLfloat _position[3];
    GLfloat _colour[4];
    GLfloat _texCoord[2];
}

- (GLVertex)asVertex;

@end

@implementation GLVertexObject

- (GLVertex)asVertex {
    
    GLVertex ret;
    
    ret.position[0] = _position[0];
    ret.position[1] = _position[1];
    ret.position[2] = _position[2];

    ret.colour[0] = _colour[0];
    ret.colour[1] = _colour[1];
    ret.colour[2] = _colour[2];
    ret.colour[3] = _colour[3];
    
    ret.texCoord[0] = _texCoord[0];
    ret.texCoord[1] = _texCoord[1];
    
    return ret;
}

@end

@implementation GLVertexBufferObject

- (instancetype)initWithGLVertexObjects:(NSArray *)vertices {
    
    if(self = [super init]) {
        
        _nVertices = (unsigned)[vertices count];
        _nIndices = _nVertices;
        
        _vertices = (GLVertex *)calloc(_nVertices, sizeof(GLVertex));
        _indices = (GLuint *)calloc(_nIndices, sizeof(GLuint));
        
        if(_vertices == NULL || _indices == NULL) {
        
            NSLog(@"Could not allocate array for vertices.");
            [self autorelease];
            return nil;
        }
        
        for(unsigned i = 0; i < _nVertices; i++) {
            
            _vertices[i] = [[vertices objectAtIndex:i] asVertex];
            _indices[i] = i;
        }
        
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, _nVertices * sizeof(GLVertex), _vertices, GL_STATIC_DRAW);
        
        glGenBuffers(1, &_indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, _nIndices * sizeof(GLuint), _indices, GL_STATIC_DRAW);
    }
    
    return self;
}

- (void)drawWithPosition:(GLuint)positionAttrib colour:(GLuint)colourAttrib texCoord:(GLuint)texCoordAttrib {
    
    [self bindWithPosition:positionAttrib colour:colourAttrib texCoord:texCoordAttrib];
    [self draw];
}

- (void)bindWithPosition:(GLuint)positionAttrib colour:(GLuint)colourAttrib texCoord:(GLuint)texCoordAttrib {
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(positionAttrib, 3, GL_FLOAT, GL_FALSE, sizeof(GLVertex), 0);
    glVertexAttribPointer(colourAttrib, 4, GL_FLOAT, GL_FALSE, sizeof(GLVertex), (GLvoid *)(sizeof(GLfloat) * 3));
    glVertexAttribPointer(texCoordAttrib, 2, GL_FLOAT, GL_FALSE, sizeof(GLVertex), (GLvoid *)(sizeof(GLfloat) * 7));
}

- (void)draw {
    
    glDrawElements(GL_TRIANGLES, _nIndices, GL_UNSIGNED_INT, 0);
}

- (void)dealloc {
    
    free(_vertices);
    free(_indices);
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    [super dealloc];
}

@end

@interface GLVBOBuilder : NSObject {
    GLfloat _currentColour[4];
    GLfloat _currentTexCoord[2];
}

@property (nonatomic, retain) NSMutableArray * vertices;
@end

@implementation GLVBOBuilder

+ (instancetype)shared {
    
    static GLVBOBuilder * shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)clearContext {
    _currentColour[0] = 0.f;
    _currentColour[1] = 0.f;
    _currentColour[2] = 0.f;
    _currentColour[3] = 0.f;
    
    _currentTexCoord[0] = 0.f;
    _currentTexCoord[1] = 0.f;
}

- (void)begin {

    [self clearContext];
    [_vertices release], _vertices = nil;
    _vertices = [[NSMutableArray alloc] init];
}

- (void)vertex3fx:(GLfloat)x y:(GLfloat)y z:(GLfloat)z {
    
    GLVertexObject * vertex = [[GLVertexObject alloc] init];
    vertex->_position[0] = x;
    vertex->_position[1] = y;
    vertex->_position[2] = z;
    
    vertex->_colour[0] = _currentColour[0];
    vertex->_colour[1] = _currentColour[1];
    vertex->_colour[2] = _currentColour[2];
    vertex->_colour[3] = _currentColour[3];
    
    vertex->_texCoord[0] = _currentTexCoord[0];
    vertex->_texCoord[1] = _currentTexCoord[1];
    
    [_vertices addObject:vertex];
    [vertex release], vertex = nil;
}

- (void)vertex2ix:(GLint)x y:(GLint)y {
    [self vertex3fx:(GLfloat)x y:(GLfloat)y z:0.f];
}

- (void)color4fr:(GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a {
    
    _currentColour[0] = r;
    _currentColour[1] = g;
    _currentColour[2] = b;
    _currentColour[3] = a;
}

- (void)color3fr:(GLfloat)r g:(GLfloat)g b:(GLfloat)b {
    [self color4fr:r g:g b:b a:1.f];
}

- (void)texCoord2fs:(GLfloat)s t:(GLfloat)t {
    
    _currentTexCoord[0] = s;
    _currentTexCoord[1] = t;
}

- (void)texCoord2is:(GLint)s t:(GLint)t {
    [self texCoord2fs:(GLfloat)s t:(GLfloat)t];
}

- (GLVertexBufferObject *)end {
    
    GLVertexBufferObject * vbo = [[[GLVertexBufferObject alloc] initWithGLVertexObjects:_vertices] autorelease];
    
    [_vertices release], _vertices = nil;
    [self clearContext];
    return vbo;
}

- (void)dealloc {
    
    [_vertices release], _vertices = nil;
    [super dealloc];
}

@end

void gloBegin(void) {
    [[GLVBOBuilder shared] begin];
}

void gloVertex3f(GLfloat x, GLfloat y, GLfloat z) {
    [[GLVBOBuilder shared] vertex3fx:x y:y z:z];
}

void gloVertex2i(GLint x, GLint y) {
    [[GLVBOBuilder shared] vertex2ix:x y:y];
}

void gloColor3f(GLfloat r, GLfloat g, GLfloat b) {
    [[GLVBOBuilder shared] color3fr:r g:g b:b];
}

void gloColor4f(GLfloat r, GLfloat g, GLfloat b, GLfloat a) {
    [[GLVBOBuilder shared] color4fr:r g:g b:b a:a];
}

void gloTexCoord2i(GLint s, GLint t) {
    [[GLVBOBuilder shared] texCoord2is:s t:t];
}

void gloTexCoord2f(GLfloat s, GLfloat t) {
    [[GLVBOBuilder shared] texCoord2fs:s t:t];
}

GLVertexBufferObject * gloEnd(void) {
    return [[GLVBOBuilder shared] end];
}

