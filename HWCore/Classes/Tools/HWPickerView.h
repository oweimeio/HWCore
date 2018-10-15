//
//  HWTimePickerView.h
//  222
//
//  Created by 胡伟 on 2018/7/30.
//  Copyright © 2018年 ytx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectDate)(NSDate *date);

typedef void(^didSelectTime)(NSString *min, NSString *sec);

typedef void(^didSelectArea)(NSString *prov, NSString *city, NSString *area);

typedef NS_ENUM(NSUInteger, HWPickerViewType) {
    HWPickerViewTypeForDate,
    HWPickerViewTypeForTime,
    HWPickerViewTypeForArea,
};

@interface HWPickerView : UIControl

@property (nonatomic, assign) BOOL removeWhenDismissed;

@property (nonatomic, strong) NSArray *firstDataArray;

@property (nonatomic, strong) NSArray *secondDataArray;

@property (nonatomic, strong) NSArray *thirdDataArray;

@property (nonatomic, assign) HWPickerViewType viewType;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) NSLocale *locale;

- (void)showInView:(UIView *)view;

- (void)selectDate:(didSelectDate)block;

- (void)selectTime:(didSelectTime)block;

- (void)selectArea:(didSelectArea)block;

@end
