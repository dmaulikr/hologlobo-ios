//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)scaleWithFactor:(CGFloat)scaleFactor {
    return [self scaleWithFactor:scaleFactor useDeviceScale:YES];
}

- (UIImage *)scaleWithFactor:(CGFloat)scaleFactor useDeviceScale:(BOOL)device {
    
    CGSize newSize = CGSizeMake(self.size.width * scaleFactor, self.size.height * scaleFactor);
    
    CGFloat deviceScale = device ? 0.0:1.0;
    
    /* Ajusta scale para retina automatico ao passar 0.0 */
    UIGraphicsBeginImageContextWithOptions(newSize, NO, deviceScale);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)scaledDownImageWithMaxLength:(CGFloat)length {
    return [self scaledDownImageWithMaxLength:length useDeviceScale:YES];
}

- (UIImage *)scaledDownImageWithMaxLength:(CGFloat)length useDeviceScale:(BOOL)device {
    
    if(length == 0.f) {
        
        return nil;
    }
    
    CGFloat scaleFactor = length/MAX(self.size.width, self.size.height);
    
    if(scaleFactor < 1.0) {
        
        return [self scaleWithFactor:scaleFactor useDeviceScale:device];
    }
    
    else {
        
        return self;
    }
}

- (UIImage *)scaledImageWithMaxSize:(CGSize)maxSize {
    return [self scaledImageWithMaxSize:maxSize useDeviceScale:YES];
}

- (UIImage *)scaledImageWithMaxSize:(CGSize)maxSize useDeviceScale:(BOOL)device {
    
    if(maxSize.width == 0.f || maxSize.height == 0.f) {
        
        return nil;
    }
    
    CGFloat scaleFactor = 1.0f;
    BOOL scaleWidth = (MIN(maxSize.width, maxSize.height) == maxSize.width);
    
    if(scaleWidth) {
        
        scaleFactor = maxSize.width/self.size.width;
        
        if(self.size.height * scaleFactor > maxSize.height) {
            
            scaleFactor = maxSize.height/self.size.height;
        }
    }
    
    else {
        
        scaleFactor = maxSize.height/self.size.height;
        
        if(self.size.width * scaleFactor > maxSize.width) {
            
            scaleFactor = maxSize.width/self.size.width;
        }
    }
    
    return [self scaleWithFactor:scaleFactor useDeviceScale:device];
}

@end
