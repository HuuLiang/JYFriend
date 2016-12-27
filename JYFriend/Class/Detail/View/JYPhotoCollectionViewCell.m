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

@property (nonatomic,retain) UIImageView *playImageView;

@end

@implementation JYPhotoCollectionViewCell

- (UIImageView *)playImageView {
    if (_playImageView) {
        return _playImageView;
    }
    _playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play_icon"]];
    [self addSubview:_playImageView];
    {
    [_playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kWidth(100), kWidth(100)));
    }];
    }
    return _playImageView;
}

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

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [_currentImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setIsVideoImage:(BOOL)isVideoImage {
    _isVideoImage = isVideoImage;
    if (isVideoImage) {
        self.playImageView.hidden = NO;
    }else {
        if (_playImageView) {
            _playImageView.hidden = YES;
            [_playImageView removeFromSuperview];
        }
    }

}


@end
