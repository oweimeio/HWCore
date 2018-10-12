//
//  HWCoreAPI.h
//  HWCore
//
//  Created by apple on 2018/9/13.
//

#import <Foundation/Foundation.h>

#define kCompletionHandler completionHandler:(void(^)(id responseObj, NSError *error))completionHandler

typedef NS_ENUM(NSInteger, HWNetworkReachabilityStatus) {
    HWNetworkReachabilityStatusUnknown          = -1,
    HWNetworkReachabilityStatusNotReachable     = 0,
    HWNetworkReachabilityStatusReachableViaWWAN = 1,
    HWNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface HWCoreAPI : NSObject

@property (assign, nonatomic, readonly) HWNetworkReachabilityStatus networkStatus;

@property (assign, nonatomic) BOOL isNetworking;

+ (instancetype)sharedAPI;

/** 监测网络*/
- (void)startMonitoring;

/** 对AFHTTPSessionManager的GET请求方法进行了封装 */
+ (id)GET:(NSString *)path parameters:(NSDictionary *)paras completionHandler:(void (^)(id responseObj,NSError * error))complete;

/** 对AFHTTPSessionManager的POST请求方法进行了封装 */
+ (id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void(^)(id responseObj, NSError *error))complete;

+ (void)GetImage:(NSString *)path completionHandler:(void(^)(id responseObj, NSError *error))complete;

//上传图片
+ (NSURLSessionDataTask *)POSTImage:(UIImage *)image
                           progress:(void (^)(float, float))progress kCompletionHandler;
@end
