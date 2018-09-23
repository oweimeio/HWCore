//
//  HWProgressHUD.m
//  HWCore
//
//  Created by apple on 2018/9/20.
//

#import "HWProgressHUD.h"

@implementation HWProgressHUD

+ (void)hwDefaultConfigrations {
    [SVProgressHUD setDefaultStyle: SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval: 1.0];
}

@end

@implementation SVProgressHUD (Additions)

+ (void)showSuccessWithFormatStatus:(NSString *)format, ... {
    va_list args;
    id ret;
    
    va_start(args, format);
    if (format == nil) {
        ret = nil;
    } else {
        ret = [[NSString alloc] initWithFormat:format arguments:args];
    }
    va_end(args);
    
    if (ret != nil) {
        [SVProgressHUD showSuccessWithStatus:ret];
    } else {
        [SVProgressHUD showSuccessWithStatus:@""];
    }
}

+ (void)showErrorWithFormatStatus:(NSString *)format, ... {
    
    va_list args;
    id ret;
    
    va_start(args, format);
    if (format == nil) {
        ret = nil;
    } else {
        ret = [[NSString alloc] initWithFormat:format arguments:args];
    }
    va_end(args);
    
    if (ret != nil) {
        [SVProgressHUD showErrorWithStatus:ret];
    } else {
        [SVProgressHUD showErrorWithStatus:@""];
    }
}

// SHOW HUD WHEN IT'S VISIBLE
+ (void)tryToShowErrorWithFormatStatus:(NSString *)format, ... {
    
    va_list args;
    id ret;
    
    va_start(args, format);
    if (format == nil) {
        ret = nil;
    } else {
        ret = [[NSString alloc] initWithFormat:format arguments:args];
    }
    va_end(args);
    
    if (ret != nil && [SVProgressHUD isVisible]) {
        [SVProgressHUD showErrorWithStatus:ret];
    } else if ([SVProgressHUD isVisible]) {
        [SVProgressHUD showErrorWithStatus:@""];
    } else {
        // DO NOTHING
    }
    
}

+ (void)showMessage:(NSString *)message withDelay:(NSInteger)seconds {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showImage:nil status:message];
    });
}

+ (void)showProgressHideAfter:(NSInteger)seconds {
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
