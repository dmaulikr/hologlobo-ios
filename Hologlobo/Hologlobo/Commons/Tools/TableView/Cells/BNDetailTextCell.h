//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTableView.h"

@interface BNDetailTextCell : BNTableCellController
+ (BNDetailTextCell *)detailTextCellWithText:(NSAttributedString *)detail;
@end

@interface BNDetailTextCellView : BNTableViewCell
@property (retain, nonatomic) IBOutlet UILabel * labelView;
@end
