//
//  JYTabBarController.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYTabBarController.h"

#import "JYMessageViewController.h"
#import "JYSegmentViewController.h"
#import "JYNearViewController.h"
#import "JYMineViewController.h"

#import "JYNavigationController.h"


@interface JYTabBarController () <UITabBarControllerDelegate>

@end

@implementation JYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setChildViewControlers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setChildViewControlers {
    JYMessageViewController *messageVC = [[JYMessageViewController alloc] initWithTitle:@"消息"];
    JYNavigationController *messageNav = [[JYNavigationController alloc] initWithRootViewController:messageVC];
    messageNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:messageVC.title
                                                          image:[UIImage imageNamed:@"tabbar_message_normal"]
                                                  selectedImage:[[UIImage imageNamed:@"tabbar_message_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JYSegmentViewController *dynamicVC = [[JYSegmentViewController alloc] initWithTitle:@"动态"];
    JYNavigationController *dynamicNav = [[JYNavigationController alloc] initWithRootViewController:dynamicVC];
    dynamicNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:dynamicVC.title
                                                          image:[UIImage imageNamed:@"tabbar_dynamic_normal"]
                                                  selectedImage:[[UIImage imageNamed:@"tabbar_dynamic_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JYNearViewController *nearVC = [[JYNearViewController alloc] initWithTitle:@"附近"];
    JYNavigationController *nearNav = [[JYNavigationController alloc] initWithRootViewController:nearVC];
    nearNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nearVC.title
                                                          image:[UIImage imageNamed:@"tabbar_near_normal"]
                                                  selectedImage:[[UIImage imageNamed:@"tabbar_near_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    JYMineViewController *mineVC = [[JYMineViewController alloc] initWithTitle:@"我的"];
    JYNavigationController *mineNav = [[JYNavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                       image:[UIImage imageNamed:@"tabbar_mine_normal"]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    self.tabBar.translucent = NO;
    self.delegate = self;
    self.viewControllers = @[messageNav,dynamicNav,nearNav,mineNav];
}

#pragma mark -- UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

@end

