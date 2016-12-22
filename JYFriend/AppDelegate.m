//
//  AppDelegate.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "AppDelegate.h"
#import "JYTabBarController.h"
#import "AppDelegate+login.h"
#import "AppDelegate+configuration.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
    
    return _window;
}

- (UIViewController *)rootViewController {
    if (_rootViewController) {
        return _rootViewController;
    }
    JYTabBarController *tabBarVC = [[JYTabBarController alloc] init];
    _rootViewController = tabBarVC;
    return _rootViewController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setCommonStyle];
    [self checkUserIsLoginWithApplication:application Options:launchOptions];
    
    return YES;
}

@end
