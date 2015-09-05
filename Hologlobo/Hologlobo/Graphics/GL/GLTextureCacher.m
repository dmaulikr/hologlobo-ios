//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "GLTextureCacher.h"

@implementation GLTextureCacher

+ (id)shared {
    
    static GLTextureCacher * shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (GLuint)loadTexture:(NSString *)img {
    
    if(!_loadedTextures) {
        
        _loadedTextures = [[NSMutableDictionary alloc] init];
    }
    
    NSNumber * textureId = [_loadedTextures objectForKey:img];
    
    if(textureId == nil) {
        
        textureId = [NSNumber numberWithUnsignedInt:[GLTextureCacher setupTexture:img]];
        [_loadedTextures setObject:textureId forKey:img];
    }
    
    return (GLuint)[textureId unsignedIntValue];
}

+ (GLuint)setupTexture:(NSString *)img {
    
    UIImage * image = [UIImage imageNamed:img];
    CGImageRef spriteImage = [image CGImage];
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData ;
    
    if((spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte))) == NULL) {
        
        return 0;
    }
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextTranslateCTM(spriteContext, 0, height);
    CGContextScaleCTM(spriteContext, 1.0, -1.0);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
#ifdef USE_MIPMAP
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
#else
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
#endif
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
#ifdef USE_MIPMAP
    glHint(GL_GENERATE_MIPMAP_HINT, GL_FASTEST);
    glGenerateMipmap(GL_TEXTURE_2D);
#endif
    
    free(spriteData);
    
    return texName;
}

- (void)unloadTextures {
    
    for(NSString * key in [_loadedTextures allKeys]) {
        
        NSNumber * textureID = [_loadedTextures objectForKey:key];
        GLuint texture = [textureID unsignedIntValue];
        
        if(texture != 0)
            glDeleteTextures(1, &texture);
    }
    
    [_loadedTextures release], _loadedTextures = nil;
}

- (void)dealloc {
    
    [self unloadTextures];
    [super dealloc];
}

@end
