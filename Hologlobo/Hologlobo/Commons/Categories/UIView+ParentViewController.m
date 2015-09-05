//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "UIView+ParentViewController.h"

@implementation UIView (ParentViewController)

- (UIViewController *)parentViewController {

    UIResponder * responder = self;

    while([responder isKindOfClass:[UIView class]]) {
     
        responder = [responder nextResponder];
    }
    
    if([responder isKindOfClass:[UIViewController class]]) {
        
        return (UIViewController *)responder;
    }
    
    return nil;
}

@end
