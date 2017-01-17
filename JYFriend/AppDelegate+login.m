//
//  AppDelegate+login.m
//  JYFriend
//
//  Created by Liang on 2016/12/20.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "AppDelegate+login.h"
#import "JYLoginViewController.h"
#import "JYTabBarController.h"
#import "JYNavigationController.h"
#import "JYSystemConfigModel.h"
#import "JYActivateModel.h"
#import "JYUserAccessModel.h"
#import <UMMobClick/MobClick.h>
#import <QBPaymentManager.h>
#import <QBPaymentConfig.h>

static NSString *const kAliPaySchemeUrl = @"JYFriendAliPayUrlScheme";


@interface AppDelegate ()
//{
//    UIViewController *_rootViewController;
//}
@end

@implementation AppDelegate (login)

- (void)checkNetworkInfoState {
    [QBNetworkingConfiguration defaultConfiguration].RESTAppId = JY_REST_APPID;
    [QBNetworkingConfiguration defaultConfiguration].RESTpV = @([JY_REST_PV integerValue]);
    [QBNetworkingConfiguration defaultConfiguration].channelNo = JY_CHANNEL_NO;
    [QBNetworkingConfiguration defaultConfiguration].baseURL = JY_BASE_URL;
    [QBNetworkingConfiguration defaultConfiguration].useStaticBaseUrl = NO;
    [QBNetworkingConfiguration defaultConfiguration].encryptedType = QBURLEncryptedTypeNew;
#ifdef DEBUG
    //    [[QBPaymentManager sharedManager] usePaymentConfigInTestServer:YES];
#endif
    [[QBPaymentManager sharedManager] registerPaymentWithAppId:JY_REST_APPID
                                                     paymentPv:@([JY_PAYMENT_PV integerValue])
                                                     channelNo:JY_CHANNEL_NO
                                                     urlScheme:kAliPaySchemeUrl
                                                 defaultConfig:[self setDefaultPaymentConfig]];

    
    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^ (BOOL reachable) {
        
        if (reachable && ![JYSystemConfigModel sharedModel].loaded) {
            //系统配置
            [self fetchSystemConfigWithCompletionHandler:nil];
        }
        
        //激活信息
        if (reachable && ![JYUtil isRegisteredUUID]) {
            [[JYActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *uuid) {
                if (success) {
                    [JYUtil setRegisteredWithUUID:uuid];
                    [[JYUserAccessModel sharedModel] requestUserAccess];
                }
            }];
        } else {
            [[JYUserAccessModel sharedModel] requestUserAccess];
        }
        
        //网络错误提示
        if ([QBNetworkInfo sharedInfo].networkStatus <= QBNetworkStatusNotReachable && (![JYUtil isRegisteredUUID] || ![JYSystemConfigModel sharedModel].loaded)) {
            if ([JYUtil isIpad]) {
                [UIAlertView bk_showAlertViewWithTitle:@"请检查您的网络连接!" message:nil cancelButtonTitle:@"确认" otherButtonTitles:nil handler:nil];
            }else{
                [UIAlertView bk_showAlertViewWithTitle:@"很抱歉!" message:@"您的应用未连接到网络,请检查您的网络设置" cancelButtonTitle:@"稍后" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
            }
        }
    };
    
//    设置图片referer
    BOOL requestedSystemConfig = NO;
    NSString *imageToken = [JYUtil imageToken];
    if (imageToken) {
        [[SDWebImageManager sharedManager].imageDownloader setValue:imageToken forHTTPHeaderField:@"Referer"];
        [self checkUserIsLogin];
    } else {
        self.window.rootViewController = [[UIViewController alloc] init];
        [self.window makeKeyAndVisible];
        
        [self.window beginProgressingWithTitle:@"更新系统配置..." subtitle:nil];
        
        requestedSystemConfig = [self fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            [self.window endProgressing];
            [self checkUserIsLogin];
        }];
        
    }
    
    if (!requestedSystemConfig) {
        [[JYSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
            if (success) {
                [JYUtil setImageToken:[JYSystemConfigModel sharedModel].imageToken];
            }
            NSUInteger statsTimeInterval = 180;
            //数据统计相关
            [[QBStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        }];
    }
}

- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    if (XcodeAppVersion) {
        [MobClick setAppVersion:XcodeAppVersion];
    }
    UMConfigInstance.appKey = JY_UMENG_APP_ID;
    UMConfigInstance.channelId = JY_CHANNEL_NO;
    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)checkUserIsLogin {
    
    if ([JYUtil isRegisteredUserId]) {
        self.window.rootViewController = self.rootViewController;
    } else {
        JYLoginViewController *loginVC = [[JYLoginViewController alloc] init];
        JYNavigationController *loginNav = [[JYNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = loginNav;
    }
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userloginSuccess:) name:kUserLoginNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseErrorInfo:) name:kQBNetworkingErrorNotification object:nil];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    return [[JYSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        if (success) {
            NSString *fetchedToken = [JYSystemConfigModel sharedModel].imageToken;
            [JYUtil setImageToken:fetchedToken];
            if (fetchedToken) {
                [[SDWebImageManager sharedManager].imageDownloader setValue:fetchedToken forHTTPHeaderField:@"Referer"];
            }
        }
        NSUInteger statsTimeInterval = 180;
        [[QBStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
        
        QBSafelyCallBlock(completionHandler, success);
    }];
}

- (void)userloginSuccess:(NSNotification *)notification {
    if (self.window.rootViewController.presentedViewController == nil) {
        [self.window.rootViewController presentViewController:self.rootViewController animated:YES completion:^{
            self.window.rootViewController = self.rootViewController;
            [self.window makeKeyAndVisible];
        }];
    }
}

- (void)responseErrorInfo:(NSNotification *)notification {
    
}

- (QBPaymentConfig *)setDefaultPaymentConfig {
    QBPaymentConfig *config = [[QBPaymentConfig alloc] init];
    
    QBPaymentConfigDetail *configDetails = [[QBPaymentConfigDetail alloc] init];
    //爱贝默认配置
    QBIAppPayConfig * iAppPayConfig = [[QBIAppPayConfig alloc] init];
    iAppPayConfig.appid = @"3006339410";
    iAppPayConfig.privateKey = @"MIICWwIBAAKBgQCHEQCLCZujWicF6ClEgHx4L/OdSHZ1LdKi/mzPOIa4IRfMOS09qDNV3+uK/zEEPu1DgO5Cl1lsm4xpwIiOqdXNRxLE9PUfgRy4syiiqRfofAO7w4VLSG4S0VU5F+jqQzKM7Zgp3blbc5BJ5PtKXf6zP3aCAYjz13HHH34angjg0wIDAQABAoGASOJm3aBoqSSL7EcUhc+j2yNdHaGtspvwj14mD0hcgl3xPpYYEK6ETTHRJCeDJtxiIkwfxjVv3witI5/u0LVbFmd4b+2jZQ848BHGFtZFOOPJFVCylTy5j5O79mEx0nJN0EJ/qadwezXr4UZLDIaJdWxhhvS+yDe0e0foz5AxWmkCQQDhd9U1uUasiMmH4WvHqMfq5l4y4U+V5SGb+IK+8Vi03Zfw1YDvKrgv1Xm1mdzYHFLkC47dhTm7/Ko8k5Kncf89AkEAmVtEtycnSYciSqDVXxWtH1tzsDeIMz/ZlDGXCAdUfRR2ZJ2u2jrLFunoS9dXhSGuERU7laasK0bDT4p0UwlhTwJAVF+wtPsRnI1PxX6xA7WAosH0rFuumax2SFTWMLhGduCZ9HEhX97/sD7V3gSnJWRsDJTasMEjWtrxpdufvPOnDQJAdsYPVGMItJPq5S3n0/rv2Kd11HdOD5NWKsa1mMxEjZN5lrfhoreCb7694W9pI31QWX6+ZUtvcR0fS82KBn3vVQJAa0fESiiDDrovKHBm/aYXjMV5anpbuAa5RJwCqnbjCWleZMwHV+8uUq9+YMnINZQnvi+C62It4BD+KrJn5q4pwg==";
    iAppPayConfig.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbNQyxdpLeMwE0QMv/dB3Jn1SRqYE/u3QT3ig2uXu4yeaZo4f7qJomudLKKOgpa8+4a2JAPRBSueDpiytR0zN5hRZKImeZAu2foSYkpBqnjb5CRAH7roO7+ervoizg6bhAEx2zlltV9wZKQZ0Di5wCCV+bMSEXkYqfASRplYUvHwIDAQAB";
    iAppPayConfig.notifyUrl = @"http://phas.zcqcmj.com/pd-has/notifyIpay.json";
    iAppPayConfig.waresid = @(1);
    configDetails.iAppPayConfig = iAppPayConfig;
    //支付方式
    QBPaymentConfigSummary *payConfig = [[QBPaymentConfigSummary alloc] init];
    payConfig.alipay = kQBIAppPayConfigName;
    payConfig.wechat = @"kQBIAppPayConfigName";
    
    config.configDetails = configDetails;
    config.payConfig = payConfig;
    [config setAsCurrentConfig];
    
    return config;
}


@end
