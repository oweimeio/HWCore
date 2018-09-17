//
//  HWCoreAPI.h
//  HWCore
//
//  Created by apple on 2018/9/13.
//

#import <Foundation/Foundation.h>

#define kCompletionHandler completionHandler:(void(^)(id responseObj, NSError *error))completionHandler

@interface HWCoreAPI : NSObject

/** 对AFHTTPSessionManager的GET请求方法进行了封装 */
+ (id)GET:(NSString *)path parameters:(NSDictionary *)paras completionHandler:(void (^)(id responseObj,NSError * error))complete;

/** 对AFHTTPSessionManager的POST请求方法进行了封装 */
+ (id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj, NSError *error))complete;

@end
