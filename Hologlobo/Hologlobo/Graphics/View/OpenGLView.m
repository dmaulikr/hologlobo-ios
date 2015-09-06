//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "OpenGLView.h"

@implementation OpenGLView {
    
    CAEAGLLayer * _eaglLayer;
    
    GLuint _frameBuffer;
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    
    double scale;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)dealloc {
    
    [self unload];
    [super dealloc];
}

//- (void)setFrame:(CGRect)frame {
//    
//    [super setFrame:frame];
//    [self unload];
//    [self prepareForRendering];
//}

#pragma mark - Open GL

- (void)setupLayer {
    
#ifdef RETINA_SCALE
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) {
        
        scale = [[UIScreen mainScreen] scale];
        self.contentScaleFactor = scale;
    }
    
    else {
        
        scale = 1.0;
    }
#else
    scale = 1.0;
#endif
    
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @YES,
                                      kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGB565};
}

- (void)setupContext {
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, scale * self.frame.size.width, scale * self.frame.size.height);
}

- (void)setupFrameBuffer {
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (void)compileShaders {
    
    _program = [[GLSLProgram programWithVertexShader:@"SimpleVertex" fragmentShader:@"SimpleFragment"] retain];
    [_program use];
    [_program enableVertexAttribArrayFor:@"Position"];
    [_program enableVertexAttribArrayFor:@"SourceColor"];
    [_program enableVertexAttribArrayFor:@"TexCoordIn"];
}

#pragma mark - Rendering View

- (void)prepareForRendering {
    
    [EAGLContext setCurrentContext:_context];
    [super prepareForRendering];
    
    [self setupLayer];
    [self setupContext];
    [self setupDepthBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self compileShaders];
    
    _mathContext = glMathInit(glMathAlloc());
    
    glEnable(GL_DEPTH_TEST);
    glViewport(0, 0, scale * self.frame.size.width, scale  * self.frame.size.height);
}

- (void)renderFrameWithInterval:(double)interval {
    
    [EAGLContext setCurrentContext:_context];
    
    [super renderFrameWithInterval:interval];
    
    glBindBuffer (GL_ARRAY_BUFFER, 0);
    glFlush();
}

- (EAGLContext *)context {
    return _context;
}

- (void)unload {
 
    [EAGLContext setCurrentContext:_context];
    
    glMathRelease(_mathContext);
    [_program unload];
    [_program release], _program = nil;
    
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    glDeleteRenderbuffers(1, &_depthRenderBuffer);
    glDeleteFramebuffers(1, &_frameBuffer);
    
    [EAGLContext setCurrentContext:nil];
    [_context release], _context = nil;
    
    [super unload];
}

@end
