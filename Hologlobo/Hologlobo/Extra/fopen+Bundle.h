//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#ifndef _fopen_Bundle_h
#define _fopen_Bundle_h

#include <stdio.h>

FILE * fopenInBundle(char * file, char * mode);

#ifdef __OBJC__
BOOL documentsDirectoryExists(NSString * directory);
NSString * documentsPathForDirectory(NSString * directory);

NSString * getDocumentsDirectory(void);
void setDocumentsDirectory(NSString * directory);
#endif

FILE * fopenInDocumentsDirectory(char * file, char * mode);

#endif
