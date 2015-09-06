//
//  ListViewController.m
//  Hologlobo
//
//  Created by Fabio Dela Antonio on 9/5/15.
//  Copyright (c) 2015 hologlobo. All rights reserved.
//

#import "ListViewController.h"

#import "BNCardListView.h"
#import "BNNetworkManager.h"
#import "BNGenericRequest.h"

#import "General.h"

#import "ListCard.h"

@interface ListViewController ()
@property (retain, nonatomic) IBOutlet BNCardListView * cardList;
@end

@implementation ListViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self reload];
}

- (IBAction)reloadAction:(id)sender {
    
    [self.cardList setCards:@[]];
    [self reload];
}

- (void)reload {
    
    [BNNetworkManager cancelRequestsWithTag:@"list"];
    [BNNetworkManager addRequest:[BNGenericRequest genericRequestWithTag:@"list" urlRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingPathComponent:LIST_URL]]] successHandler:^(BNGenericRequest *request, NSData *data, NSDictionary *responseHeader) {
        
        NSError * error = nil;
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if(error != nil || ![jsonData isKindOfClass:[NSArray class]]) {
            
            [self fail];
            return;
        }
        
        DLog(@"result: %@", jsonData);
        
        NSMutableArray * cards = [NSMutableArray array];
        
        for(NSDictionary * entry in jsonData) {
            
            if(![entry isKindOfClass:[NSDictionary class]]) {
                
                [self fail];
                return;
            }
            
            [cards addObject:[ListCard cardWithData:entry]];
        }
        
        [self.cardList setCards:cards];
        
    } failHandler:^(BNGenericRequest *request, NSDictionary *responseHeader) {
        
        [self fail];
    }]];
}

- (void)fail {
    
    ERROR_ALERT(@"Não foi possível listar as cenas.");
}

- (void)dealloc {

    [BNNetworkManager cancelRequestsWithTag:@"list"];
    [_cardList release];
    [super dealloc];
}

@end
