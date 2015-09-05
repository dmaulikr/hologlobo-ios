//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNNetworkDownloadRequest.h"

@class BNImageDownloadRequest;

@protocol BNImageDownloadRequestProtocol <NSObject>

@required
- (void)imageRequest:(BNImageDownloadRequest *)request didDownloadImage:(UIImage *)image;

@end

@interface BNImageDownloadRequest : BNNetworkDownloadRequest

+ (BNImageDownloadRequest *)imageDownloadFromURL:(NSURL *)url failImage:(UIImage *)failImage delegate:(id<BNImageDownloadRequestProtocol>)delegate maxSize:(CGSize)maxSize;

@end