//
//  HWCoreAPI.m
//  HWCore
//
//  Created by apple on 2018/9/13.
//

#import "HWCoreAPI.h"
#import "AFNetworking.h"

static HWCoreAPI *api = nil;
static AFHTTPSessionManager *manager = nil;

@implementation HWCoreAPI

+ (instancetype)sharedAPI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[HWCoreAPI alloc] init];
    });
    return api;
}

+ (AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    });
    return manager;
}

+ (id)GET:(NSString *)path parameters:(NSDictionary *)paras completionHandler:(void (^)(id, NSError *))complete {
    //打印网络请求， DDLog  与  NSLog 功能一样
    //DDLogVerbose(@"Request Path: %@, params %@", path, paras);
    return [[self sharedManager] GET:path parameters:paras progress:nil
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  complete(responseObject,nil);
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  complete(nil,error);
                              }];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))complete {
    return [[self sharedManager] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil,error);
    }];
}

- (void)startMonitoring {
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //当前的网络状态
        _networkStatus = status;
        // 当网络状态改变了, 就会调用这个block
        switch (status){
                case AFNetworkReachabilityStatusUnknown: // 未知网络
                _isNetworking = YES;
                break;
                case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                _isNetworking = NO;
                break;
                case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                _isNetworking = YES;
                break;
                case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                _isNetworking = YES;
                break;
        }
    }];
    [mgr startMonitoring];
}


@end
