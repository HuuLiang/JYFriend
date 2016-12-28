//
//  JYDynamicCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDynamicCell.h"
#import "JYNearPersonBtn.h"
#import "JYDynamicModel.h"

@interface JYDynamicCell ()
{
    UIImageView     *_userImgV;
    UILabel         *_nickNameLabel;
    JYNearPersonBtn *_genderBtn;
    UILabel         *_timeLabel;
    UIButton        *_focusButton;
    UIButton        *_greetButton;
    UILabel         *_contentLabel;
    
    UIImageView     *_imgVA;
    UIImageView     *_imgVB;
    UIImageView     *_imgVC;
    
    UIImageView     *_playIcon;
}
@end


@implementation JYDynamicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        QBLog(@"创建cell");
        self.contentView.backgroundColor = kColor(@"#ffffff");
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = kWidth(44);
        _userImgV.layer.masksToBounds = YES;
        [self.contentView addSubview:_userImgV];
        
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#333333");
        _nickNameLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [self.contentView addSubview:_nickNameLabel];
        
        _genderBtn = [JYNearPersonBtn buttonWithType:UIButtonTypeCustom];
        [_genderBtn setTitleColor:kColor(@"#ffffff") forState:UIControlStateNormal];
        [_genderBtn setBackgroundColor:kColor(@"#E147A5")];
        [self.contentView addSubview:_genderBtn];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kColor(@"#999999");
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self.contentView addSubview:_timeLabel];
        
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setTitle:@"已关注" forState:UIControlStateSelected];
        _focusButton.layer.borderWidth = 1;
        _focusButton.layer.cornerRadius = kWidth(4);
        _focusButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_focusButton];
        
        _greetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_greetButton setTitleColor:kColor(@"#E147A5") forState:UIControlStateNormal];
        [_greetButton setTitleColor:kColor(@"#E6E6E6") forState:UIControlStateSelected];
        [_greetButton setTitle:@"打招呼" forState:UIControlStateNormal];
        [_greetButton setTitle:@"已招呼" forState:UIControlStateSelected];
        _greetButton.layer.borderWidth = 1;
        _greetButton.layer.cornerRadius = kWidth(4);
        _greetButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_greetButton];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kColor(@"#333333");
        _contentLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        

        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(self.contentView).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(kWidth(88), kWidth(88)));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(18));
                make.top.equalTo(self.contentView).offset(kWidth(38));
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nickNameLabel);
                make.top.equalTo(_nickNameLabel.mas_bottom).offset(kWidth(14));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_nickNameLabel);
                make.left.equalTo(_nickNameLabel.mas_right).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(80), kWidth(32)));
            }];
            
            [_greetButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-kWidth(32));
                make.top.equalTo(self.contentView).offset(kWidth(34));
                make.size.mas_equalTo(CGSizeMake(kWidth(116), kWidth(52)));
            }];
            
            [_focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_greetButton.mas_left).offset(-kWidth(14));
                make.centerY.equalTo(_greetButton);
                make.size.mas_equalTo(CGSizeMake(kWidth(116), kWidth(52)));
            }];
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(_userImgV.mas_bottom).offset(kWidth(32));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(32));
            }];
        }
    }
    return self;
}

- (void)setLogoUrl:(NSString *)logoUrl {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:logoUrl]];
}

- (void)setNickName:(NSString *)nickName {
    _nickNameLabel.text = nickName;
}

- (void)setUserSex:(JYUserSex)userSex {
    _userSex = userSex;
    [_genderBtn setImage:[UIImage imageNamed:userSex == JYUserSexMale ? @"near_gender_boy_icon" : @"near_gender_girl_icon"] forState:UIControlStateNormal];
}

- (void)setAge:(NSString *)age {
    [_genderBtn setTitle:age forState:UIControlStateNormal];
}

- (void)setTime:(NSString *)time {
    _timeLabel.text = time;
}

- (void)setContent:(NSString *)content {
    _contentLabel.text = content;
}

