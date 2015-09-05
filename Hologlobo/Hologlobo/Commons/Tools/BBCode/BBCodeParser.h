//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBCodeNode.h"

@interface BBCodeParser : NSObject

@property (nonatomic, retain) BBCodeNode * root;

+ (BBCodeNode *)treeWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;

@end
