//
//  HWUserDefaultsModel.h
//  HWCore
//
//  Created by apple on 2018/9/23.
//

#import "NSUserDefaultsModel.h"

@interface HWUserDefaultsModel : NSUserDefaultsModel

//example
@property (nonatomic, copy)    NSString *name;
@property (nonatomic, assign)  NSInteger gender;
@property (nonatomic, assign)  long age;
@property (nonatomic, assign)  float floatNumber;
@property (nonatomic, assign)  double doubleNumber;
@property (nonatomic, assign)  BOOL isMan;

@end
