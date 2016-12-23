//
//  JYNearPersonCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNearPersonCell.h"

@interface JYNearPersonCell ()

{
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_genderLabel;

}

@end

@implementation JYNearPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
//        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        _headerImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headerImageView];
        {
            [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).mas_offset(kWidth(30));
                make.centerY.mas_equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(kWidth(140), kWidth(140)));
            }];
        }
    }
    return self;
}

- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    headerImageUrl = headerImageUrl;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]];
}


@end
