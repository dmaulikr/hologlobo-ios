//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "UIView+Fade.h"

@implementation UIView (Fade)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated {
    
    if(!animated) {
        
        [self setHidden:hidden];
        return;
    }
    
    if(self.hidden != hidden) {
        
        if(hidden) {
            
            CGFloat previousAlpha = self.alpha;
            BOOL enabled = self.userInteractionEnabled;
            [self setUserInteractionEnabled:NO];
            
            [UIView animateWithDuration:0.3 animations:^{
                [self setAlpha:0.f];
            } completion:^(BOOL finished) {
                [self setAlpha:previousAlpha];
                [self setHidden:YES];
                [self setUserInteractionEnabled:enabled];
            }];
        }
        
        else {
            
            CGFloat previousAlpha = self.alpha;
            BOOL enabled = self.userInteractionEnabled;
            [self setUserInteractionEnabled:NO];
            [self setHidden:NO];
            [self setAlpha:0.f];
            
            [UIView animateWithDuration:0.3 animations:^{
                [self setAlpha:previousAlpha];
            } completion:^(BOOL finished) {
                [self setUserInteractionEnabled:enabled];
            }];
        }
    }
}

@end
