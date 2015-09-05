//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)scaledDownImageWithMaxLength:(CGFloat)length;
- (UIImage *)scaledImageWithMaxSize:(CGSize)maxSize;

- (UIImage *)scaledDownImageWithMaxLength:(CGFloat)length useDeviceScale:(BOOL)device;
- (UIImage *)scaledImageWithMaxSize:(CGSize)maxSize useDeviceScale:(BOOL)device;

@end
 