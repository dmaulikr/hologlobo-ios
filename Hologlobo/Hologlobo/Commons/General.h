//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#ifndef _General_h
#define _General_h

/* Colours */
#define kColourSeparator  @"CDCCCC"
#define kColourTextColour @"676767"
#define kColourGray       @"D0D0D0"
#define kColourLightGray  @"BBBDBF"

/* Math */
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

/** MACROS **/

/* UUID */
#define UUID() [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""]

#define ALERT(X, Y) [[[[UIAlertView alloc] initWithTitle:(X) message:(Y) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show]
#define ERROR_ALERT(X) ALERT(@"Erro", X)
#define DEFAULT_ERROR_ALERT() ERROR_ALERT(@"Por favor, tente novamente")

/* Service */
#define BASE_URL @"http://hologlobo.mybluemix.net/api"
#define LIST_URL @"holograms"

#endif
