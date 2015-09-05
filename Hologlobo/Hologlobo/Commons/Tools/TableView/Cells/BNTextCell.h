//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTableView.h"

@interface BNTextCell : BNTableCellController

+ (BNTextCell *)textCellWithText:(NSAttributedString *)text;
+ (BNTextCell *)textCellWithText:(NSAttributedString *)text bgColour:(UIColor *)bgColour centred:(BOOL)centred;

@end

@interface BNTextCellView : BNTableViewCell

@property (retain, nonatomic) IBOutlet UILabel * labelView;

@end
