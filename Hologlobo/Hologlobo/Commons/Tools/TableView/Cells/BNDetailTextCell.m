//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNDetailTextCell.h"

@interface BNDetailTextCell ()
@property (nonatomic, retain) NSAttributedString * detailText;
@end

@implementation BNDetailTextCell

+ (BNDetailTextCell *)detailTextCellWithText:(NSAttributedString *)detail {
    BNDetailTextCell * cell = [[[self alloc] init] autorelease];
    [cell setDetailText:detail];
    return cell;
}

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    BNDetailTextCellView * cellView = (BNDetailTextCellView *)cell;
    [cellView.labelView setAttributedText:_detailText];
}

- (CGFloat)cellHeight {
    return 16.f;
}

- (void)dealloc {
    [_detailText release], _detailText = nil;
    [super dealloc];
}

@end

@implementation BNDetailTextCellView

- (void)dealloc {
    [_labelView release];
    [super dealloc];
}
@end
