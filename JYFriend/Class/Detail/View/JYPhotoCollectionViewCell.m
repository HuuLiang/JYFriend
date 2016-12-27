//
//  JYPhotoCollectionViewCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYPhotoCollectionViewCell.h"

@interface JYPhotoCollectionViewCell ()
{
    UIImageView *_currentImageView;
}

@end

@implementation JYPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentImageView = [[UIImageView alloc] init];
//        _currentImageView.contentMode =
        _currentImageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_currentImageView];
        {
        [_currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        }
    }
    return self;
}

//- (void)cellIsVip:(BOOL)isVip withIsFirstPhoto:(BOOL)isFirstPhoto{
//
//}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_currentImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
