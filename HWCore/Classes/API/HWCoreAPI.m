//
//  HWCoreAPI.m
//  HWCore
//
//  Created by apple on 2018/9/13.
//

#import "HWCoreAPI.h"
#import "HWCore.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"
#import <CommonCrypto/CommonDigest.h>

static HWCoreAPI *api = nil;
static AFHTTPSessionManager *manager = nil;

@interface HWCoreAPI ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HWCoreAPI

+ (instancetype)sharedAPI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[HWCoreAPI alloc] init];
    });
    return api;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        AFHTTPRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        NSString *timeStr = [self requestGMTTime:[NSDate date]];
        [requestSerializer setValue:timeStr forHTTPHeaderField:@"Date"];
        [requestSerializer setValue:[[self md5:[NSString stringWithFormat:@"%@%@",timeStr,@"tr34622587abc831da4e9183e3e23e6db7149e"]] lowercaseString] forHTTPHeaderField:@"Authorization"];
        requestSerializer.timeoutInterval = 15;
        _manager.requestSerializer = requestSerializer;
        
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];;
        _manager.securityPolicy.validatesDomainName = NO;
        _manager.securityPolicy.allowInvalidCertificates = YES;
    };
    return _manager;
}

- (NSString*)requestGMTTime:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss yyyy";
    return [dateFormatter stringFromDate:date];
}

- (NSString *)md5:(NSString *)str {
    NSData *utfStr = [str dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(utfStr.bytes, (CC_LONG)[utfStr length], result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
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

- (NSString *)getAbsolutePath:(NSString *)path {
    //BASEURL = SCHEME + DOMAIN + PORT
    NSString *baseUrl;
    if ([HWCore sharedCore].debug) {
        baseUrl = [[HWCore sharedCore] valueForConfWithKey:@"baseurl-dev"];
    }
    else {
        baseUrl = [[HWCore sharedCore] valueForConfWithKey:@"baseurl"];
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, path];
}

- (id)GETAbsolutePath:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler {
    return [[HWCoreAPI sharedAPI].manager GET:path parameters:params progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 completionHandler(responseObject,nil);
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 completionHandler(nil,error);
                             }];
}

- (id)GET:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler {
    NSString *absolutePath = [self getAbsolutePath:path];
    return [self GETAbsolutePath:absolutePath parameters:params completionHandler:completionHandler];
}

- (id)POSTAbsolutePath:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler {
    return [[HWCoreAPI sharedAPI].manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil,error);
    }];
}

- (id)POST:(NSString *)path parameters:(NSDictionary *)params completionHandler:(void (^)(id, NSError *))completionHandler {
    NSString *absolutePath = [self getAbsolutePath:path];
    return [self POSTAbsolutePath:absolutePath parameters:params completionHandler:completionHandler];
}

+ (void)GetImage:(NSString *)path completionHandler:(void (^)(id, NSError *))completionHandler {
    if (path.length == 0 || [path isEqualToString:@""] || path == nil) {
        return;
    }
    AFImageDownloader *imgd = [AFImageDownloader defaultInstance];
    [imgd downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        completionHandler(responseObject,nil);
        NSLog(@"\n\nREQUEST(DOWNLOAD IMAGE) SUCCESS\n\tURL\t%@\n", request.URL.absoluteString);
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        completionHandler(nil,error);
        NSLog(@"\n\nREQUEST(DOWNLOAD IMAGE) FAILED\n\tURL\t%@\n", request.URL.absoluteString);
    }];
}

+ (NSURLSessionDataTask *)POSTImage:(UIImage *)image progress:(void (^)(float, float))progress completionHandler:(void (^)(id, NSError *))completionHandler {
    NSString *URLString = @"上传地址";
    NSString *filename = @"filename";
    NSDictionary *param = @{@"name":filename,};
    NSURLSessionDataTask *dataTask = [[HWCoreAPI sharedAPI].manager POST:URLString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
