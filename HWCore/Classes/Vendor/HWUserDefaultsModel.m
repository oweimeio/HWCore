//
//  HWUserDefaultsModel.m
//  HWCore
//
//  Created by apple on 2018/9/23.
//

#import "HWUserDefaultsModel.h"

@implementation HWUserDefaultsModel

@dynamic name;
@dynamic gender;
@dynamic age;
@dynamic floatNumber;
@dynamic doubleNumber;
@dynamic isMan;

// MARK: - DEFAULT SETTING  (if setted value is nil, return default values)
- (NSDictionary *)setupDefaultValues {
    return @{@"name": @"yyy",
             @"gender": @1,
             @"age": @20,
             @"floatNumber": @11.1,
             @"doubleNumber": @22.2,
             @"isMan": @YES,
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"KEY:%@ is undefined", key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end
