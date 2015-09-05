//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNEmptyCell.h"

@interface BNEmptyCell ()
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, retain) UIColor * colour;
@end

@implementation BNEmptyCell

+ (BNEmptyCell *)emptyCellWithHeight:(CGFloat)height {
    
    BNEmptyCell * cell = [[[self alloc] init] autorelease];
    [cell setHeight:height];
    return cell;
}

+ (BNEmptyCell *)emptyCellWithHeight:(CGFloat)height colour:(UIColor *)backgroundColour {
    
    BNEmptyCell * cell = [self emptyCellWithHeight:height];
    [cell setColour:backgroundColour];
    return cell;
}

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    BNEmptyCellView * cellView = (BNEmptyCellView *)cell;
    [cellView.contentView setBackgroundColor:_colour == nil ? [UIColor whiteColor]:_colour];
}

- (CGFloat)cellHeight {
    return _height;
}

- (void)dealloc {
    [_colour release], _colour = nil;
    [super dealloc];
}

@end

@implementation BNEmptyCellView

- (IBAction)clickAction:(id)sender {
    [self.controller defaultAction];
}

@end
