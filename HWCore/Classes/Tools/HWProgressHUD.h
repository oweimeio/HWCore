//
//  HWProgressHUD.h
//  HWCore
//
//  Created by apple on 2018/9/20.
//

#import <Foundation/Foundation.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface HWProgressHUD : NSObject

// YOU CAN SET YOUR FAV STYLE
+ (void)hwDefaultConfigrations;

@end

// MARK: - SVProgressHUD

@interface SVProgressHUD (Additions)

// SHOW SUCCESS STATUS WITH A STRING USING C PRINTG-STYLE FORMATTING
+ (void)showSuccessWithFormatStatus:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

// SHOW ERROR STATUS WITH A STRING USING C PRINTG-STYLE FORMATTING
+ (void)showErrorWithFormatStatus:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

// SHOW HUD WHEN IT'S VISIBLE
+ (void)tryToShowErrorWithFormatStatus:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

// SHOW HUD THEN HIDE AFTERE DELAY
+ (void)showMessage:(NSString *)message withDelay:(NSInteger)seconds;

// SHOW PROGRESS THEN HIDE AFTERE DELAY
+ (void)showProgressHideAfter:(NSInteger)seconds;

@end
