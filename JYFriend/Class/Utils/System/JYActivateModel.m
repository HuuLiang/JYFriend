//
//  JYActivateModel.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYActivateModel.h"

static NSString *const kSuccessResponse = @"SUCCESS";

@implementation JYActivateModel

+ (instancetype)sharedModel {
    static JYActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JYActivateModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [NSString class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)activateWithCompletionHandler:(JYActivateHandler)handler {
//    NSString *sdkV = [NSString stringWithFormat:@"%d.%d",
//                      __IPHONE_OS_VERSION_MAX_ALLOWED / 10000,
//                      (__IPHONE_OS_VERSION_MAX_ALLOWED % 10000) / 100];
//    
//    NSDictionary *params = @{@"cn":JY_CHANNEL_NO,
//                             @"imsi":@"999999999999999",
//                             @"imei":@"999999999999999",
//                             @"sms":@"00000000000",
//                             @"cw":@(kScreenWidth),
//                             @"ch":@(kScreenHeight),
//                             @"cm":[JYUtil deviceName],
//                             @"mf":[UIDevice currentDevice].model,
//                             @"sdkV":sdkV,
//                             @"cpuV":@"",
//                             @"appV":[JYUtil appVersion],
//                             @"appVN":@"",
//                             @"ccn":JY_PACKAGE_CERTIFICATE,
//                             @"operator":[QBNetworkInfo sharedInfo].carriarName ?: @"",
//                             @"systemVersion":[UIDevice currentDevice].systemVersion};
    
    NSDictionary *params = @{@"channelNo":JY_CHANNEL_NO,
                             @"appVersion":[JYUtil appVersion],
                             @"appId":JY_REST_APPID};
    
    BOOL success = [self requestURLPath:JY_ACTIVATION_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_ACTIVATION_URL params:nil]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
                            NSString *uuid;
                            if (respStatus == QBURLResponseSuccess) {
                                NSString *resp = self.response;
                                NSArray *resps = [resp componentsSeparatedByString:@";"];
                                
                                NSString *success = resps.firstObject;
                                if ([success isEqualToString:kSuccessResponse]) {
                                    uuid = resps.count == 2 ? resps[1] : nil;
                                }
                            }
                            
                            if (handler) {
                                handler(respStatus == QBURLResponseSuccess && uuid, uuid);
                            }
                        }];
    return success;
}


@end
