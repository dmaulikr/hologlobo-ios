//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNEmptySpaceCell.h"

@interface BNEmptySpaceCell ()
@property (nonatomic, assign) CGFloat height;
@end

@implementation BNEmptySpaceCell

+ (BNEmptySpaceCell *)emptySpaceCellWithHeight:(CGFloat)height {
    
    BNEmptySpaceCell * cell = [[[self alloc] init] autorelease];
    [cell setHeight:height];
    return cell;
}

- (CGFloat)cellHeight {
    return _height;
}

@end

@implementation BNEmptySpaceCellView

@end
