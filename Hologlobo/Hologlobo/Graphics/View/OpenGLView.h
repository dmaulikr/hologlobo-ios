//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <OpenGLES/ES2/gl.h>
#import "RenderingView.h"

#import "GLSLProgram.h"
#import "GLVertexBufferObject.h"
#import "GLTextureCacher.h"
#import "GLWavefrontModel.h"
#include "glMath.h"

#define FOV 90.f

@interface OpenGLView : RenderingView {
    @protected
    EAGLContext * _context;
    glMathContext_t * _mathContext;
    GLSLProgram * _program;
}

- (EAGLContext *)context;

@end
