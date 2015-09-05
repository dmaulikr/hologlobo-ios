//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNImageDownloadRequest.h"

#import "UIImage+Resize.h"

@interface BNImageCacher : NSObject

@property (nonatomic, retain) NSMutableDictionary * images;

- (void)saveImage:(UIImage *)image forURL:(NSURL *)url code:(NSString *)code;
- (UIImage *)imageForURL:(NSURL *)url code:(NSString *)code;

@end

@implementation BNImageCacher

+ (BNImageCacher *)shared {
    
    static BNImageCacher * shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (id)init {
    
    if(self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eraseCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (NSString *)keyForURL:(NSURL *)url code:(NSString *)code {
    
    return [NSString stringWithFormat:@"%@@%@", [url absoluteString], code];
}

- (void)saveImage:(UIImage *)image forURL:(NSURL *)url code:(NSString *)code {
    
    if(!image) {
        
        return;
    }
    
    if(!_images) {
        
        _images = [[NSMutableDictionary alloc] init];
    }
    
    [_images setObject:image forKey:[self keyForURL:url code:code]];
}

- (UIImage *)imageForURL:(NSURL *)url code:(NSString *)code {
    
    if(!_images) {
        
        return nil;
    }
    
    return [_images objectForKey:[self keyForURL:url code:code]];
}

- (void)eraseCache {
    
    [_images release], _images = nil;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_images release];
    [super dealloc];
}

@end

@interface BNImageDownloadRequest ()

@property (nonatomic, retain) UIImage * failImage;
@property (nonatomic, retain) NSURL * requestURL;
@property (nonatomic) CGSize maxSize;

@end

@implementation BNImageDownloadRequest

+ (NSString *)codeForSize:(CGSize)size {
    
    return [NSString stringWithFormat:@"%.0f-%.0f", size.width, size.height];
}

+ (BNImageDownloadRequest *)imageDownloadFromURL:(NSURL *)url failImage:(UIImage *)failImage delegate:(id<BNImageDownloadRequestProtocol>)delegate maxSize:(CGSize)maxSize {
    
    if(!url && delegate && [delegate respondsToSelector:@selector(imageRequest:didDownloadImage:)]) {
        
        [delegate imageRequest:nil didDownloadImage:failImage];
        return nil;
    }
    
    UIImage * image = [[BNImageCacher shared] imageForURL:url code:[self codeForSize:maxSize]];
    
    if(image && delegate && [delegate respondsToSelector:@selector(imageRequest:didDownloadImage:)]) {
        
        [delegate imageRequest:nil didDownloadImage:image];
        return nil;
    }
    
    BNImageDownloadRequest * request = [[self alloc] initWithImageURL:url delegate:delegate failImage:failImage maxSize:maxSize];
    
    return [request autorelease];
}

- (id)initWithImageURL:(NSURL *)url delegate:(id<BNImageDownloadRequestProtocol>)delegate failImage:(UIImage *)failImage maxSize:(CGSize)maxSize {
    
    if(self = [super initWithURLRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.f]]) {
        
        _requestURL = [url retain];
        _failImage = [failImage retain];
        _maxSize = maxSize;
        super.target = delegate;
    }
    
    return self;
}

- (void)didDownloadData:(NSData *)data {
    
    UIImage * result = nil;
    
    if(data) {
        
        result = [[UIImage imageWithData:data] scaledImageWithMaxSize:_maxSize];
        
        if(result) {
        
            [[BNImageCacher shared] saveImage:result forURL:_requestURL code:[BNImageDownloadRequest codeForSize:_maxSize]];
        }
        
        else {
            
            result = self.failImage;
        }
    }
    
    else {
        
        result = self.failImage;
    }
    
    if(self.target && [self.target respondsToSelector:@selector(imageRequest:didDownloadImage:)]) {
        
        [(id<BNImageDownloadRequestProtocol>)self.target imageRequest:self didDownloadImage:result];
    }
    
    [super didDownloadData:data];
}

- (void)dealloc {
    
    [_requestURL release];
    [_failImage release];
    [super dealloc];
}

@end
