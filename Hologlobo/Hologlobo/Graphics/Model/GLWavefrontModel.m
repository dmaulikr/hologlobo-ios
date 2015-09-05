//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "GLWavefrontModel.h"
#include "obj_parser.h"

@implementation GLWavefrontFace

- (BOOL)hasTexture {
    return _faceTexture != 0;
}

- (void)dealloc {
    
    [_object release], _object = nil;
    [super dealloc];
}

@end

@implementation GLWavefrontModel

- (instancetype)initWithContentsOfFile:(NSString *)file {
    return [self initWithContentsOfFile:file texture:nil];
}

- (instancetype)initWithContentsOfFile:(NSString *)file texture:(NSString *)texture {
    
    if(self = [super init]) {
        
        obj_scene_data data;
    
        if(parse_obj_scene(&data, (char *)[file UTF8String])) {
            
            NSMutableArray * objects = [NSMutableArray array];
            
            /* Grouping by material */
            NSMutableDictionary * map = [NSMutableDictionary dictionary];
            
            BOOL hasTexCoordinates = (data.vertex_texture_count > 0);
            BOOL hasNormals = (data.vertex_normal_count > 0);
            
            /* Faces grouped by material */
            if(data.material_count > 0) {
                
                for(unsigned i = 0; i < data.face_count; i++) {
                
                    NSNumber * key = @(data.face_list[i]->material_index);
                    
                    if([map objectForKey:key]) {
                        
                        [(NSMutableArray *)[map objectForKey:key] addObject:@(i)];
                    }
                    
                    else {
                        
                        NSMutableArray * faces = [NSMutableArray array];
                        [faces addObject:@(i)];
                        [map setObject:faces forKey:key];
                    }
                }
                
                for(NSNumber * material in [map allKeys]) {
                    
                    GLuint textureID = 0;
                    unsigned index = [material unsignedIntValue];
                    
                    if(data.material_list[index]->texture_filename[0] != 0) {
                        
                        NSString * textureFile = [[NSString stringWithUTF8String:data.material_list[index]->texture_filename] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        
//                        textureID = [[GLTextureCacher shared] loadTexture:textureFile];
                        textureID = [GLTextureCacher setupTexture:textureFile];
                    }
                    
                    GLWavefrontFace * object = [[GLWavefrontFace alloc] init];
                    [object setFaceTexture:textureID];
                    
                    gloBegin();
                    for(NSNumber * faceIndex in [map objectForKey:material]) {
                        
                        unsigned i = [faceIndex unsignedIntValue];
                        
                        for(unsigned j = 0; j < data.face_list[i]->vertex_count; j++) {
                            
                            unsigned vertexIndex = data.face_list[i]->vertex_index[j];
                            gloColor3f(1, 1, 1);
                            
                            if(hasTexCoordinates) {
                                
                                unsigned texIndex = data.face_list[i]->texture_index[j];
                                gloTexCoord2f(data.vertex_texture_list[texIndex]->e[0],
                                              data.vertex_texture_list[texIndex]->e[1]);
                            }
                            
                            if(hasNormals) {
                                
//                                unsigned normalIndex = data.face_list[i]->normal_index[j];
//#warning Add normals...
                            }
                            
                            gloVertex3f(data.vertex_list[vertexIndex]->e[0],
                                        data.vertex_list[vertexIndex]->e[1],
                                        data.vertex_list[vertexIndex]->e[2]);
                        }
                    }
                    [object setObject:gloEnd()];
                    [objects addObject:object];
                    [object release];
                }
            }
            
            /* One VBO (no materials) */
            else {
             
                GLWavefrontFace * object = [[GLWavefrontFace alloc] init];
                
                gloBegin();
                for(unsigned i = 0; i < data.face_count; i++) {
                    
                    /* Faces must be triangles */
                    for(unsigned j = 0; j < data.face_list[i]->vertex_count; j++) {
                        
                        unsigned vertexIndex = data.face_list[i]->vertex_index[j];
                        gloColor3f(1, 1, 1);
                        
                        if(hasTexCoordinates) {
                            
                            unsigned texIndex = data.face_list[i]->texture_index[j];
                            gloTexCoord2f(data.vertex_texture_list[texIndex]->e[0],
                                          data.vertex_texture_list[texIndex]->e[1]);
                        }
                        
                        if(hasNormals) {
                            
                            //                        unsigned normalIndex = data.face_list[i]->normal_index[j];
                            //#warning Add normals...
                        }
                        
                        gloVertex3f(data.vertex_list[vertexIndex]->e[0],
                                    data.vertex_list[vertexIndex]->e[1],
                                    data.vertex_list[vertexIndex]->e[2]);
                    }
                }
                [object setObject:gloEnd()];
                [objects addObject:object];
                [object release];
            }
        
            _objects = [[NSArray alloc] initWithArray:objects];
            
            /* Computing centroid */
            _centroid = newVector(0, 0, 0);
            
            for(unsigned i = 0; i < data.vertex_count; i++) {
                
                _centroid.v[0] += data.vertex_list[i]->e[0];
                _centroid.v[1] += data.vertex_list[i]->e[1];
                _centroid.v[2] += data.vertex_list[i]->e[2];
            }
            
            _centroid.v[0] /= data.vertex_count;
            _centroid.v[1] /= data.vertex_count;
            _centroid.v[2] /= data.vertex_count;
            
            /* Computing magnitude */
            Vector3 max = newVector(-MAXFLOAT, -MAXFLOAT, -MAXFLOAT);
            Vector3 min = newVector(MAXFLOAT, MAXFLOAT, MAXFLOAT);
            
            for(unsigned i = 0; i < data.vertex_count; i++) {
                
                GLfloat x = data.vertex_list[i]->e[0];
                GLfloat y = data.vertex_list[i]->e[1];
                GLfloat z = data.vertex_list[i]->e[2];
                
                if(x > max.v[0]) max.v[0] = x;
                if(y > max.v[1]) max.v[1] = y;
                if(z > max.v[2]) max.v[2] = z;
                
                if(x < min.v[0]) min.v[0] = x;
                if(y < min.v[1]) min.v[1] = y;
                if(z < min.v[2]) min.v[2] = z;
            }
            
            GLfloat xDiff = fabs(max.v[0] - min.v[0]);
            GLfloat yDiff = fabs(max.v[1] - min.v[1]);
            GLfloat zDiff = fabs(max.v[2] - min.v[2]);
            
            _magnitude = MAX(MAX(xDiff, yDiff), MAX(yDiff, zDiff));
            
            delete_obj_data(&data);
            
            /* Load global texture */
            if(texture) {
                
//                _globalTexture = [[GLTextureCacher shared] loadTexture:texture];
                _globalTexture = [GLTextureCacher setupTexture:texture];
            }
        }
        
        else {
            
            [self autorelease];
            return nil;
        }
    }
    
    return self;
}

- (BOOL)hasGlobalTexture {
    return _globalTexture != 0;
}

- (void)drawWithPosition:(GLuint)positionAttrib colour:(GLuint)colourAttrib texCoord:(GLuint)texCoordAttrib texture:(GLuint)textureUniform {
    
    glActiveTexture(GL_TEXTURE0);

    BOOL useGlobalTexture = [self hasGlobalTexture];
    
    if(useGlobalTexture) {
        
        glBindTexture(GL_TEXTURE_2D, [self globalTexture]);
        glUniform1i(textureUniform, 0);
    }
    
    for(GLWavefrontFace * face in self.objects) {
        
        if(!useGlobalTexture && [face hasTexture]) {
            
            glBindTexture(GL_TEXTURE_2D, [face faceTexture]);
            glUniform1i(textureUniform, 0);
        }
        
        [face.object drawWithPosition:positionAttrib
                                 colour:colourAttrib
                               texCoord:texCoordAttrib];
    }
}

- (void)dealloc {
    
    [_objects release], _objects = nil;
    
    [super dealloc];
}

@end
