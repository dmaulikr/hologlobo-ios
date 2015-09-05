//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Path)

- (id)objectForPath:(NSString *)configPath ofKind:(Class)class;

@end
