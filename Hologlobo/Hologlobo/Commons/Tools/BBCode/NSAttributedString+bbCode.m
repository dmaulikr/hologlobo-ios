//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "NSAttributedString+bbCode.h"
#import "BBCodeBuilder.h"

/*
 * Supported tags:
 *
 * [u][/u] for Underline.
 * [font name="..." size="..."][/font] for a custom Font.
 * [color hex="..."][/color] for a custom text color.
 *
 */

@implementation NSAttributedString (bbCode)

+ (NSAttributedString *)attributedStringWithBBCode:(NSString *)bbCodeString {
    
    NSAttributedString * ret = nil;
    
    @try {
        
        ret = [BBCodeBuilder buildAttributedStringFromString:bbCodeString];
    }
    
    @catch (NSException * exception) {
        
        DLog(@"BBCode exception: %@ %@", exception.name, exception.description);
        ret = [[[NSAttributedString alloc] init] autorelease];
    }
    
    return ret;
}

+ (NSAttributedString *)attributedStringWithBBCode:(NSString *)bbCodeString delegate:(id<NSAttributedStringBBCodeDelegate>)delegate {
    
    NSAttributedString * ret = nil;
    
    @try {
        
        ret = [BBCodeBuilder buildAttributedStringFromString:bbCodeString delegate:delegate];
    }
    
    @catch (NSException * exception) {
        
        DLog(@"BBCode exception: %@ %@", exception.name, exception.description);
        ret = [[[NSAttributedString alloc] init] autorelease];
    }
    
    return ret;
}

@end
