//
//  NSUserDefaultsModel.h
//  NSUserDefaultsModel
//
//  Created by apple on 2018/7/19.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultsModel : NSObject

// Value types
typedef NS_ENUM(NSInteger, NSUserDefaultsValueType) {
    NSUserDefaultsValueTypeInteger,         // NSInteger
    NSUserDefaultsValueTypeLong,            // Include:long,long long,short and unsigned
    NSUserDefaultsValueTypeFloat,
    NSUserDefaultsValueTypeDouble,
    NSUserDefaultsValueTypeBool,
    NSUserDefaultsValueTypeObject,
    NSUserDefaultsValueTypeUnknown
};

/**
 If set yes , when you setValue nil should be return default value
 */
@property (nonatomic, assign) BOOL isReturnDefaultValue;

// Init
+ (instancetype)userDefaultsModel;

// Set default values
/**
 * Override this method,you can setup default values
 * Description: If the object has two properties such as 'name' and 'gender',you should return @{@"name": @"defaultName", @"gender": @defaultGender}
 */
- (NSDictionary *)setupDefaultValues;

@end