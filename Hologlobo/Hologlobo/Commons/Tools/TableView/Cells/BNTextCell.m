//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTextCell.h"

@interface BNTextCell ()

@property (nonatomic, retain) NSAttributedString * textString;
@property (nonatomic, retain) UIColor * bgColour;
@property (nonatomic) BOOL centred;
@property (nonatomic, assign) CGFloat margin;
@end

@implementation BNTextCell

+ (BNTextCell *)textCellWithText:(NSAttributedString *)text bgColour:(UIColor *)bgColour centred:(BOOL)centred {
    
    BNTextCell * cell = [[[self alloc] init] autorelease];
    [cell setTextString:text];
    [cell setBgColour:bgColour];
    [cell setCentred:centred];
    [cell setMargin:16.f];
    return cell;
}

+ (BNTextCell *)textCellWithText:(NSAttributedString *)text {
    
    return [self textCellWithText:text bgColour:[UIColor whiteColor] centred:NO];
}

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {

    BNTextCellView * cellView = (BNTextCellView *)cell;
    
    [cellView.labelView setTextAlignment: (_centred) ? NSTextAlignmentCenter:NSTextAlignmentLeft];
    [cellView.contentView setBackgroundColor:_bgColour];
    
    if(_textString == nil) {
        
        [cellView.labelView setText:@""];
    }
    
    else {
        
        [cellView.labelView setAttributedText:_textString];
    }
}

- (CGFloat)cellHeight {
    
    CGFloat result = [_textString boundingRectWithSize:CGSizeMake(self.expectedCellWidth - (2.f * _margin), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    return result < 25.f ? 25.f:result + 10.f;
}

- (void)clickAction {
    
    if(self.hasAction) {
        [self.target performSelector:self.action withObject:nil];
    }
}

- (void)dealloc {
    
    [_bgColour release], _bgColour = nil;
    [_textString release], _textString = nil;
    [super dealloc];
}

@end

@implementation BNTextCellView

- (IBAction)clickAction:(id)sender {
    [(BNTextCell *)self.controller clickAction];
}

- (void)dealloc {
    
    [_labelView release], _labelView = nil;
    [super dealloc];
}

@end
