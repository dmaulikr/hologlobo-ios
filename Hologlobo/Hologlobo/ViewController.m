//
//  ViewController.m
//  Hologlobo
//
//  Created by Fabio Dela Antonio on 9/5/15.
//  Copyright (c) 2015 hologlobo. All rights reserved.
//

#import "ViewController.h"
#import "ProjectionView.h"

@interface ViewController () {
    unsigned _i;
}

@property (retain, nonatomic) IBOutlet ProjectionView * projectionView;
@property (retain, nonatomic) IBOutlet ProjectionView * rightView;
@property (retain, nonatomic) IBOutlet ProjectionView * bottomView;
@property (retain, nonatomic) IBOutlet ProjectionView * leftView;

@property (retain, nonatomic) CADisplayLink * displayLink;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _displayLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop:)] retain];
    _displayLink.frameInterval = 1; /* ~ 60 fps */
    
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self prepareForRendering];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.projectionView unload];
    [self.rightView unload];
    [self.bottomView unload];
    [self.leftView unload];
}

- (void)prepareForRendering {
    
    [self.projectionView prepareForRenderingWithRotation:0.f];
    [self.leftView prepareForRenderingWithRotation:90.f];
    [self.bottomView prepareForRenderingWithRotation:180.f];
    [self.rightView prepareForRenderingWithRotation:270.f];
}

- (void)gameLoop:(CADisplayLink *)link {
    
    double timeDiff = link.duration;
    
    if(_i == 0)
        [self.projectionView renderFrameWithInterval:timeDiff];
    
    else if(_i == 1)
        [self.rightView renderFrameWithInterval:timeDiff];
   
    else if(_i == 2)
        [self.bottomView renderFrameWithInterval:timeDiff];
    
    else if(_i == 3)
        [self.leftView renderFrameWithInterval:timeDiff];
    
    _i = (_i + 1) % 4;
}

- (void)dealloc {
    
    [_displayLink setPaused:YES];
    [_displayLink invalidate];
    [_displayLink release], _displayLink = nil;
    [_projectionView release];
    [_rightView release];
    [_bottomView release];
    [_leftView release];
    [super dealloc];
}

@end
