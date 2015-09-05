//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAttributedStringBBCodeDelegate.h"

#define BB(X) [NSAttributedString attributedStringWithBBCode:@X]
#define BBF(X, ...) [NSAttributedString attributedStringWithBBCode:[NSString stringWithFormat:@X, ##__VA_ARGS__]]

@interface NSAttributedString (bbCode)

+ (NSAttributedString *)attributedStringWithBBCode:(NSString *)bbCodeString;
+ (NSAttributedString *)attributedStringWithBBCode:(NSString *)bbCodeString delegate:(id<NSAttributedStringBBCodeDelegate>)delegate;


@end
