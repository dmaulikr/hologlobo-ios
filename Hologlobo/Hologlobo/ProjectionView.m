//
//  ProjectionView.m
//  Hologlobo
//
//  Created by Fabio Dela Antonio on 9/5/15.
//  Copyright (c) 2015 hologlobo. All rights reserved.
//

#import "ProjectionView.h"

@implementation ProjectionView {
    GLVertexBufferObject * _obj;
    GLWavefrontModel * _model, * _leftDoor, * _rightDoor;
    CGFloat _degrees;
    CGFloat _rotation;
    CGFloat _distance;
}

- (void)prepareForRenderingWithFile:(NSString *)file rotation:(CGFloat)degrees {
    
    [super prepareForRendering];
    
    _distance = 10.f;
    _degrees = degrees;
    
    mglMatrixMode(_mathContext, GL_PROJECTION);
    mglLoadIdentity(_mathContext);
    mgluPerspective(_mathContext, FOV, self.frame.size.width/self.frame.size.height, .1f, 9999.0f);
    
    _model = [[GLWavefrontModel alloc] initWithContentsOfFile:file];
}

- (void)setDistance:(CGFloat)distance {
    
    if(distance < 1.f) {
     
        _distance = 1.f;
    }
    
    else {
        
        _distance = distance;
    }
}

- (void)setRotation:(CGFloat)degrees {
    
    while(degrees < 0.f)
        degrees += 360.f;
    
    while(degrees > 360.f)
        degrees -= 360.f;
    
    _rotation = degrees;
}

- (void)renderFrameWithInterval:(double)interval  {
    
    [super renderFrameWithInterval:interval];
    
    glClearColor(0.f, 0.f, 0.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUniformMatrix4fv([_program getUniform:@"Projection"], 1, 0, glMathGetMatrix(_mathContext, GL_PROJECTION));
    
    mglMatrixMode(_mathContext, GL_MODELVIEW);
    
    mglLoadIdentity(_mathContext);
    mgluLookAtDir(_mathContext,
                  0.f, 0.f, 0.f,
                  0.f, 0.f, -1.f,
                  0.f, 1.f, 0.f);
    
    mglRotatef(_mathContext, _degrees, 0.f, 0.f, 1.f);
    
    mglTranslatef(_mathContext, 0.f, 0.f, -_distance);
    mglRotatef(_mathContext, _degrees + _rotation, 0.f, 1.f, 0.f);
    
    mglScalef(_mathContext, 10.f/_model.magnitude, 10.f/_model.magnitude, 10.f/_model.magnitude);
    mglTranslatef(_mathContext, -(_model.centroid.v[0]), -(_model.centroid.v[1]), -(_model.centroid.v[2]));
    
    glUniformMatrix4fv([_program getUniform:@"Modelview"], 1, 0, glMathGetMatrix(_mathContext, GL_MODELVIEW));
    
    [_model drawWithPosition:[_program getAttribute:@"Position"]
                      colour:[_program getAttribute:@"SourceColor"]
                    texCoord:[_program getAttribute:@"TexCoordIn"]
                     texture:[_program getUniform:@"Texture"]];
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)unload {
    
    [EAGLContext setCurrentContext:self.context];
    [_obj release], _obj = nil;
    [_model release], _model = nil;
    [super unload];
}

@end
