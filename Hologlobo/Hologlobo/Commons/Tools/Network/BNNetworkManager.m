//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNNetworkManager.h"

@interface BNNetworkManager()

@property (nonatomic, retain) NSMutableArray * requests; /* of BNNetworkRequest */

@end

@implementation BNNetworkManager

+ (id)shared {
    
    static BNNetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (id)init {
    
    if(self = [super init]) {
        
        _requests = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/* Add only non-started requests... This will retain the request. */
+ (void)addRequest:(BNNetworkRequest *)networkRequest {
    
    [[self shared] addRequest:networkRequest];
}

- (void)addRequest:(BNNetworkRequest *)networkRequest {
    
    if(networkRequest) {
        
        networkRequest.manager = self;
        [_requests addObject:networkRequest];
        [networkRequest start];
    }
}

- (void)didFinishOrCancelRequest:(BNNetworkRequest *)request {
    
    [self.requests removeObject:request];
}

+ (void)cancelRequestsWithTarget:(id)target {
    
    [[self shared] cancelRequestsWithTarget:target];
}

- (void)cancelRequestsWithTarget:(id)target {
    
    NSArray * aux = [NSArray arrayWithArray:_requests];
    
    for(BNNetworkRequest * request in aux) {
        
        if(request.target != nil && request.target == target) {
            
            [request cancel];
        }
    }
}

+ (void)cancelRequestsWithTargetClass:(Class)targetClass {
    
    [[self shared] cancelRequestsWithTargetClass:targetClass];
}

- (void)cancelRequestsWithTargetClass:(Class)targetClass {
    
    NSArray * aux = [NSArray arrayWithArray:_requests];
    
    for(BNNetworkRequest * request in aux) {
        
        if(request.target != nil && [request.target isKindOfClass:targetClass]) {
            
            [request cancel];
        }
    }
}

+ (void)cancelRequestsWithTag:(NSString *)tag {
    
    return [[self shared] cancelRequestsWithTag:tag];
}

- (void)cancelRequestsWithTag:(NSString *)tag {
    
    NSArray * aux = [NSArray arrayWithArray:_requests];
    
    for(BNNetworkRequest * request in aux) {
        
        if(request.tag != nil && [request.tag isEqualToString:tag]) {
            
            [request cancel];
        }
    }
}

+ (void)cancelAllRequests {
    
    [[self shared] cancelAllRequests];
}

- (void)cancelAllRequests {
    
    for(BNNetworkRequest * request in _requests) {
        
        [request cancel];
    }
}

- (void)dealloc {
    
    for(BNNetworkRequest * request in _requests) {
        
        request.manager = nil;
        [request cancel];
    }
    
    [_requests release];
    [super dealloc];
}

@end
