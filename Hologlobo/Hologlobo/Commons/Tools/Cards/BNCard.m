//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNCard.h"

@implementation BNCard

- (NSArray *)cellControllers {
    
    return @[];
}

- (void)dealloc {
    
    _viewController = nil;
    [super dealloc];
}

@end
