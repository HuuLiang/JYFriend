//
//  JYNewDynamicCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYPayNewDynamicCell.h"

@interface JYPayNewDynamicCell ()
{
    UILabel *_titleLable;
    UILabel *_dynamicLabel;
}

@end

@implementation JYPayNewDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:kWidth(15)];
        _titleLable.textColor = [UIColor colorWithHexString:@"#E147A5"];
        _titleLable.text = @"最新动态";
        [self addSubview:_titleLable];
        {
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).mas_offset(kWidth(30));
            make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(30)));
        }];
        }
        
        
    }

    return self;
}



@end
