//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void)push:(id)object {
    
    [self addObject:object];
}

- (id)pop {
    
    id object = [[self lastObject] retain];
    [self removeObjectAtIndex:[self count] - 1];
    return [object autorelease];
}

- (id)top {
    
    return [self lastObject];
}

@end
