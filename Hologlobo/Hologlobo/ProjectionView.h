//
//  ProjectionView.h
//  Hologlobo
//
//  Created by Fabio Dela Antonio on 9/5/15.
//  Copyright (c) 2015 hologlobo. All rights reserved.
//

#import "OpenGLView.h"

@interface ProjectionView : OpenGLView

- (void)setDistance:(CGFloat)distance;
- (void)setRotation:(CGFloat)degrees;

- (void)prepareForRenderingWithFile:(NSString *)file rotation:(CGFloat)degrees;

@end
