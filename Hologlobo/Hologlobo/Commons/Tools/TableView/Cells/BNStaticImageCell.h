//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTableView.h"

@interface BNStaticImageCell : BNTableCellController

+ (instancetype)staticImageCellWithImage:(UIImage *)image;
+ (instancetype)staticImageCellWithImage:(UIImage *)image background:(UIColor *)colour;

/* Builder */
- (instancetype)withMargin:(CGFloat)margin;
- (instancetype)withMaxHeight:(CGFloat)height;

@end

@interface BNStaticImageCellView : BNTableViewCell

@end