- (void)setIsFocus:(BOOL)isFocus {
    _isFocus = isFocus;
    if (isFocus) {
        [_focusButton setTitleColor:kColor(@"#E6E6E6") forState:UIControlStateNormal];
        [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        _focusButton.layer.borderColor = kColor(@"#E6E6E6").CGColor;
    } else {
        [_focusButton setTitle:[NSString stringWithFormat:@"关注%@",_userSex == JYUserSexMale ? @"他" : @"她"] forState:UIControlStateNormal];
        [_focusButton setTitleColor:kColor(@"#E147A5") forState:UIControlStateNormal];
        _focusButton.layer.borderColor = kColor(@"#E147A5").CGColor;
    }
}

- (void)setIsGreet:(BOOL)isGreet {
    _isGreet = isGreet;
    if (isGreet) {
        [_greetButton setTitleColor:kColor(@"#E6E6E6") forState:UIControlStateNormal];
        [_greetButton setTitle:@"打招呼" forState:UIControlStateNormal];
        _greetButton.layer.borderColor = kColor(@"#E6E6E6").CGColor;
    } else {
        [_greetButton setTitleColor:kColor(@"#E147A5") forState:UIControlStateNormal];
        [_greetButton setTitle:@"已招呼" forState:UIControlStateNormal];
        _greetButton.layer.borderColor = kColor(@"#E147A5").CGColor;
    }
}

- (void)setDynamicType:(JYDynamicType)dynamicType {
    
    if (_imgVA) {
        [_imgVA removeFromSuperview];
    }
    if (_imgVB) {
        [_imgVB removeFromSuperview];
    }
    if (_imgVC) {
        [_imgVC removeFromSuperview];
    }
    if (_playIcon) {
        [_playIcon removeFromSuperview];
    }
    
    if (dynamicType == JYDynamicTypeOnePhoto) {
        
        _imgVA = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVA];
        
        [_imgVA sd_setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg"]];
    } else if (dynamicType == JYDynamicTypeTwoPhotos) {
        
        _imgVA = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVA];
        
        _imgVB = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVB];
        
        [_imgVA sd_setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg"]];
        [_imgVB sd_setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg"]];
    } else if (dynamicType == JYDynamicTypeThreePhotos) {
        
        _imgVA = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVA];
        
        _imgVB = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVB];
        
        _imgVC = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVC];
        
        [_imgVA sd_setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg"]];
        [_imgVB sd_setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg"]];
        [_imgVC sd_setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg"]];
    } else if (dynamicType == JYDynamicTypeVideo) {
        _imgVA = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgVA];
        
        _playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_play"]];
        [_imgVA addSubview:_playIcon];
        
        [_imgVA sd_setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg"]];
    }
    
    if (dynamicType == JYDynamicTypeOnePhoto) {
        [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width - kWidth(60), self.contentView.frame.size.width - kWidth(60)));
        }];
    } else if (dynamicType == JYDynamicTypeTwoPhotos) {
        [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(70))/2, (self.contentView.frame.size.width - kWidth(70))/2));
        }];
        
        [_imgVB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgVA.mas_right).offset(kWidth(12));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(70))/2, (self.contentView.frame.size.width - kWidth(70))/2));
        }];
    } else if (dynamicType == JYDynamicTypeThreePhotos) {
        [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(kWidth(30));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(72))/3, (self.contentView.frame.size.width - kWidth(72))/3));
        }];
        
        [_imgVB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgVA.mas_right).offset(kWidth(6));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(72))/3, (self.contentView.frame.size.width - kWidth(72))/3));
        }];
        
        [_imgVC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgVB.mas_right).offset(kWidth(6));
            make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width - kWidth(72))/3, (self.contentView.frame.size.width - kWidth(72))/3));
        }];
    } else if (dynamicType == JYDynamicTypeVideo) {
        [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
            [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(_contentLabel.mas_bottom).offset(kWidth(30));
                make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width - kWidth(60), (self.contentView.frame.size.width - kWidth(60))*207/345));
            }];
        }];
        
        [_playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_imgVA);
            make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(100)));
        }];
    }

}

@end
