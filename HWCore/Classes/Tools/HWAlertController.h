//
//  HWAlertController.h
//  HWCore
//
//  Created by apple on 2018/9/8.
//

#import <UIKit/UIKit.h>

@interface HWAlertController : UIAlertController

/**
 INITIRAL FUNCTION
 */
+ (instancetype)HWAlertWithDefaultMessage:(NSString *)defaultMessage title:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 SHOW STYLE
 */
- (void)show;


@end
