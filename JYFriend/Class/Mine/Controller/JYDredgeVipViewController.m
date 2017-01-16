//
//  JYDredgeVipViewController.m
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDredgeVipViewController.h"

@interface JYDredgeVipViewController ()

@end

@implementation JYDredgeVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self creatTitleLabel];
    [self creatDredgeVipBtn];
}

- (void)creatTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
    NSString *text = @"您还不是会员，成为会员可以对心仪的用户无限制发送消息，查看相册、微信、QQ、手机号等私密资料。";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6.];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeStr.length)];
    titleLabel.attributedText = attributeStr;
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    {
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view).mas_offset(kWidth(80.));
        make.right.mas_equalTo(self.view).mas_offset(kWidth(-80));
    }];
    }
}

- (void)creatDredgeVipBtn {
    UIButton *vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vipBtn.backgroundColor = [UIColor colorWithHexString:@"#E147A5"];
    vipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
    [vipBtn setTitle:@"开通会员" forState:UIControlStateNormal];
    [vipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    vipBtn.layer.cornerRadius = 5.;
    vipBtn.clipsToBounds = YES;
    [self.view addSubview:vipBtn];
    {
    [vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kWidth(88.));
        make.left.mas_equalTo(self.view).mas_offset(kWidth(80));
        make.right.mas_equalTo(self.view).mas_offset(kWidth(-80));
        make.centerY.mas_equalTo(self.view).mas_offset(kWidth(-200));
    }];
    }
    @weakify(self);
    [vipBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self presentPayViewController];
    } forControlEvents:UIControlEventTouchUpInside];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
