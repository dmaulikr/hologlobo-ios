//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "NSDictionary+Path.h"

@implementation NSDictionary (Path)

- (id)objectForPath:(NSString *)configPath ofKind:(Class)class {
    
    BOOL url = (class == [NSURL class]);
    
    if(url) {
        class = [NSString class];
    }
    
    NSArray * parts = [configPath componentsSeparatedByString:@"/"];
    
    NSDictionary * current = self;
    id result = nil;
    
    for(NSString * component in parts) {
        
        if(current == nil) {
            
            result = nil;
            break;
        }
        
        if(![current isKindOfClass:[NSDictionary class]]) {
            
            result = nil;
            break;
        }
        
        if([parts lastObject] == component) {
            
            result = current[component];
        }
        
        else {
            
            current = current[component];
        }
    }
    
    if(![result isKindOfClass:class]) {
        
        result = nil;
    }
    
    if(url && result) {
        
        result = [NSURL URLWithString:result];
    }
    
    return result;
}

@end
