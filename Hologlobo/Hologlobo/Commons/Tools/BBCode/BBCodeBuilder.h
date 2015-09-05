//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAttributedStringBBCodeDelegate.h"

@interface BBCodeStyle : NSObject
+ (void)registerStyle:(NSString *)style font:(NSString *)fontName colour:(NSString *)colourHex size:(CGFloat)size;
+ (void)deleteStyle:(NSString *)style;
@end

@interface BBCodeBuilder : NSObject

@property (nonatomic, assign) id<NSAttributedStringBBCodeDelegate> delegate;

+ (NSAttributedString *)buildAttributedStringFromString:(NSString *)string;
+ (NSAttributedString *)buildAttributedStringFromString:(NSString *)string delegate:(id<NSAttributedStringBBCodeDelegate>)delegate;
- (id)initWithString:(NSString *)string;
- (NSAttributedString *)attributedString;

@end
