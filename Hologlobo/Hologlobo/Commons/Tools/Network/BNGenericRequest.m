//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNGenericRequest.h"

@interface BNGenericRequest ()
@property (nonatomic, retain) NSDictionary * receivedHeader;

@property (nonatomic, copy) void (^successHandler)(BNGenericRequest * request, NSData * data, NSDictionary * responseHeader);
@property (nonatomic, copy) void (^failHandler)(BNGenericRequest * request, NSDictionary * responseHeader);

@end

@implementation BNGenericRequest

+ (instancetype)genericRequestWithTag:(NSString *)tag urlRequest:(NSURLRequest *)request successHandler:(void (^)(BNGenericRequest * request, NSData * data, NSDictionary * responseHeader))success failHandler:(void (^)(BNGenericRequest * request, NSDictionary * responseHeader))fail {
    
    BNGenericRequest * generic = [[self alloc] initWithURLRequest:request];
    [generic setTag:tag];
    [generic setSuccessHandler:success];
    [generic setFailHandler:fail];
    return [generic autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [_receivedHeader release], _receivedHeader = nil;
    _receivedHeader = [[(NSHTTPURLResponse *)response allHeaderFields] retain];
    [super connection:connection didReceiveResponse:response];
}

- (void)didDownloadData:(NSData *)data {

    [self successHandler](self, data, _receivedHeader);
}

- (void)fail {
    
    [self failHandler](self, _receivedHeader);
}

- (void)dealloc {

    Block_release(_successHandler);
    Block_release(_failHandler);
    [_receivedHeader release], _receivedHeader = nil;
    [super dealloc];
}

@end
