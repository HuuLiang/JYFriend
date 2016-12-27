//
//  JYHomeTownCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYHomeTownCell.h"
#import "JYNearPersonBtn.h"

@interface JYHomeTownCell ()
{
    JYNearPersonBtn *_genderBtn;
    UILabel *_heightLabel;
}

@property (nonatomic,retain) UILabel  *vipLabel;

@end

@implementation JYHomeTownCell

- (UILabel *)vipLabel {
    if (_vipLabel) {
        return _vipLabel;
    }
    _vipLabel = [[UILabel alloc] init];
    _vipLabel.textColor = [UIColor whiteColor];
    _vipLabel.backgroundColor = [UIColor colorWithHexString:@"#fd774d"];
    return _vipLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _genderBtn = [JYNearPersonBtn buttonWithType:UIButtonTypeCustom];
        _genderBtn.backgroundColor = [UIColor colorWithHexString:@"#e147a5"];
        _genderBtn.titleLabel.font =  [UIFont systemFontOfSize:kWidth(24.)];
        [_genderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_genderBtn];
        {
        [_genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(kWidth(30.));
            make.top.mas_equalTo(self).mas_offset(kWidth(40.));
            make.size.mas_equalTo(CGSizeMake(kWidth(80.), kWidth(32.)));
        }];
        }
        _heightLabel = [[UILabel alloc] init];
        _heightLabel.backgroundColor = [UIColor colorWithHexString:@"##fd774d"];
        _heightLabel.textColor = [UIColor whiteColor];
        _heightLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
        [self addSubview:_heightLabel];
        {
        [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_genderBtn.mas_right).mas_offset(kWidth(10.));
            make.centerY.mas_equalTo(_genderBtn);
            make.size.mas_equalTo(CGSizeMake(kWidth(88.), kWidth(32.)));
        }];
        }
    }
    
    return self;
}

@end
