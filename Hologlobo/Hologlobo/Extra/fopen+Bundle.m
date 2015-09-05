//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "fopen+Bundle.h"

FILE * fopenInBundle(char * file, char * mode) {
    
    NSString * modelPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[[NSString stringWithUTF8String:file] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    return fopen((char *)[modelPath UTF8String], mode);
}
