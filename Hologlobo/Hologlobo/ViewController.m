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

@property (nonatomic, retain) NSString * file;

@property (retain, nonatomic) IBOutlet UISlider * rotationSlider;
@property (retain, nonatomic) IBOutlet UISlider * distanceSlider;

@property (retain, nonatomic) IBOutlet UIView * referenceView;
@property (retain, nonatomic) IBOutlet UIView * contractedReferenceView;
@property (retain, nonatomic) IBOutlet UIView * expandView;

@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

@end

@implementation ViewController

+ (instancetype)viewControllerWithFile:(NSString *)file {
    
    ViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [vc setFile:file];
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(!_displayLink) {
        
        _displayLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop:)] retain];
        _displayLink.frameInterval = 1; /* ~ 60 fps */
        
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    [self prepareForRendering];
}

- (void)prepareForRendering {
    
    [self.projectionView prepareForRenderingWithFile:self.file rotation:0.f];
    [self.leftView prepareForRenderingWithFile:self.file rotation:90.f];
    [self.bottomView prepareForRenderingWithFile:self.file rotation:180.f];
    [self.rightView prepareForRenderingWithFile:self.file rotation:270.f];
}

- (void)gameLoop:(CADisplayLink *)link {
    
    double timeDiff = link.duration;
    
    if(_i == 0) {
    
        [self.projectionView setRotation:self.rotationSlider.value];
        [self.projectionView setDistance:self.distanceSlider.value];
        [self.projectionView renderFrameWithInterval:timeDiff];
    }
        
    else if(_i == 1) {
        
        
        [self.rightView setRotation:self.rotationSlider.value];
        [self.rightView setDistance:self.distanceSlider.value];
        [self.rightView renderFrameWithInterval:timeDiff];
    }
    
    else if(_i == 2) {
        
        [self.bottomView setRotation:self.rotationSlider.value];
        [self.bottomView setDistance:self.distanceSlider.value];
        [self.bottomView renderFrameWithInterval:timeDiff];
    }
    
    else if(_i == 3) {
        
        [self.leftView setRotation:self.rotationSlider.value];
        [self.leftView setDistance:self.distanceSlider.value];
        [self.leftView renderFrameWithInterval:timeDiff];
    }
    
    _i = (_i + 1) % 4;
}

- (IBAction)expandAction:(id)sender {

    if(_expanded) {
     
        [UIView animateWithDuration:0.2 animations:^{
            self.expandView.frame = self.contractedReferenceView.frame;
        } completion:^(BOOL finished) {
            _expanded = NO;
        }];
    }
    
    else {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.expandView.frame = self.referenceView.frame;
        } completion:^(BOOL finished) {
            _expanded = YES;
        }];
    }
}

- (IBAction)backAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
    [_displayLink setPaused:YES];
    [_displayLink invalidate];
    [_displayLink release], _displayLink = nil;
    [_projectionView release];
    [_rightView release];
    [_bottomView release];
    [_leftView release];
    
    [_file release], _file = nil;
    [_rotationSlider release];
    [_distanceSlider release];
    [_referenceView release];
    [_expandView release];
    [_contractedReferenceView release];
    [super dealloc];
}

@end
