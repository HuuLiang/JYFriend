//
//  JYTabBarController.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYTabBarController.h"
#import "JYMineViewController.h"

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
    
    JYMineViewController *mineVC = [[JYMineViewController alloc] initWithTitle:@"我"];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                       image:[UIImage imageNamed:@"tabbar_mine_normal"]
                                               selectedImage:[[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBar.translucent = NO;
    self.delegate = self;
    self.viewControllers = @[mineNav];
}

#pragma mark -- UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

@end
