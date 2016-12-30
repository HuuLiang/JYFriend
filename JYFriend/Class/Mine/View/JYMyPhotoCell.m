
//
//  JYMyPhotoCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMyPhotoCell.h"

@interface JYMyPhotoCell ()

{
    UIImageView *_imageView;
}

@end

@implementation JYMyPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        }
        
    }
    return self;
}

- (void)setIsAdd:(BOOL)isAdd {
    _isAdd = isAdd;
    if (isAdd) {
        _imageView.image = [UIImage imageNamed:@"mine_photo_add"];
    } else {
        _imageView.image = nil;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
    }

@end
