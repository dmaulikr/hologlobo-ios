//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTable.h"
#import "BNCard.h"

@class BNCardListView;

@protocol BNCardListViewDelegate <NSObject>

@optional
- (void)cardListDidReachEnd:(BNCardListView *)list;

@end

@interface BNCardListView : BNTableView

@property (nonatomic, assign) id<BNCardListViewDelegate> cardListDelegate;

- (void)setCards:(NSArray *)cards; // of BNCard
- (void)setCards:(NSArray *)cards withSpace:(BOOL)space;
- (void)appendCards:(NSArray *)cards;

@end
