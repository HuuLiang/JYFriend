//
//  UIImageView+Blur.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "UIImageView+Blur.h"

static const void *kImageBlurEffectViewKey = &kImageBlurEffectViewKey;

@implementation UIImageView (Blur)

- (void)JY_AddBlurWithAlpha:(CGFloat)alpha {
    
    if (objc_getAssociatedObject(self, kImageBlurEffectViewKey)){
        return;
    };
    UIView *effView;
    if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
        /**  毛玻璃特效类型
         *  UIBlurEffectStyleExtraLight,
         *  UIBlurEffectStyleLight,
         *  UIBlurEffectStyleDark
         */
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        //  毛玻璃视图
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effView = effectView;
        objc_setAssociatedObject(self, kImageBlurEffectViewKey, effectView, OBJC_ASSOCIATION_RETAIN);
        //添加到要有毛玻璃特效的控件中
        [self addSubview:effectView];
        
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        //设置模糊透明度
        effectView.alpha = alpha;
    }else{
        [self BlurWithEffectView:effView withAlpha:alpha];
        
    }

}

- (void)BlurWithEffectView:(UIView *)effectView withAlpha:(CGFloat)alpha{
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        effectView = toolbar;
        [self addSubview:toolbar];
      objc_setAssociatedObject(self, kImageBlurEffectViewKey, effectView, OBJC_ASSOCIATION_RETAIN);
        toolbar.alpha = alpha;
}

- (void)JY_RemoveBlur {
    UIView *view = objc_getAssociatedObject(self, kImageBlurEffectViewKey);
    if (view) {
    [view removeFromSuperview];
    }
}

@end
