//
//  Created by Fabio.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNCardListView.h"
#import "UIView+ParentViewController.h"

@interface BNCardListView ()
@property (nonatomic, retain) NSMutableArray * mcards; // of BNCard
@end

@implementation BNCardListView

- (void)setCards:(NSArray *)cards {
    [self setCards:cards withSpace:YES];
}

- (void)setCards:(NSArray *)cards withSpace:(BOOL)space {
    
    [_mcards release], _mcards = nil;
    _mcards = [[NSMutableArray alloc] initWithArray:cards];
    [self updateCellsWithSpace:space];
}

- (void)appendCards:(NSArray *)cards {
    
    if(_mcards == nil) {
        
        _mcards = [[NSMutableArray alloc] init];
    }
    
    [_mcards addObjectsFromArray:cards];
    
    NSMutableArray * cells = [NSMutableArray array];
    
    for(BNCard * card in cards) {
        
        [card setViewController:[self parentViewController]];
        [cells addObjectsFromArray:[card cellControllers]];
    }
    
    [self appendCardsCells:cells];
}

- (void)updateCellsWithSpace:(BOOL)space {
    
    NSMutableArray * cells = [NSMutableArray array];
    
    if(space)
        [cells addObject:SPACE_CELL(8.f)];
    
    for(BNCard * card in _mcards) {
        
        if(![card isKindOfClass:[BNCard class]]) {
            
            continue;
        }
        
        [card setViewController:[self parentViewController]];
        [cells addObjectsFromArray:[card cellControllers]];
    }
    
    [self setCells:cells];
}

- (void)appendCardsCells:(NSArray *)cells {
    
    [self appendCellControllers:cells];
}

- (void)willDisplayLastController {
    
    [super willDisplayLastController];
    
    if([self.mcards count] > 0) {
        
        if(self.cardListDelegate && [self.cardListDelegate respondsToSelector:@selector(cardListDidReachEnd:)]) {
            
            [self.cardListDelegate cardListDidReachEnd:self];
        }
    }
}

- (void)dealloc {
    
    [_mcards release], _mcards = nil;
    [super dealloc];
}

@end
