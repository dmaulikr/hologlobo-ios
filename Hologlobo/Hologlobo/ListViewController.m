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

#import "ViewController.h"

#import "General.h"

@implementation ListViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationController pushViewController:[ViewController viewControllerWithFile:@"eu2.obj"] animated:YES];
//    [self reload];
}



- (void)reload {
    
//    [BNNetworkManager cancelRequestsWithTag:@"list"];
//    [BNNetworkManager addRequest:[BNGenericRequest genericRequestWithTag:@"list" urlRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://hologlobo.mybluemix.net/api/holograms"]] successHandler:^(BNGenericRequest *request, NSData *data, NSDictionary *responseHeader) {
//        
//        NSError * error = nil;
//        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//        
//        if(error != nil) {
//            
//            [self fail];
//            return;
//        }
//        
//        DLog(@"result: %@", jsonData);
//        
//    } failHandler:^(BNGenericRequest *request, NSDictionary *responseHeader) {
//        
//        [self fail];
//    }]];
}

- (void)fail {
    
    ERROR_ALERT(@"Não foi possível listar as cenas.");
}

- (void)save {
    
}

- (void)dealloc {

    [BNNetworkManager cancelRequestsWithTag:@"list"];
    [super dealloc];
}

@end
