//
//  JYMessageCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageCell.h"

@interface JYMessageCell ()
{
    UIImageView *_userImgV;
    UILabel     *_nickNameLabel;
    UILabel     *_timeLabel;
    UILabel     *_messageLabel;
}
@end

@implementation JYMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.userInteractionEnabled = YES;
        [self.contentView addSubview:_userImgV];
        @weakify(self);
        [_userImgV bk_whenTapped:^{
            @strongify(self);
            if (self.touchUserImgVAction) {
                self.touchUserImgVAction(self);
            }
        }];
        
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = kColor(@"#333333");
        _nickNameLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [self.contentView addSubview:_nickNameLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kColor(@"#999999");
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self.contentView addSubview:_timeLabel];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = kColor(@"#999999");
        _messageLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self.contentView addSubview:_messageLabel];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kWidth(30));
                make.top.equalTo(self.contentView).offset(kWidth(16));
                make.size.mas_equalTo(CGSizeMake(kWidth(110), kWidth(110)));
            }];
            
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(kWidth(30));
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(22));
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
                make.centerY.equalTo(_nickNameLabel);
                make.height.mas_equalTo(kWidth(26));
            }];
            
            [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_nickNameLabel.mas_bottom).offset(kWidth(20));
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(22));
                make.height.mas_equalTo(kWidth(28));
                make.right.equalTo(self.contentView).offset(-kWidth(64));
            }];
        }
        
    }
    return self;
}

- (void)setUserImgStr:(NSString *)userImgStr {
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:userImgStr]];
}

- (void)setNickNameStr:(NSString *)nickNameStr {
    _nickNameLabel.text = nickNameStr;
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeLabel.text = timeStr;
}

- (void)setLatestMessage:(NSString *)latestMessage {
    _messageLabel.text = latestMessage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
