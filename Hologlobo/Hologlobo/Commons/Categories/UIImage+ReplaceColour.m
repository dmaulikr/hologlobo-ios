//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "UIImage+ReplaceColour.h"

@implementation UIImage (ReplaceColour)

- (UIImage *)imageByReplacingTemplateWithColour:(UIColor *)colour {
    
    UIGraphicsBeginImageContext(self.size);
    [colour set];
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
