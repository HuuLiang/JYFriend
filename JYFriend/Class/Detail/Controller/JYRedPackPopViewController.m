//
//  JYRedPackPopViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYRedPackPopViewController.h"
#import "JYRedPacketView.h"

@interface JYRedPackPopViewController ()

@property (nonatomic,retain) JYRedPacketView *packView;

@end

@implementation JYRedPackPopViewController

- (JYRedPacketView *)packView {
    if (_packView) {
        return _packView;
    }
    _packView = [[JYRedPacketView alloc] init];
    _packView.closeAction = ^(JYRedPacketView *view){
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
        }completion:^(BOOL finished) {
            view.hidden = YES;
        }];
    };
    
    return _packView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)popRedPackViewWithCurrentViewCtroller:(UIViewController *)currentViewCtroller {

    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    [currentViewCtroller addChildViewController:self];
    self.packView.price = 5;
    self.packView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
     [currentViewCtroller.view addSubview:self.packView];
    [self.packView willMoveToWindow:currentViewCtroller.view.window];
    [UIView animateWithDuration:0.5 animations:^{
           self.packView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
