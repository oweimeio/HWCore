//
//  HWAlertController.h
//  HWCore
//
//  Created by apple on 2018/9/8.
//

#import <UIKit/UIKit.h>

@interface HWAlertController : UIAlertController

/**
 初始化方法
 */
+ (instancetype)HWAlertWithDefaultMessage:(NSString *)defaultMessage title:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 展示方式
 */
- (void)show;


@end
