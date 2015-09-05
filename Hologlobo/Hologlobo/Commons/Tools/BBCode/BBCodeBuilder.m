//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BBCodeBuilder.h"
#import "NSMutableArray+Stack.h"
#import "BBCodeParser.h"
#import "UIColor+Hex.h"

typedef enum {
    BBCodeBuilderTagNone = 0,
    BBCodeBuilderTagUnderline,
    BBCodeBuilderTagFont,
    BBCodeBuilderTagColor,
    BBCodeBuilderTagStyle
} BBCodeBuilderTag;

@interface BBCodeStyle ()
@property (nonatomic, retain) NSMutableDictionary * styles;

+ (NSDictionary *)styleNamed:(NSString *)style;
@end

@implementation BBCodeStyle

+ (id)shared {
    
    static BBCodeStyle * style = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        style = [[self alloc] init];
    });
    
    return style;
}

- (void)registerStyle:(NSString *)style font:(NSString *)fontName colour:(NSString *)colourHex size:(CGFloat)size {
    
    if(!_styles) {
        
        _styles = [[NSMutableDictionary alloc] init];
    }
    
    _styles[style] = @{@"font":fontName, @"colour":colourHex, @"size":@(size)};
}

- (void)deleteStyle:(NSString *)style {
    
    [_styles removeObjectForKey:style];
}

+ (void)registerStyle:(NSString *)style font:(NSString *)fontName colour:(NSString *)colourHex size:(CGFloat)size {
    [[self shared] registerStyle:style font:fontName colour:colourHex size:size];
}

+ (void)deleteStyle:(NSString *)style {
    [[self shared] deleteStyle:style];
}

- (NSDictionary *)styleNamed:(NSString *)style {
    return [_styles objectForKey:style];
}

+ (NSDictionary *)styleNamed:(NSString *)style {
    return [[self shared] styleNamed:style];
}

- (void)dealloc {
    
    [_styles release], _styles = nil;
    [super dealloc];
}

@end

@interface BBCodeBuilder ()

@property (retain, nonatomic) NSMutableArray * contextStack;
@property (retain, nonatomic) NSMutableAttributedString * mutableString;
@property (retain, nonatomic) BBCodeNode * root;

@end

@implementation BBCodeBuilder

+ (NSAttributedString *)buildAttributedStringFromString:(NSString *)string {
    
    BBCodeBuilder * builder = [[[self alloc] initWithString:string] autorelease];
    
    return [builder attributedString];
}

+ (NSAttributedString *)buildAttributedStringFromString:(NSString *)string delegate:(id<NSAttributedStringBBCodeDelegate>)delegate {
    
    BBCodeBuilder * builder = [[[self alloc] initWithString:string] autorelease];
    
    [builder setDelegate:delegate];
    
    return [builder attributedString];
}


- (id)initWithString:(NSString *)string {
    
    if(self = [super init]) {
        
        _root = [[BBCodeParser treeWithString:string] retain];
    }
    
    return self;
}

- (NSAttributedString *)attributedString {
    
    if(!_mutableString) {
        
        _contextStack = [[NSMutableArray alloc] init];
        _mutableString = [[NSMutableAttributedString alloc] init];
        
        [_contextStack push:[NSDictionary dictionary]];
        
        for(id node in _root.nodes) {
            
            [_mutableString appendAttributedString:[self attributedStringForNode:node]];
        }
        
        [_contextStack pop];
    }
    
    return [[[NSAttributedString alloc] initWithAttributedString:_mutableString] autorelease];
}

- (BBCodeBuilderTag)tagForString:(NSString *)tagString {
    
    BBCodeBuilderTag tag = BBCodeBuilderTagNone;
    
    if([tagString isEqualToString:@"u"]) {
        
        return BBCodeBuilderTagUnderline;
    }
    
    else if([tagString isEqualToString:@"font"]) {
        
        return BBCodeBuilderTagFont;
    }
    
    else if([tagString isEqualToString:@"color"]) {
        
        return BBCodeBuilderTagColor;
    }
    
    else if([tagString isEqualToString:@"style"]) {
        
        return BBCodeBuilderTagStyle;
    }
    
    if(!self.delegate) {
    
        @throw [NSException exceptionWithName:@"Invalid tag" reason:[NSString stringWithFormat:@"Invalid tag \'%@\'.", tagString] userInfo:nil];
    }
    
    return tag;
}

