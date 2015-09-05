//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTableView.h"

@interface BNSeparatorCell : BNTableCellController

+ (BNSeparatorCell *)separatorCell;
+ (BNSeparatorCell *)separatorCellWithColour:(UIColor *)customColour;

@end

@interface BNSeparatorCellView : BNTableViewCell
@property (retain, nonatomic) IBOutlet UIView * separatorView;
@end
