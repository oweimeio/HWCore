//
//  HWViewController.m
//  HWCore
//
//  Created by oweimeio on 07/25/2018.
//  Copyright (c) 2018 oweimeio. All rights reserved.
//

#import "HWViewController.h"
#import "PreHeader.h"
//#import <HWCore/PreHeader.h>

@interface HWViewController ()

@end

@implementation HWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc] initWithFrame:(CGRect){100, 100 ,100, 100}];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //    [g show];
    

}

- (NSString *)requestTime:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    return [dateFormatter stringFromDate:date];
}

- (void)btnClick {

//    NSDictionary *params = @{@"Request":@{
//                                     @"head":@{@"reqtime":[self requestTime:[NSDate date]],
//                                               @"useragent":@"iPhone;iPhone;11.4.1;640*1136;1.0.6"},
//                                     @"body":@{ @"loginName": @"13100000003",
//                                                @"appType":@"1",
//                                                @"userpasswd":@"dd4b21e9ef71e1291183a46b913ae6f2",
//                                                @"codeKey" : @"f4f294c2-3ad7-4774-833e-3a5e41a44798",
//                                                @"completeCode":@"49B377CD78563851BCCF05C817BE9D9B",
//                                                @"countrycode":@"+86",
//                                                @"type":@"1",
//                                                @"version":@"1.0.6"
//                                                }
//                                     }
//                             };
    NSDictionary *params = @{@"Request":@{
                                     @"head":@{@"reqtime":[self requestTime:[NSDate date]],
                                               @"useragent":@"iPhone;iPhone;11.4.1;640*1136;1.0.6"},
                                     @"body":@{ @"userAccounts": @[@"tr13120253899"],
                                                @"type":@"2",
                                                @"account":@"tr3478"
                                                }
                                     }
                             };
    
    [[HWCoreAPI sharedAPI] POST:@"/GetVOIPUserInfo" parameters:params completionHandler:^(id responseObj, NSError *error) {
        if (error) {
            return;
        }
        NSLog(@"%@", responseObj);
    }];
    return;
    
    HWAlertController *alertContrller = [HWAlertController HWAlertWithTitle:@"1" message:@"2" style:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取222消" cancelButtonBlock:^{
        
    } otherButtonTitles:@[@"1", @"2", @"3"] otherButtonsBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    }];
    [alertContrller show];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
