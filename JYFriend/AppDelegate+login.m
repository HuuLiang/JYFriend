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
    
    [[QBNetworkInfo sharedInfo] startMonitoring];
    
    [QBNetworkInfo sharedInfo].reachabilityChangedAction = ^ (BOOL reachable) {
        
//        if (reachable && ![JYSystemConfigModel sharedModel].loaded) {
//            //系统配置
//            [self fetchSystemConfigWithCompletionHandler:nil];
//        }
        
        //激活信息
        if (reachable && ![JYUtil isRegisteredUUID]) {
            [[JYActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *uuid) {
                if (success) {
                    [JYUtil setRegisteredWithUUID:uuid];
                    [[JYUserAccessModel sharedModel] requestUserAccess];
                    //                    [[PPHostIPModel sharedModel] fetchHostList];
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
//    BOOL requestedSystemConfig = NO;
//    NSString *imageToken = [JYUtil imageToken];
//    if (imageToken) {
//        [[SDWebImageManager sharedManager].imageDownloader setValue:imageToken forHTTPHeaderField:@"Referer"];
//        [self checkUserIsLogin];
//    } else {
//        self.window.rootViewController = [[UIViewController alloc] init];
//        [self.window makeKeyAndVisible];
//        
//        [self.window beginProgressingWithTitle:@"更新系统配置..." subtitle:nil];
//        
//        requestedSystemConfig = [self fetchSystemConfigWithCompletionHandler:^(BOOL success) {
//            [self.window endProgressing];
//            [self checkUserIsLogin];
//        }];
//        
//    }
//    
//    if (!requestedSystemConfig) {
//        [[JYSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
//            if (success) {
//                [JYUtil setImageToken:[JYSystemConfigModel sharedModel].imageToken];
//            }
//            NSUInteger statsTimeInterval = 180;
//            //数据统计相关
//            [[QBStatsManager sharedManager] scheduleStatsUploadWithTimeInterval:statsTimeInterval];
//        }];
//    }
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
    [self.window.rootViewController presentViewController:self.rootViewController animated:YES completion:^{
        self.window.rootViewController = self.rootViewController;
        [self.window makeKeyAndVisible];
    }];
}

- (void)responseErrorInfo:(NSNotification *)notification {
    
}

@end
