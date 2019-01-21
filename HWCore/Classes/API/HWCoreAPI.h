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

/**
 当前网络状态
 */
@property (assign, nonatomic, readonly) HWNetworkReachabilityStatus networkStatus;

/**
 是否有网络
 */
@property (assign, nonatomic) BOOL isNetworking;

+ (instancetype)sharedAPI;

/** 监测网络*/
- (void)startMonitoring;

- (id)GETAbsolutePath:(NSString *)path parameters:(NSDictionary *)params kCompletionHandler;

- (id)POSTAbsolutePath:(NSString *)path parameters:(NSDictionary *)params kCompletionHandler;

- (id)GET:(NSString *)path parameters:(NSDictionary *)params kCompletionHandler;

- (id)POST:(NSString *)path parameters:(NSDictionary *)params kCompletionHandler;

- (void)GetImage:(NSString *)path kCompletionHandler;

//上传图片
- (NSURLSessionDataTask *)POSTImage:(UIImage *)image
                           progress:(void (^)(float, float))progress kCompletionHandler;
@end
