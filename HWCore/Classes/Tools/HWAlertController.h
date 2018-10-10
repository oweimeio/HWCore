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

+ (instancetype)HWAlertWithTitle:(nullable NSString *)title
                               message:(nullable NSString *)message
                                 style:(UIAlertControllerStyle)preferredStyle
                     cancelButtonTitle:(nonnull NSString *)cancelButtonTitle
                     cancelButtonBlock:(void(^)(void))cancelBlock
                     otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles
                     otherButtonsBlock:(void(^)(NSInteger index))otherButtonsBlock;

/**
 展示方式
 */
- (void)show;

@end

