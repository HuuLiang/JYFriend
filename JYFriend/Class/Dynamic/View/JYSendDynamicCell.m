//
//  JYSendDynamicCell.m
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYSendDynamicCell.h"

@interface JYSendDynamicCell ()
{
    UIImageView *_currentImageView;
}

@end

@implementation JYSendDynamicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _currentImageView = [[UIImageView alloc] init];
//        _currentImageView.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
        [self addSubview:_currentImageView];
        {
        [_currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        }
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _currentImageView.image = image;
}



@end
