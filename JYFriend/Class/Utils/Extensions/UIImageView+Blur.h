//
//  UIImageView+Blur.h
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Blur)

- (void)JY_AddBlurWithAlpha:(CGFloat)alpha;//0 - 1
- (void)JY_RemoveBlur;

@end
