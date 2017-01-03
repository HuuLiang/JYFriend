//
//  JYBaseViewController.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYBaseViewController : UIViewController

@property (nonatomic) BOOL alwaysHideNavigationBar;

//- (instancetype)init __attribute__ ((unavailable("Use initWithTitle: instead")));
- (instancetype)initWithTitle:(NSString *)title;
- (UIViewController *)playerVCWithVideo:(NSString *)videoUrl;
@end
