//
//  HWCore.m
//  HWCore
//
//  Created by 胡伟 on 2019/1/14.
//

#import "HWCore.h"
#import "FCFileManager.h"

NSString *const LIB_BUNDLE_ID = @"HWCore";
NSString *const CONFIG_NAME = @"HWCoreConfig";

@implementation HWCore

+ (instancetype)sharedCore {
    static HWCore *core;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        core = [[HWCore alloc] init];
    });
    return core;
}

// MARK: - CONF

- (NSDictionary *)conf {
    
    NSString *confpath;
    
    confpath = [[NSBundle mainBundle] pathForResource:CONFIG_NAME ofType:@"plist"];
    
    if (confpath == nil || [confpath isEqualToString:@""] == YES || [FCFileManager isFileItemAtPath:confpath] == NO) {
        
        NSLog(@"HWCore WARNING\n\tAPP CONFIGURATION FILE WAS NOT FOUND.\n\t%@", confpath);
        
        // FALLBACK TO LIB DEFAULT
        confpath = [[NSBundle bundleWithIdentifier:LIB_BUNDLE_ID] pathForResource:CONFIG_NAME ofType:@"plist"];
    }
    
    // TRY TO READ APP CONFIGURATION
    NSDictionary *conf = [FCFileManager readFileAtPathAsDictionary:confpath];
    
    if (conf == nil) {
        NSLog(@"HWCore ERROR\n\tCONFIGURATION FILE WAS NEVER FOUND.");
    }
    
    return conf;
}

- (id)valueForConfWithKey:(NSString *)keys {
    
    // IF
    if (keys == nil || [keys isEqualToString:@""] || [keys isKindOfClass:[NSString class]] == NO) {
        return nil;
    }
    
    // GET VALUE
    if ([self conf][keys]) {
        return [self conf][keys];
    }else{
        NSString *confpath = [[NSBundle bundleWithIdentifier:LIB_BUNDLE_ID] pathForResource:CONFIG_NAME ofType:@"plist"];
        NSDictionary *conf = [FCFileManager readFileAtPathAsDictionary:confpath];
        return conf[keys];
    }
}

@end
