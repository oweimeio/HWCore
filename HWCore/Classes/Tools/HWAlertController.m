//
//  HWAlertController.m
//  HWCore
//
//  Created by hw on 2018/9/8.
//

#import "HWAlertController.h"

@interface HWAlertController ()

@end

@implementation HWAlertController

+ (instancetype)HWAlertWithDefaultMessage:(NSString *)defaultMessage title:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    HWAlertController *alertController = [HWAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:defaultMessage style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:defaultAlertAction];
    return alertController;
}

+ (instancetype)HWAlertWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)preferredStyle cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonBlock:(void (^)(void))cancelBlock otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles otherButtonsBlock:(void (^)(NSInteger index))otherButtonsBlock {
    HWAlertController *alertController = [HWAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (cancelButtonTitle.length > 0 ) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                                   if (cancelBlock) {
                                                                       cancelBlock();
                                                                   }
                                                               }];
        [alertController addAction:cancelAction];
    }
    
    for (NSInteger i = 0; i < otherButtonTitles.count; i++) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitles[i]
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if (otherButtonsBlock) {
                                                                    otherButtonsBlock(i);
                                                                }
                                                            }];
        [alertController addAction:otherAction];
    }
    return alertController;
}

- (void)show {
    [[self getCurrentVC] presentViewController:self animated:YES completion:nil];
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    result = nextResponder;
    else
    result = window.rootViewController;
    return result;
}

@end

