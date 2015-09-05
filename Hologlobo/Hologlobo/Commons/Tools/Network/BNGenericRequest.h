//
//  BNGenericRequest.h
//  inSPorte
//
//  Created by Fabio Dela Antonio on 8/26/15.
//  Copyright (c) 2015 Fabio Dela Antonio. All rights reserved.
//

#import "BNNetworkDownloadRequest.h"

@interface BNGenericRequest : BNNetworkDownloadRequest

+ (instancetype)genericRequestWithTag:(NSString *)tag urlRequest:(NSURLRequest *)request successHandler:(void (^)(BNGenericRequest * request, NSData * data, NSDictionary * responseHeader))success failHandler:(void (^)(BNGenericRequest * request, NSDictionary * responseHeader))fail;

@end
