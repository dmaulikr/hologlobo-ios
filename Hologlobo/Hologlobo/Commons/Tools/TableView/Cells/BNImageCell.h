//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTableView.h"
#import "BNImageDownloadRequest.h"

@interface BNImageCell : BNTableCellController

+ (instancetype)imageCellWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder size:(CGSize)size;

@end

@interface BNImageCellView : BNTableViewCell <BNImageDownloadRequestProtocol>
@property (retain, nonatomic) IBOutlet UIImageView * image;
@end
