//
//  HWCore.h
//  HWCore
//
//  Created by 胡伟 on 2019/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWCore : NSObject

/**
 调试模式用于选择域名等信息
 */
@property (assign, nonatomic) BOOL debug;

+ (instancetype)sharedCore;

- (id)valueForConfWithKey:(NSString *)keys;

@end

NS_ASSUME_NONNULL_END
