//
//  JYUtil.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYUtil.h"
#import <SFHFKeychainUtils.h>
#import <sys/sysctl.h>
#import "JYApplicationManager.h"
#import "JYAppSpreadBannerModel.h"
#import "JYSpreadBannerViewController.h"
#import "JYAppSpread.h"

static NSString *const kRegisterKeyName         = @"JY_register_keyname";
static NSString *const kUserAccessUsername      = @"JY_user_access_username";
static NSString *const kUserAccessServicename   = @"JY_user_access_service";
static NSString *const kLaunchSeqKeyName        = @"JY_launchseq_keyname";

static NSString *const kImageTokenKeyName       = @"safiajfoaiefr$^%^$E&&$*&$*";
static NSString *const kImageTokenCryptPassword = @"wafei@#$%^%$^$wfsssfsf";

@implementation JYUtil

#pragma mark -- 注册激活

+ (NSString *)accessId {
    NSString *accessIdInKeyChain = [SFHFKeychainUtils getPasswordForUsername:kUserAccessUsername andServiceName:kUserAccessServicename error:nil];
    if (accessIdInKeyChain) {
        return accessIdInKeyChain;
    }
    
    accessIdInKeyChain = [NSUUID UUID].UUIDString.md5;
    [SFHFKeychainUtils storeUsername:kUserAccessUsername andPassword:accessIdInKeyChain forServiceName:kUserAccessServicename updateExisting:YES error:nil];
    return accessIdInKeyChain;
}

+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisterKeyName];
}

+ (BOOL)isRegistered {
    return [self userId] != nil;
}

+ (void)setRegisteredWithUserId:(NSString *)userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kRegisterKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSUInteger)launchSeq {
    NSNumber *launchSeq = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchSeqKeyName];
    return launchSeq.unsignedIntegerValue;
}

+ (void)accumateLaunchSeq {
    NSUInteger launchSeq = [self launchSeq];
    [[NSUserDefaults standardUserDefaults] setObject:@(launchSeq+1) forKey:kLaunchSeqKeyName];
}

#pragma mark - 图片加密

+ (NSString *)imageToken {
    NSString *imageToken = [[NSUserDefaults standardUserDefaults] objectForKey:kImageTokenKeyName];
    if (!imageToken) {
        return nil;
    }
    
    return [imageToken decryptedStringWithPassword:kImageTokenCryptPassword];
}

+ (void)setImageToken:(NSString *)imageToken {
    if (imageToken) {
        imageToken = [imageToken encryptedStringWithPassword:kImageTokenCryptPassword];
        [[NSUserDefaults standardUserDefaults] setObject:imageToken forKey:kImageTokenKeyName];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kImageTokenKeyName];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 设备类型

+ (BOOL)isIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (NSString *)appVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)deviceName {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *name = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return name;
}

+ (JYDeviceType)deviceType {
    NSString *deviceName = [self deviceName];
    if ([deviceName rangeOfString:@"iPhone3,"].location == 0) {
        return JYDeviceType_iPhone4;
    } else if ([deviceName rangeOfString:@"iPhone4,"].location == 0) {
        return JYDeviceType_iPhone4S;
    } else if ([deviceName rangeOfString:@"iPhone5,1"].location == 0 || [deviceName rangeOfString:@"iPhone5,2"].location == 0) {
        return JYDeviceType_iPhone5;
    } else if ([deviceName rangeOfString:@"iPhone5,3"].location == 0 || [deviceName rangeOfString:@"iPhone5,4"].location == 0) {
        return JYDeviceType_iPhone5C;
    } else if ([deviceName rangeOfString:@"iPhone6,"].location == 0) {
        return JYDeviceType_iPhone5S;
    } else if ([deviceName rangeOfString:@"iPhone7,1"].location == 0) {
        return JYDeviceType_iPhone6P;
    } else if ([deviceName rangeOfString:@"iPhone7,2"].location == 0) {
        return JYDeviceType_iPhone6;
    } else if ([deviceName rangeOfString:@"iPhone8,1"].location == 0) {
        return JYDeviceType_iPhone6S;
    } else if ([deviceName rangeOfString:@"iPhone8,2"].location == 0) {
        return JYDeviceType_iPhone6SP;
    } else if ([deviceName rangeOfString:@"iPhone8,4"].location == 0) {
        return JYDeviceType_iPhoneSE;
    }else if ([deviceName rangeOfString:@"iPhone9,1"].location == 0){
        return JYDeviceType_iPhone7;
    }else if ([deviceName rangeOfString:@"iPhone9,2"].location == 0){
        return JYDeviceType_iPhone7P;
    } else if ([deviceName rangeOfString:@"iPad"].location == 0) {
        return JYDeviceType_iPad;
    } else {
        return JYDeviceTypeUnknown;
    }
}

#pragma mark -- app

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL installed = [[[JYApplicationManager defaultManager] allInstalledAppIdentifiers] bk_any:^BOOL(id obj) {
            return [bundleId isEqualToString:obj];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(installed);
            }
        });
    });
}

+ (void)showSpreadBanner {
    if ([JYAppSpreadBannerModel sharedModel].fetchedSpreads) {
        [self showBanner];
    }else{
        [[JYAppSpreadBannerModel sharedModel] fetchAppSpreadWithCompletionHandler:^(BOOL success, id obj) {
            if (success) {
                [self showBanner];
            }
        }];
    }
}

+ (void)getSpreadeBannerInfo {
    [[JYAppSpreadBannerModel sharedModel] fetchAppSpreadWithCompletionHandler:nil];
}

+ (void)showBanner {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * uninstalledSpreads = [self getUnInstalledSpreads];
        
        if (uninstalledSpreads.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                JYSpreadBannerViewController *spreadVC = [[JYSpreadBannerViewController alloc] initWithSpreads:uninstalledSpreads];
                [spreadVC showInViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            });
        }
    });
}

+ (NSArray <JYAppSpread *> *)getUnInstalledSpreads {
    NSArray *spreads = [JYAppSpreadBannerModel sharedModel].fetchedSpreads;
    NSArray *allInstalledAppIds = [[JYApplicationManager defaultManager] allInstalledAppIdentifiers];
    NSArray *uninstalledSpreads = [spreads bk_select:^BOOL(id obj) {
        return ![allInstalledAppIds containsObject:[obj specialDesc]];
    }];
    return uninstalledSpreads;
}

#pragma mark -- 其他

+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(NSDictionary *)params {
    NSMutableString *standbyUrl = [NSMutableString stringWithString:JY_STANDBY_BASE_URL];
    [standbyUrl appendString:[url substringToIndex:url.length-4]];
    [standbyUrl appendFormat:@"-%@-%@",JY_REST_APPID,JY_REST_PV];
    if (params) {
        for (int i = 0; i<[params allKeys].count; i++) {
            [standbyUrl appendFormat:@"-%@",[params allValues][i]];
        }
    }
    [standbyUrl appendString:@".json"];
    
    return standbyUrl;
}

@end
