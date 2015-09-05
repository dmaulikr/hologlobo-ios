//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNNetworkRequest.h"

@interface BNNetworkDownloadRequest : BNNetworkRequest

/* Override */
- (void)didDownloadData:(NSData *)data;

@end
