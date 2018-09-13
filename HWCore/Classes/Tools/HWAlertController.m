//
//  HWAlertController.m
//  HWCore
//
//  Created by apple on 2018/9/8.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
