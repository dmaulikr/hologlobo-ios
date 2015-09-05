//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenderingView : UIView

/* override */
- (void)prepareForRendering;
- (void)renderFrameWithInterval:(double)interval;
- (void)unload;

@end
