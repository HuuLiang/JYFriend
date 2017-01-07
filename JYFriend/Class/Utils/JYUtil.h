//
//  JYUtil.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYAppSpread;

@interface JYUtil : NSObject

+ (NSString *)accessId;

+ (NSString *)UUID;
+ (BOOL)isRegisteredUUID;
+ (void)setRegisteredWithUUID:(NSString *)uuid;

+ (NSString *)userId;
+ (BOOL)isRegisteredUserId;
+ (void)setRegisteredWithUserId:(NSString *)userId;

+ (NSUInteger)launchSeq;
+ (void)accumateLaunchSeq;

+ (NSString *)imageToken;
+ (void)setImageToken:(NSString *)imageToken;

+ (BOOL)isIpad;
+ (NSString *)appVersion;
+ (NSString *)deviceName;
+ (JYDeviceType)deviceType;

+ (void)checkAppInstalledWithBundleId:(NSString *)bundleId completionHandler:(void (^)(BOOL))handler;
+ (void)showSpreadBanner;
+ (void)getSpreadeBannerInfo;
+ (void)showBanner;
+ (NSArray <JYAppSpread *> *)getUnInstalledSpreads;

+ (NSDate *)dateFromString:(NSString *)dateString WithDateFormat:(NSString *)dateFormat;
+ (NSString *)timeStringFromDate:(NSDate *)date WithDateFormat:(NSString *)dateFormat;

+ (NSString *)getStandByUrlPathWithOriginalUrl:(NSString *)url params:(NSDictionary *)params;



@end
