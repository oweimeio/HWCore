//
//  HWViewController.m
//  HWCore
//
//  Created by oweimeio on 07/25/2018.
//  Copyright (c) 2018 oweimeio. All rights reserved.
//

#import "HWViewController.h"
#import <HWCore/PreHeader.h>

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

- (void)btnClick {
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
