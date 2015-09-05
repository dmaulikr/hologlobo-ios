//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GLTextureCacher.h"
#import "GLVertexBufferObject.h"
#include "Vectors.h"

#warning TODO Add materials, etc...

@interface GLWavefrontFace : NSObject

@property (nonatomic, retain) GLVertexBufferObject * object;
@property (nonatomic) GLuint faceTexture;

- (BOOL)hasTexture;

@end

@interface GLWavefrontModel : NSObject

@property (nonatomic, retain) NSArray * objects; // of GLWavefrontFace
@property (nonatomic) GLuint globalTexture;
@property (nonatomic) Vector3 centroid;
@property (nonatomic) GLfloat magnitude;

- (instancetype)initWithContentsOfFile:(NSString *)file;
- (instancetype)initWithContentsOfFile:(NSString *)file texture:(NSString *)texture;
- (BOOL)hasGlobalTexture;
- (void)drawWithPosition:(GLuint)positionAttrib colour:(GLuint)colourAttrib texCoord:(GLuint)texCoordAttrib texture:(GLuint)textureUniform;

@end
