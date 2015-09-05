//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>

@interface GLTextureCacher : NSObject

@property (retain, nonatomic) NSMutableDictionary * loadedTextures;

+ (id)shared;
- (GLuint)loadTexture:(NSString *)img;
- (void)unloadTextures;

+ (GLuint)setupTexture:(NSString *)img;

@end

