//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNNetworkRequest.h"

@interface BNNetworkRequest()

@property (nonatomic, retain) NSURLConnection * connection;

@end

@implementation BNNetworkRequest

- (id)initWithURLRequest:(NSURLRequest *)request {
    
    if(self = [super init]) {
        
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    }
    
    return self;
}

- (void)start {
    
    [self.connection start];
}

/* Override */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [_connection release], _connection = nil;
    
    if(self.manager && [self.manager respondsToSelector:@selector(didFinishOrCancelRequest:)]) {
        
        [self.manager didFinishOrCancelRequest:self];
    }
}

/* Override */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [_connection release], _connection = nil;
    
    if(self.manager && [self.manager respondsToSelector:@selector(didFinishOrCancelRequest:)]) {
        
        [self.manager didFinishOrCancelRequest:self];
    }
}

/* Override */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)cancel {
    
    _target = nil;
    [self.connection cancel];
    [_connection release], _connection = nil;
    
    if(self.manager && [self.manager respondsToSelector:@selector(didFinishOrCancelRequest:)]) {
        
        [self.manager didFinishOrCancelRequest:self];
    }
}

- (void)dealloc {
    
    if(_connection) {
        
        [_connection cancel];
    }
    
    [_tag release];
    _target = nil;
    _manager = nil;
    [super dealloc];
}

@end
