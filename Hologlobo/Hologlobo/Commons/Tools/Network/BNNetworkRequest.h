//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNNetworkRequest;

@protocol BNNetworkRequestManagerProtocol <NSObject>

@required
- (void)didFinishOrCancelRequest:(BNNetworkRequest *)request;

@end

@interface BNNetworkRequest : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSString * tag;

/* These are all "protected" */

@property (nonatomic, assign) id target;
@property (nonatomic, assign) id<BNNetworkRequestManagerProtocol> manager;

- (id)initWithURLRequest:(NSURLRequest *)request;

- (void)start;
- (void)cancel;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
