//
//  JYPayPointCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYPayPointCell.h"
#import "JYSystemConfigModel.h"

@interface JYPayPointCell ()

{
    UIView *_frameView;
    UILabel *_title;
    UILabel *_subTitle;
    UILabel *_moneyLabel;
    UIImageView *_seletedImgV;
}

@end

@implementation JYPayPointCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        
        _frameView = [[UIView alloc] init];
        _frameView.layer.cornerRadius = [JYUtil isIpad] ? 10 : kWidth(10);
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#B854B4"].CGColor;
        _frameView.layer.borderWidth = 2.f;
        _frameView.layer.masksToBounds = YES;
        [self.contentView addSubview:_frameView];
        
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        _title.font = [UIFont boldSystemFontOfSize:[JYUtil isIpad] ? 38 : kWidth(38)];
        _title.textAlignment = NSTextAlignmentCenter;
        [_frameView addSubview:_title];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _subTitle.font = [UIFont systemFontOfSize:[JYUtil isIpad] ? 28 : kWidth(28)];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        [_frameView addSubview:_subTitle];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
        _moneyLabel.font = [UIFont systemFontOfSize:[JYUtil isIpad] ? 36 : kWidth(36)];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [_frameView addSubview:_moneyLabel];
        
        _seletedImgV = [[UIImageView alloc] init];
        [_frameView addSubview:_seletedImgV];
        
        {
            [_frameView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kWidth(40), 0, kWidth(40)));
            }];
            
            [_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_frameView).offset(kWidth(20));
                make.top.equalTo(_frameView).offset(kWidth(16));
                make.height.mas_equalTo(kWidth(52));
            }];
            
            [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_frameView).offset(kWidth(20));
                make.bottom.equalTo(_frameView.mas_bottom).offset(-kWidth(16));
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_frameView);
                make.right.equalTo(_frameView.mas_right).offset(-kWidth(106));
                make.height.mas_equalTo(kWidth(50));
            }];
            
            [_seletedImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_frameView);
                make.right.equalTo(_frameView.mas_right).offset(-kWidth(46));
                make.size.mas_equalTo(CGSizeMake(kWidth(36), kWidth(36)));
            }];
        }
        
    }
    return self;
}

- (void)setVipLevel:(JYVipType)vipLevel {
    _vipLevel = vipLevel;
    if (vipLevel == JYVipTypeYear) {
        _title.text = @"年度会员";
        _subTitle.text = @"充值100送100话费";
        _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[JYSystemConfigModel sharedModel].payhjAmount/100];
    } else if (vipLevel == JYVipTypeQuarter) {
        _title.text = @"季度会员";
        _subTitle.text = @"充值50送30元话费";
        _moneyLabel.text = [NSString stringWithFormat:@"%zd",[JYSystemConfigModel sharedModel].payzsAmount/100];
       
    } else if (vipLevel == JYVipTypeMonth) {
        _title.text = @"月度会员";
        _subTitle.text = @"充值便可查看用户隐私信息";
        _moneyLabel.text = [NSString stringWithFormat:@"¥%ld",[JYSystemConfigModel sharedModel].payAmount/100];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (_isSelected) {
        _title.textColor = [UIColor colorWithHexString:@"#B854B4"];
        _subTitle.textColor = [UIColor colorWithHexString:@"#B854B4"];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
        _seletedImgV.image = [UIImage imageNamed:@"pay_selected"];
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#B854B4"].CGColor;
    } else {
        _title.textColor = [UIColor colorWithHexString:@"#999999"];
        _subTitle.textColor = [UIColor colorWithHexString:@"#999999"];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _seletedImgV.image = [UIImage imageNamed:@"pay_normal"];
        _frameView.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    }
}

@end
