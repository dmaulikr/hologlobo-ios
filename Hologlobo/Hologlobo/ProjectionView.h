//
//  ProjectionView.h
//  Hologlobo
//
//  Created by Fabio Dela Antonio on 9/5/15.
//  Copyright (c) 2015 hologlobo. All rights reserved.
//

#import "OpenGLView.h"

@interface ProjectionView : OpenGLView

- (void)prepareForRenderingWithRotation:(CGFloat)degrees;

@end
