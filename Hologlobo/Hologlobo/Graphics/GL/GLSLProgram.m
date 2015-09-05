//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "GLSLProgram.h"

@interface GLSLProgram() {

    GLuint _programHandle;
    GLuint _vertexShader;
    GLuint _fragmentShader;
}

@property (retain, nonatomic) NSMutableDictionary * uniforms;
@property (retain, nonatomic) NSMutableDictionary * attributes;

@end

@implementation GLSLProgram

+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    NSString * shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    
    NSError * error;
    NSString * shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    
    if (!shaderString) {
        
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        return 0;
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    
    if (compileSuccess == GL_FALSE) {
        
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString * messageString = [NSString stringWithUTF8String:messages];
        
        NSLog(@"%@", messageString);
        return 0;
    }
    
    return shaderHandle;
}

+ (GLSLProgram *)programWithVertexShader:(NSString *)vertex fragmentShader:(NSString *)fragment {
    
    return [[[self alloc] initWithVertexShader:vertex fragmentShader:fragment] autorelease];
}

- (id)initWithVertexShader:(NSString *)vertex fragmentShader:(NSString *)fragment {
    
    self = [super init];
    
    if(self != nil) {
        
        _vertexShader = [GLSLProgram compileShader:vertex withType:GL_VERTEX_SHADER];
        _fragmentShader = [GLSLProgram compileShader:fragment withType:GL_FRAGMENT_SHADER];
        
        _programHandle = glCreateProgram();
        glAttachShader(_programHandle, _vertexShader);
        glAttachShader(_programHandle, _fragmentShader);
        glLinkProgram(_programHandle);
        
        GLint linkSuccess;
        glGetProgramiv(_programHandle, GL_LINK_STATUS, &linkSuccess);
        
        if (linkSuccess == GL_FALSE) {
        
            GLchar messages[256];
            glGetProgramInfoLog(_programHandle, sizeof(messages), 0, &messages[0]);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"%@", messageString);
            
            _programHandle = 0;
        }
    }
    
    return self;
}

- (GLuint)glProgram {
    
    return _programHandle;
}

- (GLint)getUniform:(NSString *)uniform {
    
    if(_programHandle == 0) {
        
        return 0;
    }
    
    if(!_uniforms) {
        
        _uniforms = [[NSMutableDictionary alloc] init];
    }
    
    if([_uniforms objectForKey:uniform] == nil) {
        
        GLint uIndex = glGetUniformLocation(_programHandle, [uniform UTF8String]);
        
        if(uIndex < 0) {
            
            NSLog(@"Invalid uniform %@!", uniform);
            return -1;
        }
        
        [_uniforms setObject:@(uIndex) forKey:uniform];
    }
    
    return [(NSNumber *)[_uniforms objectForKey:uniform] intValue];
}

- (GLint)getAttribute:(NSString *)attribute {
    
    if(_programHandle == 0) {
        
        return 0;
    }
    
    if(!_attributes) {
        
        _attributes = [[NSMutableDictionary alloc] init];
    }
    
    if([_attributes objectForKey:attribute] == nil) {
        
        GLint uIndex = glGetAttribLocation(_programHandle, [attribute UTF8String]);
        
        if(uIndex < 0) {
            
            NSLog(@"Invalid attribute %@!", attribute);
            return -1;
        }
        
        [_attributes setObject:@(uIndex) forKey:attribute];
    }
    
    return [(NSNumber *)[_attributes objectForKey:attribute] intValue];
}

- (void)enableVertexAttribArrayFor:(NSString *)attribute {
    
    GLint uIndex;
    
    if((uIndex = [self getAttribute:attribute]) >= 0) {
        
        glEnableVertexAttribArray(uIndex);
    }
}

- (void)use {
    
    glUseProgram([self glProgram]);
}

- (void)unload {
    
    if(_programHandle != 0) {
        
        glDeleteProgram(_programHandle), _programHandle = 0;
    }
    
    if(_vertexShader != 0) {
        
        glDeleteShader(_vertexShader), _vertexShader = 0;
    }

    if(_fragmentShader != 0) {
        
        glDeleteShader(_fragmentShader), _fragmentShader = 0;
    }
    
    [_uniforms release], _uniforms = nil;
    [_attributes release], _attributes = nil;
}

- (void)dealloc {
    
    [self unload];
    
    [super dealloc];
}

@end
