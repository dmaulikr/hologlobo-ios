//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBCodeNode : NSObject

@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSDictionary * params;
@property (nonatomic, retain) NSArray * nodes;

@end
