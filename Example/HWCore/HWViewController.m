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
    HWAlertController *alertContrller = [HWAlertController HWAlertWithDefaultMessage:@"好的" title:nil message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    [alertContrller show];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
