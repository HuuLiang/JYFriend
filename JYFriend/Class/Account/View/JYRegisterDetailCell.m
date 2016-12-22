//
//  JYRegisterDetailCell.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRegisterDetailCell.h"

@interface JYRegisterDetailCell ()
{
    UILabel       *_contentLabel;
    UIImageView   *_arrowImgV;
}
@end

@implementation JYRegisterDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16.];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        
        _arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_arrow"]];
        [self.contentView addSubview:_arrowImgV];
        _arrowImgV.hidden = YES;
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [self.contentView addSubview:_contentLabel];
        
        {
            [_arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(18)));
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(30));
            }];
            
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(_arrowImgV.mas_right).offset(-kWidth(4));
                make.height.mas_equalTo(kWidth(32));
            }];
        }
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setCellType:(JYDetailCellType)cellType {
    if (cellType == JYDetailCellTypeContent) {
        _arrowImgV.hidden = NO;
    } else if (cellType == JYDetailCellTypeSelect) {
        
    }
}

@end
