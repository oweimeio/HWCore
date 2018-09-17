//
//  HWCoreAPI.m
//  HWCore
//
//  Created by apple on 2018/9/13.
//

#import "HWCoreAPI.h"
#import "AFNetworking.h"

static AFHTTPSessionManager * manager = nil;

@implementation HWCoreAPI

+ (AFHTTPSessionManager *)sharedAPI {
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
    return [[self sharedAPI] GET:path parameters:paras progress:nil
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  complete(responseObject,nil);
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  complete(nil,error);
                              }];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))complete {
    return [[self sharedAPI] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil,error);
    }];
}

@end
