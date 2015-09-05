//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNSeparatorCell.h"
#import "UIColor+Hex.h"
#import "General.h"

@interface BNSeparatorCell ()
@property (nonatomic, retain) UIColor * customColour;
@end

@implementation BNSeparatorCell

+ (BNSeparatorCell *)separatorCell {
    return [[[self alloc] init] autorelease];
}

+ (BNSeparatorCell *)separatorCellWithColour:(UIColor *)customColour {
    
    BNSeparatorCell * cell = [self separatorCell];
    [cell setCustomColour:customColour];
    return cell;
}

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    BNSeparatorCellView * cellView = (BNSeparatorCellView *)cell;
    
    [cellView.separatorView setBackgroundColor:(_customColour == nil) ? [UIColor colorFromHexString:kColourSeparator]:_customColour];
}

- (CGFloat)cellHeight {
    return 1.f;
}

- (void)dealloc {
    
    [_customColour release], _customColour = nil;
    [super dealloc];
}

@end

@implementation BNSeparatorCellView

- (void)dealloc {
    [_separatorView release], _separatorView = nil;
    [super dealloc];
}

@end
