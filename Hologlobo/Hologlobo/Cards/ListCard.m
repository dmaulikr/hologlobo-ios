//
//  ListCard.m
//  Hologlobo
//
//  Created by Fabio Dela Antonio on 9/5/15.
//  Copyright (c) 2015 hologlobo. All rights reserved.
//

#import "ListCard.h"
#import "NSAttributedString+bbCode.h"
#import "UIColor+Hex.h"

#import "ViewController.h"
#import "fopen+Bundle.h"

#import "BNNetworkManager.h"
#import "BNGenericRequest.h"

#import "General.h"

@interface ListCard ()
@property (nonatomic, retain) NSDictionary * data;
@property (nonatomic, retain) UIAlertView * loadingAlert;
@end

@implementation ListCard

+ (instancetype)cardWithData:(NSDictionary *)data {
    
    ListCard * card = [[[self alloc] init] autorelease];
    [card setData:data];
    return card;
}

- (NSArray *)cellControllers {
    
    NSMutableArray * cells = [NSMutableArray array];
    
    UIColor * background = [UIColor colorFromHexString:@"3D4A59"];
    UIColor * separator = [UIColor colorFromHexString:@"E6E6E6"];
    
    [cells addObject:[[BNEmptyCell emptyCellWithHeight:4.f colour:background] withTarget:self action:@selector(openModel)]];
    [cells addObject:[[BNTextCell textCellWithText:BBF("[color hex=\"FFFFFF\"][font size=\"24\"]%@[/font][/color]", _data[@"name"]) bgColour:background centred:NO] withTarget:self action:@selector(openModel)]];
    [cells addObject:[[BNEmptyCell emptyCellWithHeight:4.f colour:background] withTarget:self action:@selector(openModel)]];
    [cells addObject:[BNSeparatorCell separatorCellWithColour:separator]];
    [cells addObject:[[BNEmptyCell emptyCellWithHeight:4.f colour:background] withTarget:self action:@selector(openModel)]];
    [cells addObject:[[BNTextCell textCellWithText:BBF("[color hex=\"FFFFFF\"][font size=\"18\"]%@[/font][/color]", _data[@"category"]) bgColour:background centred:NO] withTarget:self action:@selector(openModel)]];
    [cells addObject:[[BNEmptyCell emptyCellWithHeight:4.f colour:background] withTarget:self action:@selector(openModel)]];
    
    if([_data[@"timestamp"] isKindOfClass:[NSString class]] && ![_data[@"timestamp"] isEqualToString:@""]) {
        
        NSString * dateString = @"";
        NSDate * date = nil;
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        date = [df dateFromString:_data[@"timestamp"]];
        
        [df setDateFormat:@"dd/MM/yyyy"];
        dateString = [df stringFromDate:date];
        [df release], df = nil;
        
        [cells addObject:[BNSeparatorCell separatorCellWithColour:separator]];
        [cells addObject:[[BNEmptyCell emptyCellWithHeight:4.f colour:background] withTarget:self action:@selector(openModel)]];
        [cells addObject:[[BNTextCell textCellWithText:BBF("[color hex=\"FFFFFF\"][font size=\"18\"]%@[/font][/color]", dateString) bgColour:background centred:NO] withTarget:self action:@selector(openModel)]];
        [cells addObject:[[BNEmptyCell emptyCellWithHeight:4.f colour:background] withTarget:self action:@selector(openModel)]];
    }
    
    [cells addObject:SPACE_CELL(8.f)];
    
    return cells;
}

- (void)openModel {
    
    /* Nao ideal... fazendo download aqui... */
    
    NSString * directory = _data[@"_id"];
    
    if(documentsDirectoryExists(directory)) {
        
        [self open];
    }
    
    else {
        
        NSString * documentsPath = documentsPathForDirectory(_data[@"_id"]);
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil]; /* caminho feliz... */
        
        [_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
        [_loadingAlert release], _loadingAlert = nil;
        
        _loadingAlert = [[UIAlertView alloc] initWithTitle:@"Aguarde" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [_loadingAlert show];
        
        /* Esta feio... seria bom criar classes pros requests, fazer validacoes, etc... Nao da tempo */
        NSString * path = [BASE_URL stringByAppendingPathComponent:LIST_URL];
        NSString * modelPath = [[path stringByAppendingPathComponent:_data[@"_id"]] stringByAppendingPathComponent:@"model"];

        [BNNetworkManager cancelRequestsWithTag:@"download"];
        [BNNetworkManager addRequest:[BNGenericRequest genericRequestWithTag:@"download" urlRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:modelPath]] successHandler:^(BNGenericRequest *request, NSData *data, NSDictionary *responseHeader) {
            
            NSString * filePath = [documentsPathForDirectory(_data[@"_id"]) stringByAppendingPathComponent:@"model.obj"];
            [data writeToFile:filePath atomically:YES];
            
            NSString * texturePath = [[path stringByAppendingPathComponent:_data[@"_id"]] stringByAppendingPathComponent:@"texture"];
            
            [BNNetworkManager cancelRequestsWithTag:@"download"];
            [BNNetworkManager addRequest:[BNGenericRequest genericRequestWithTag:@"download" urlRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:texturePath]] successHandler:^(BNGenericRequest *request, NSData *data, NSDictionary *responseHeader) {
                
                NSString * filePath = [documentsPathForDirectory(_data[@"_id"]) stringByAppendingPathComponent:@"model.bmp"];
                [data writeToFile:filePath atomically:YES];
                
                NSString * mtl = [[path stringByAppendingPathComponent:_data[@"_id"]] stringByAppendingPathComponent:@"mtl"];
                
                [BNNetworkManager cancelRequestsWithTag:@"download"];
                [BNNetworkManager addRequest:[BNGenericRequest genericRequestWithTag:@"download" urlRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mtl]] successHandler:^(BNGenericRequest *request, NSData *data, NSDictionary *responseHeader) {
                    
                    NSString * filePath = [documentsPathForDirectory(_data[@"_id"]) stringByAppendingPathComponent:@"model.mtl"];
                    [data writeToFile:filePath atomically:YES];
                    
                    [self open];
                    
                } failHandler:^(BNGenericRequest *request, NSDictionary *responseHeader) {
                    
                    [self fail];
                }]];
                
            } failHandler:^(BNGenericRequest *request, NSDictionary *responseHeader) {
                
                [self fail];
            }]];
            
        } failHandler:^(BNGenericRequest *request, NSDictionary *responseHeader) {
            
            [self fail];
        }]];
    }
}
                                      
- (void)fail {

    [_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    [_loadingAlert release], _loadingAlert = nil;
    
    ERROR_ALERT(@"Falha no download!");
    [[NSFileManager defaultManager] removeItemAtPath:documentsPathForDirectory(_data[@"_id"]) error:nil];
}

- (void)open {
    
    [_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    [_loadingAlert release], _loadingAlert = nil;
    
    /* feio... */
    setDocumentsDirectory(_data[@"_id"]);
    
    /* Modelo sempre se chama "model" */
    [self.viewController.navigationController pushViewController:[ViewController viewControllerWithFile:@"model.obj"] animated:YES];
}

- (void)dealloc {
    
    [BNNetworkManager cancelRequestsWithTag:@"download"];
    [_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    [_loadingAlert release], _loadingAlert = nil;
    [_data release], _data = nil;
    [super dealloc];
}

@end
