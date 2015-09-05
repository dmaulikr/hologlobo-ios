//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNNetworkRequest.h"

@interface BNNetworkManager : NSObject<BNNetworkRequestManagerProtocol>

/* Ownership of the request is transferred to the NetworkManager */
+ (void)addRequest:(BNNetworkRequest *)networkRequest;

+ (void)cancelRequestsWithTarget:(id)target;
+ (void)cancelRequestsWithTargetClass:(Class)targetClass;
+ (void)cancelRequestsWithTag:(NSString *)tag;
+ (void)cancelAllRequests;

@end
