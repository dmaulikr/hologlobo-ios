//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index {
    
    if(index >= [self count])
        return nil;
    
    return [self objectAtIndex:index];
}

@end
