//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNNetworkDownloadRequest.h"

@interface BNNetworkDownloadRequest ()

@property (nonatomic, retain) NSMutableData * downloadData;

@end

@implementation BNNetworkDownloadRequest

- (id)initWithURLRequest:(NSURLRequest *)request {
    
    if(self = [super initWithURLRequest:request]) {
        
        _downloadData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self didDownloadData:nil];
    [super connection:connection didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_downloadData appendData:data];
    [super connection:connection didReceiveData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self didDownloadData:[NSData dataWithData:_downloadData]];
    [super connectionDidFinishLoading:connection];
}

- (void)didDownloadData:(NSData *)data {
    
}

- (void)dealloc {
    
    [_downloadData release];
    [super dealloc];
}

@end
