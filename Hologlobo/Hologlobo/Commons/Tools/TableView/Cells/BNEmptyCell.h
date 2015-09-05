//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTableView.h"

@interface BNEmptyCell : BNTableCellController

+ (BNEmptyCell *)emptyCellWithHeight:(CGFloat)height;
+ (BNEmptyCell *)emptyCellWithHeight:(CGFloat)height colour:(UIColor *)backgroundColour;

@end

@interface BNEmptyCellView : BNTableViewCell
@end
