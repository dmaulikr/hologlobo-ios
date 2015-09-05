//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#ifndef _BNTable_h
#define _BNTable_h

#import "BNTableView.h"

/* Cells */
#import "BNDetailTextCell.h"
#import "BNEmptyCell.h"
#import "BNImageCell.h"
#import "BNSeparatorCell.h"
#import "BNStaticImageCell.h"
#import "BNTextCell.h"
#import "BNEmptySpaceCell.h"

/* Helpers */
#define SPACE_CELL(X)        [BNEmptySpaceCell emptySpaceCellWithHeight:(X)]
#define PADDING_CELL(X)      [BNEmptyCell emptyCellWithHeight:(X)]
#define SHADOW_CELL()       [BNEmptyCell emptyCellWithHeight:2.f colour:[UIColor colorFromHexString:@"C5C3C3"]]
#define SEPARATOR_CELL()    [BNSeparatorCell separatorCell]

#endif