- (NSAttributedString *)attributedStringForNode:(id)node {
    
    if([node isKindOfClass:[NSString class]]) {
        
        return [[[NSAttributedString alloc] initWithString:(NSString *)node attributes:[_contextStack top]] autorelease];
    }
    
    NSMutableAttributedString * atrString = [[[NSMutableAttributedString alloc] init] autorelease];
    
    if([node isKindOfClass:[BBCodeNode class]]) {
        
        BBCodeNode * nodeObject = (BBCodeNode *)node;
        
        NSMutableDictionary * current = [NSMutableDictionary dictionaryWithDictionary:[_contextStack top]];
        BBCodeBuilderTag tag = [self tagForString:nodeObject.tag];
        
        /* Underline */
        if(tag == BBCodeBuilderTagUnderline) {
            
            [current setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
        }
        
        /* Font */
        else if(tag == BBCodeBuilderTagFont) {
            
            CGFloat size;
            
            if(![nodeObject.params objectForKey:@"size"]) {
                
                if(![current objectForKey:NSFontAttributeName]) {
                    
                    size = 12.f;
                }
                
                else {
                    
                    UIFont * previousFont = [current objectForKey:NSFontAttributeName];
                    size = [previousFont pointSize];
                }
            }
            
            else {
                
                size = [(NSString *)[nodeObject.params objectForKey:@"size"] floatValue];
            }
            
            UIFont * font;
            
            if(![nodeObject.params objectForKey:@"name"]) {
                
                if(![current objectForKey:NSFontAttributeName]) {
                    
                    font = [UIFont systemFontOfSize:size];
                }
                
                else {
                    
                    font = [(UIFont *)[current objectForKey:NSFontAttributeName] fontWithSize:size];
                }
            }
            
            else {
                
                font = [UIFont fontWithName:[nodeObject.params objectForKey:@"name"] size:size];
            }
            
            [current setObject:font forKey:NSFontAttributeName];
        }
        
        /* Color */
        else if(tag == BBCodeBuilderTagColor) {
            
            UIColor * color;
            
            if(![nodeObject.params objectForKey:@"hex"]) {
                
                if(![current objectForKey:NSForegroundColorAttributeName]) {
                    
                    color = [UIColor blackColor];
                }
                
                else {
                    
                    color = [UIColor colorWithCGColor:[[current objectForKey:NSForegroundColorAttributeName] CGColor]];
                }
            }
            
            else {
                
                color = [UIColor colorFromHexString:[nodeObject.params objectForKey:@"hex"]];
            }
            
            [current setObject:color forKey:NSForegroundColorAttributeName];
        }
        
        /* Style */
        else if(tag == BBCodeBuilderTagStyle) {
            
            if([nodeObject.params objectForKey:@"name"]) {
                
                NSDictionary * style = [BBCodeStyle styleNamed:[nodeObject.params objectForKey:@"name"]];
                
                if(style) {
                    
                    CGFloat size = [style[@"size"] doubleValue];
                    UIFont * font = [UIFont fontWithName:style[@"font"] size:size];
                    UIColor * color = [UIColor colorFromHexString:style[@"colour"]];
                    
                    [current setObject:font forKey:NSFontAttributeName];
                    [current setObject:color forKey:NSForegroundColorAttributeName];
                }
            }
        }
        
        /* Custom tag... */
        else {
            
            if([self.delegate respondsToSelector:@selector(attributesForTag:params:previous:)]) {
                
                current = [NSMutableDictionary dictionaryWithDictionary:[self.delegate attributesForTag:nodeObject.tag params:nodeObject.params previous:[_contextStack top]]];
            }
        }
        
        [_contextStack push:current];
        
        for(id nd in nodeObject.nodes) {
            
            [atrString appendAttributedString:[self attributedStringForNode:nd]];
        }
        
        [_contextStack pop];
    }
    
    return atrString;
}

- (void)dealloc {
    
    self.delegate = nil;
    [_mutableString release];
    [_root release];
    [_contextStack release];
    [super dealloc];
}

@end
