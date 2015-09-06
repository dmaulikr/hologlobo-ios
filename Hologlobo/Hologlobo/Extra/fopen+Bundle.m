//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "fopen+Bundle.h"

static NSString * documentsDirectory = @"";

FILE * fopenInBundle(char * file, char * mode) {
    
    NSString * modelPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[NSString stringWithUTF8String:file] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    return fopen((char *)[modelPath UTF8String], mode);
}

void setDocumentsDirectory(NSString * directory) {
    
    documentsDirectory = directory;
}

NSString * getDocumentsDirectory(void) {
    return documentsDirectory == nil ? @"":documentsPathForDirectory(documentsDirectory);
}

NSString * documentsPathForDirectory(NSString * directory) {
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documents = [paths objectAtIndex:0];
    
    if(![directory isEqualToString:@""]) {
        
        documents = [documents stringByAppendingPathComponent:directory];
    }
    
    return documents;
}

BOOL documentsDirectoryExists(NSString * directory) {
    
    NSString * path = documentsPathForDirectory(directory);
    
    BOOL isDir = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    return (exists && isDir);
}

FILE * fopenInDocumentsDirectory(char * file, char * mode) {
    
    NSString * modelPath = [documentsPathForDirectory(documentsDirectory) stringByAppendingPathComponent:[[NSString stringWithUTF8String:file] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    return fopen((char *)[modelPath UTF8String], mode);
}
