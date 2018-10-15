//
//  HWTimePickerView.m
//  222
//
//  Created by 胡伟 on 2018/7/30.
//  Copyright © 2018年 ytx. All rights reserved.
//

#import "HWPickerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HWPickerView() <UIPickerViewDelegate, UIPickerViewDataSource> {
    didSelectDate selectDateBlock;
    didSelectTime selectTimeBlock;
    didSelectArea selectAreaBlock;
    NSDate *_date;
    NSString *_min, *_sec;
    NSString *_prov, *_city, *_area;
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation HWPickerView

- (NSArray *)firstDataArray {
    if (!_firstDataArray) {
        _firstDataArray = @[@"1", @"2", @"3", @"4", @"5"];
    }
    return _firstDataArray;
}

- (NSArray *)secondDataArray {
    if (!_secondDataArray) {
        _secondDataArray = @[@"0", @"15", @"30", @"45"];
    }
    return _secondDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame.origin = CGPointZero;
    frame.size.width = kScreenWidth;
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

// MARK: - Normal Set
- (void)initial {
    [self setUpInitailUI];
    
    [self setUpInitialData];
}

- (void)setUpInitailUI {
    self.hidden = YES;
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.61];
    [self addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchDown];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.containerView = view;
    
    if (_viewType == HWPickerViewTypeForDate) {
        UIDatePicker *datePicker = [UIDatePicker new];
        datePicker.frame = (CGRect){0, 44, kScreenWidth, kScreenWidth / 1.48148f};
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        [view addSubview:datePicker];
        self.datePicker = datePicker;
        view.frame = (CGRect){0, 0, kScreenWidth, datePicker.frame.size.height + 44};
    }
    else {
        UIPickerView *pickerView = [UIPickerView new];
        pickerView.frame = (CGRect){0, 44, kScreenWidth, kScreenWidth / 1.48148f};
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.backgroundColor = [UIColor whiteColor];
        [view addSubview:pickerView];
        self.pickerView = pickerView;
        [pickerView reloadAllComponents];
        view.frame = (CGRect){0, 0, kScreenWidth, pickerView.frame.size.height + 44};
    }
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 44}];
    UIBarButtonItem *tbCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnClick)];
    UIBarButtonItem *tbSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *tbDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnClick)];
    tbCancel.tintColor = [UIColor lightGrayColor];
    tbDone.tintColor = _tintColor ?: [UIColor blueColor];
    [toolbar setItems:@[tbCancel, tbSpace, tbDone,]];
    [view addSubview:toolbar];
}

- (void)setUpInitialData {
    switch (_viewType) {
        case HWPickerViewTypeForTime: {
             _min = self.firstDataArray[0];
            _sec = self.secondDataArray[0];
        }   break;
        case HWPickerViewTypeForArea: {
            _firstDataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RealAreaList" ofType:@"plist"]];
            _secondDataArray = _firstDataArray[0][@"cities"];
            _thirdDataArray = _secondDataArray[0][@"areas"];
            _prov = self.firstDataArray[0][@"province"];
            _city = self.secondDataArray[0][@"city"];
            _area = self.thirdDataArray[0];
        }   break;
        default:
            break;
    }
}

- (void)setFrame:(CGRect)frame {
    frame.origin = CGPointZero;
    frame.size.width = kScreenWidth;
    self.containerView.center = (CGPoint){frame.size.width / 2, frame.origin.y + (self.containerView.frame.size.height / 2)};
    [super setFrame:frame];
}

- (void)setViewType:(HWPickerViewType)viewType {
    _viewType = viewType;
    [self initial];
}

- (void)setLocale:(NSLocale *)locale {
    _locale = locale;
    self.datePicker.locale = locale;
}

- (void)selectDate:(didSelectDate)block {
    self.viewType = HWPickerViewTypeForDate;
    selectDateBlock = block;
}

- (void)selectTime:(didSelectTime)block {
    self.viewType = HWPickerViewTypeForTime;
    selectTimeBlock = block;
}

- (void)selectArea:(didSelectArea)block {
    self.viewType = HWPickerViewTypeForArea;
    selectAreaBlock = block;
}

- (void)show {
    if ([self superview] != nil) {
        [[self superview] bringSubviewToFront:self];
        self.frame = (CGRect){CGPointZero, [self superview].frame.size};
    }
    self.alpha = 0;
    self.hidden = NO;
    
    self.containerView.center = (CGPoint){self.frame.size.width / 2, self.frame.size.height + (self.containerView.frame.size.height / 2)};
    CGPoint center = (CGPoint){self.frame.size.width / 2, self.frame.size.height - (self.containerView.frame.size.height / 2)};
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.center = center;
        self.alpha = 1;
    } completion:^(BOOL finished) {}];
}

- (void)showInView:(UIView *)view {
    if ([self superview] == nil) {
        [view addSubview:self];
    }
    [self show];
}

