//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNImageCell.h"
#import "BNNetworkManager.h"
#import "UIColor+Hex.h"

@interface BNImageCell ()
@property (nonatomic, retain) UIImage * placeholder;

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, retain) NSURL * imageURL;
@end

@implementation BNImageCell

+ (instancetype)imageCellWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder size:(CGSize)size {
    
    BNImageCell * cell = [[[self alloc] init] autorelease];
    [cell setImageSize:size];
    [cell setImageURL:imageURL];
    [cell setPlaceholder:placeholder];
    return cell;
}

- (CGFloat)availableWidth {
    return self.expectedCellWidth /* - 16.f */;
}

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    BNImageCellView * cellView = (BNImageCellView *)cell;
    
    [BNNetworkManager cancelRequestsWithTarget:cellView];
    [cellView.image setImage:_placeholder];
    
    if(_imageURL) {
        
        [BNNetworkManager addRequest:[BNImageDownloadRequest imageDownloadFromURL:_imageURL failImage:_placeholder delegate:cellView maxSize:CGSizeMake(self.availableWidth, CGFLOAT_MAX)]];
    }
}

- (CGFloat)cellHeight {
    
    const CGFloat placeHolderHeight = 300.f, placeHolderWidth = 300.f;
    CGSize imageSize = (_imageURL != nil) ? _imageSize:CGSizeMake(placeHolderWidth, placeHolderHeight);
    
    return imageSize.height * (self.availableWidth/imageSize.width);
}

- (void)dealloc {
    
    [_placeholder release], _placeholder = nil;
    [_imageURL release], _imageURL = nil;
    [super dealloc];
}

@end

@implementation BNImageCellView

- (IBAction)clickAction:(id)sender {
    [self.controller defaultAction];
}

- (void)imageRequest:(BNImageDownloadRequest *)request didDownloadImage:(UIImage *)image {
    [self.image setImage:image];
}

- (void)dealloc {
    [BNNetworkManager cancelRequestsWithTarget:self];
    [_image release], _image = nil;
    [super dealloc];
}

@end
