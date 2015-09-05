//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNStaticImageCell.h"
#import "UIImage+Resize.h"

#define IMAGE_MARGIN 32.f
#define DEFAULT_WIDTH 320.f

@interface BNStaticImageCellView ()
@property (nonatomic, retain) IBOutlet UIImageView * image;
@end

@interface BNStaticImageCell ()

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) UIImage * scaledImage;
@property (nonatomic, retain) UIColor * bgColour;
@end

@implementation BNStaticImageCell

+ (instancetype)staticImageCellWithImage:(UIImage *)image background:(UIColor *)colour {
    
    BNStaticImageCell * cell = [[[self alloc] init] autorelease];
    [cell setImage:image];
    [cell setScaledImage:[image scaledImageWithMaxSize:CGSizeMake((320.f - 2.f * IMAGE_MARGIN), CGFLOAT_MAX)]];
    [cell setBgColour:colour];
    [cell setMargin:IMAGE_MARGIN];
    [cell setHeight:CGFLOAT_MAX];
    return cell;
}

+ (instancetype)staticImageCellWithImage:(UIImage *)image {
    return [self staticImageCellWithImage:image background:[UIColor clearColor]];
}

- (CGFloat)adjustedMargin {
    return ((self.margin/DEFAULT_WIDTH) * self.expectedCellWidth);
}

- (instancetype)withMargin:(CGFloat)margin {
    
    [self setMargin:margin];
    self.scaledImage = [_image scaledImageWithMaxSize:CGSizeMake((self.expectedCellWidth - 2.f * self.adjustedMargin), (_height - 2.f * self.adjustedMargin))];
    return self;
}

- (instancetype)withCustomWidth:(CGFloat)width {
    
    [super withCustomWidth:width];
    self.scaledImage = [_image scaledImageWithMaxSize:CGSizeMake((width - 2.f * self.adjustedMargin), (_height - 2.f * self.adjustedMargin))];
    return self;
}

- (instancetype)withMaxHeight:(CGFloat)height {
    
    [self setHeight:height];
    self.scaledImage = [_image scaledImageWithMaxSize:CGSizeMake((self.expectedCellWidth - 2.f * self.adjustedMargin), (_height - 2.f * self.adjustedMargin))];
    return self;
}

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    BNStaticImageCellView * cellView = (BNStaticImageCellView *)cell;
    [cellView.image setImage:_scaledImage];
    [cellView.contentView setBackgroundColor:_bgColour];
}

- (CGFloat)cellHeight {
    
    return [_scaledImage size].height + 2.f * self.adjustedMargin;
}

- (void)dealloc {
    
    [_scaledImage release], _scaledImage = nil;
    [_bgColour release], _bgColour = nil;
    [_image release], _image = nil;
    [super dealloc];
}

@end

@implementation BNStaticImageCellView

- (void)dealloc {
    
    [_image release], _image = nil;
    [super dealloc];
}

@end