- (void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.pickerView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    for (int i=0; i<nameArr.count; i++) {
        CGFloat labelX = _pickerView.frame.size.width / (nameArr.count * 2) + 18 + _pickerView.frame.size.width/nameArr.count * i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, self.pickerView.frame.size.height / 2 - 7.5, 18, 18)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor darkGrayColor];
        label.backgroundColor = [UIColor clearColor];
        [self.pickerView addSubview:label];
    }
}

// MARK: - Button Action
- (void)doneBtnClick {
    [self done];
}

- (void)cancelBtnClick {
    [self dissMissView];
}

- (void)done {
    switch (_viewType) {
        case HWPickerViewTypeForDate: {
            //NSString *selectTime = [NSString stringWithFormat:@"%ld",(long)[self.datePicker.date timeIntervalSince1970]];
            _date = self.datePicker.date;
            selectDateBlock(_date);
        }   break;
        case HWPickerViewTypeForTime: {
            selectTimeBlock(_min, _sec);
        }   break;
        case HWPickerViewTypeForArea: {
            selectAreaBlock(_prov, _city, _area);
        }   break;
        default:
            break;
    }
    [self dissMissView];
}

- (void)dissMissView {
    self.hidden = NO;
    self.alpha = 1;
    CGPoint center = self.containerView.center;
    center.y = self.frame.size.height + center.y;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
        self.containerView.center = center;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.containerView.center = (CGPoint){kScreenWidth / 2, self.frame.size.height - (self.containerView.frame.size.height / 2)};
        
        if (self.removeWhenDismissed) {
            [self removeFromSuperview];
        }
    }];
}

//- (void)setTintColor:(UIColor *)tintColor {
//    for (id one in [_containerView subviews]) {
//        if ([one isKindOfClass:[UIToolbar class]]) {
//            for (UIBarButtonItem *item in [one items]) {
//                item.tintColor = tintColor;
//            }
//        }
//    }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (_viewType) {
        case HWPickerViewTypeForTime: {
            _min = self.firstDataArray[[pickerView selectedRowInComponent:0]];
            if (component == 0) {
                if (row == self.firstDataArray.count - 1) {
                    [pickerView selectRow:0 inComponent:1 animated:YES];
                }
            }
            else if (component == 1) {
                if ([pickerView selectedRowInComponent:0] == self.firstDataArray.count - 1) {
                    [pickerView selectRow:0 inComponent:1 animated:YES];
                }
            }
            _sec = self.secondDataArray[[pickerView selectedRowInComponent:1]];
        }   break;
        case HWPickerViewTypeForArea: {
            if (component == 0) {
                _secondDataArray = _firstDataArray[row][@"cities"];
                _thirdDataArray = _secondDataArray[0][@"areas"];
                [pickerView selectRow:0 inComponent:1 animated:NO];
                [pickerView selectRow:0 inComponent:2 animated:NO];
                [pickerView reloadComponent:1];
                [pickerView reloadComponent:2];
            } else if (component == 1) {
                _thirdDataArray = _secondDataArray[row][@"areas"];
                [pickerView selectRow:0 inComponent:2 animated:NO];
                [pickerView reloadComponent:2];
            }
            [_secondDataArray count] == 0 ? _secondDataArray = nil : 0;
            [_thirdDataArray count] == 0 ? _thirdDataArray = nil : 0;
            _prov = _firstDataArray[[pickerView selectedRowInComponent:0]][@"province"];
            _city = _secondDataArray[[pickerView selectedRowInComponent:1]][@"city"];
            _area = _thirdDataArray[[pickerView selectedRowInComponent:2]];
        }   break;
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (_viewType) {
        case HWPickerViewTypeForTime:
            [self addLabelWithName:@[@"时",@"分"]];
            return 2;
        case HWPickerViewTypeForArea:
            return 3;
        default:
            return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rows = 0;
    switch (component) {
        case 0: {
            rows = self.firstDataArray.count;
        }   break;
        case 1: {
            rows = self.secondDataArray.count;
        }   break;
        case 2: {
            rows = self.thirdDataArray.count;
        }   break;
        default:
            break;
    }
    return rows;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:24]];
    }
    NSString *title = @"";
    switch (_viewType) {
        case HWPickerViewTypeForTime: {
            switch (component) {
                case 0: {
                    title = self.firstDataArray[row];
                }   break;
                case 1: {
                    title = self.secondDataArray[row];
                }   break;
                default:
                    break;
            }
        }   break;
        case HWPickerViewTypeForArea: {
            switch (component) {
                case 0: {
                    title = self.firstDataArray[row][@"province"];
                }   break;
                case 1: {
                    title = self.secondDataArray[row][@"city"];
                }   break;
                case 2: {
                    title = self.thirdDataArray[row];
                }   break;
                default:
                    break;
            }
        }   break;
        default:
            break;
    }
    customLabel.text = title;
    customLabel.textColor = [UIColor blackColor];
    return customLabel;
}
@end
