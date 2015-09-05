//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BBCodeNode.h"

@implementation BBCodeNode

- (void)dealloc {
    
    [_tag release];
    [_params release];
    [_nodes release];
    
    [super dealloc];
}

@end
