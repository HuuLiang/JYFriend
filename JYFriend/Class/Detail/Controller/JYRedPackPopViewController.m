//
//  JYRedPackPopViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYRedPackPopViewController.h"
#import "JYRedPacketView.h"
#import "JYPaymentViewController.h"
@interface JYRedPackPopViewController ()

@property (nonatomic,retain) JYRedPacketView *packView;
@end

@implementation JYRedPackPopViewController

- (JYRedPacketView *)packView {
    if (_packView) {
        return _packView;
    }
    _packView = [[JYRedPacketView alloc] init];
    @weakify(self);
    _packView.closeAction = ^(JYRedPacketView *view){
        @strongify(self);
        [self hiddenPackView];
    };
    
    _packView.ktVipAction = ^(id sender){
        @strongify(self);
        [self presentPayViewController];
         [self hiddenPackView];
    };
    
    _packView.sendPacketAction = ^(id sender){
        @strongify(self);
        [self hiddenPackView];
        QBBaseModel *baseModel = [[QBBaseModel alloc] init];
        baseModel.realColumnId = @(235345);
        baseModel.channelType = @(1);
        baseModel.programType= @(2);
        baseModel.programId = @(234);
        baseModel.programLocation = @(45);
        [[[JYPaymentViewController alloc] init] payForWithBaseModel:baseModel vipLevel:JYVipTypePacket];
    };
    
    return _packView;
}

- (void)hiddenPackView{
    [UIView animateWithDuration:0.5 animations:^{
        _packView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    }completion:^(BOOL finished) {
        _packView.hidden = YES;
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)popRedPackViewWithCurrentViewCtroller:(UIViewController *)currentViewCtroller{
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    if (![currentViewCtroller.childViewControllers containsObject:self]) {
        [currentViewCtroller addChildViewController:self];
        self.packView.price = 5;
        self.packView.hidden = NO;
        self.packView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
        [currentViewCtroller.view addSubview:self.packView];
    }
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
