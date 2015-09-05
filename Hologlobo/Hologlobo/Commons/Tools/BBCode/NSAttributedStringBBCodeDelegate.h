//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSAttributedStringBBCodeDelegate <NSObject>

@optional
- (NSDictionary *)attributesForTag:(NSString *)tag params:(NSDictionary *)params previous:(NSDictionary *)attributes;

@end
