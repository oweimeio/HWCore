//
//  HWCoreAPI.m
//  HWCore
//
//  Created by apple on 2018/9/13.
//

#import "HWCoreAPI.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"

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

+ (void)GetImage:(NSString *)path completionHandler:(void (^)(id, NSError *))complete {
    if (path.length == 0 || [path isEqualToString:@""] || path == nil) {
        return;
    }
    AFImageDownloader *imgd = [AFImageDownloader defaultInstance];
    [imgd downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        complete(responseObject,nil);
        NSLog(@"\n\nREQUEST(DOWNLOAD IMAGE) SUCCESS\n\tURL\t%@\n", request.URL.absoluteString);
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        complete(nil,error);
        NSLog(@"\n\nREQUEST(DOWNLOAD IMAGE) FAILED\n\tURL\t%@\n", request.URL.absoluteString);
    }];
}

+ (NSURLSessionDataTask *)POSTImage:(UIImage *)image progress:(void (^)(float, float))progress completionHandler:(void (^)(id, NSError *))completionHandler {
    NSString *URLString = @"上传地址";
    NSString *filename = @"filename";
    NSDictionary *param = @{@"name":filename,};
    NSURLSessionDataTask *dataTask = [[self sharedManager] POST:URLString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:@"ios" fileName:filename mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable resp) {
        if ([resp[@"code"] integerValue] == 0) {
            completionHandler(resp[@"data"], nil);
            NSLog(@"\n\nUPLOAD IMAGE(POST) SUCCESS\n\tAPI\t%@\n\tRESULT\t%@\n ", URLString, resp[@"data"]);
        } else {
            completionHandler(nil, resp);
            NSLog(@"\n\nUPLOAD IMAGE(POST) ERROR\n\tAPI\t%@\n\tERROR\tCODE=%@\tMSG=%@\n ", URLString, resp[@"code"], resp[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
        NSLog(@"\n\nUPLOAD IMAGE(POST) FAILED\n\tAPI\t%@\n", URLString);
    }];
    
    return dataTask;
}


@end
