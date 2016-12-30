//
//  JYDetailVideoViewController.m
//  JYFriend
//
//  Created by ylz on 2016/12/30.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDetailVideoViewController.h"

@interface JYDetailVideoViewController ()

@property (nonatomic,retain) UIView *RZvideoView;//视频认证
@property (nonatomic,retain) UIView *holdRZVideoView;//待认证

@end

@implementation JYDetailVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频认证";
    self.RZvideoView.alpha = 1;
    self.holdRZVideoView .alpha = 1;
    
}

- (UIView *)RZvideoView {
    if (_RZvideoView) {
        return _RZvideoView;
    }
    _RZvideoView = [[UIView alloc] init];
    _RZvideoView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_RZvideoView];
    {
    [_RZvideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(30.)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"点击添加认证视频,认证的视频需要经系统审核.";
    [_RZvideoView addSubview:titleLabel];
    {
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_RZvideoView).mas_offset(kWidth(160.));
        make.right.mas_equalTo(_RZvideoView).mas_offset(kWidth(-160));
        make.top.mas_equalTo(_RZvideoView).mas_offset(kWidth(80));
    }];
    }

    UIButton *rzImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rzImageBtn setBackgroundImage:[UIImage imageNamed:@"mine_rz_video_icon"] forState:UIControlStateNormal];
    [_RZvideoView addSubview:rzImageBtn];
//    @weakify(self);
    [rzImageBtn bk_addEventHandler:^(id sender) {
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    {
    [rzImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kWidth(64));
        make.left.mas_equalTo(_RZvideoView).mas_offset(kWidth(160.));
        make.right.mas_equalTo(_RZvideoView).mas_offset(kWidth(-160));
        make.height.mas_equalTo(rzImageBtn.mas_width).multipliedBy(0.6);
    }];
    }
    
    return _RZvideoView;
}

- (UIView *)holdRZVideoView {
    if (_holdRZVideoView) {
        return _holdRZVideoView;
    }
    if (_RZvideoView) {
        _RZvideoView.hidden = YES;
        [_RZvideoView removeFromSuperview];
    }
    _holdRZVideoView = [[UIView alloc] init];
    _holdRZVideoView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [self.view addSubview:_holdRZVideoView];
    {
        [_holdRZVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(30.)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"您的视频已经上传,请耐心等待审核.";
    [_holdRZVideoView addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(160.));
            make.right.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(-160));
            make.top.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(80));
        }];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"mine_photo_add"];
    [_holdRZVideoView addSubview:imageView];
    {
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(kWidth(64));
        make.left.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(160.));
        make.right.mas_equalTo(_holdRZVideoView).mas_offset(kWidth(-160));
        make.height.mas_equalTo(imageView.mas_width).multipliedBy(0.6);
    }];
    }
    imageView.userInteractionEnabled = YES;
    @weakify(self);
    [imageView bk_whenTapped:^{
        
        
    }];
    
    UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play_icon"]];
    [imageView addSubview:playImageView];
    {
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(kWidth(50), kWidth(50)));
    }];
    }
    
    return _holdRZVideoView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
