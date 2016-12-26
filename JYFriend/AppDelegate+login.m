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

@interface AppDelegate ()
//{
//    UIViewController *_rootViewController;
//}
@end

@implementation AppDelegate (login)

- (void)checkUserIsLoginWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions {
    
    BOOL isLogin = NO;
    
    if (isLogin) {
        self.window.rootViewController = self.rootViewController;
    } else {
        JYLoginViewController *loginVC = [[JYLoginViewController alloc] init];
        JYNavigationController *loginNav = [[JYNavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = loginNav;
    }
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userloginSuccess:) name:kUserLoginNotificationName object:nil];
}

- (void)userloginSuccess:(NSNotification *)notification {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.rootViewController animated:YES completion:nil];
}

@end
