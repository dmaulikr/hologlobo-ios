//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

@interface GLSLProgram : NSObject

+ (GLSLProgram *)programWithVertexShader:(NSString *)vertex fragmentShader:(NSString *)fragment;

- (id)initWithVertexShader:(NSString *)vertex fragmentShader:(NSString *)fragment;

- (GLuint)glProgram;
- (void)use;
- (void)unload;

/* Remember to call "use" before using these methods */
- (GLint)getUniform:(NSString *)uniform;
- (GLint)getAttribute:(NSString *)attribute;
- (void)enableVertexAttribArrayFor:(NSString *)uniform;

@end
