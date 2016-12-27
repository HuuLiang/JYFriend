//
//  JYMessageViewController.h
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "XHMessageTableViewController.h"

@interface JYMessageViewController : XHMessageTableViewController

@property (nonatomic,retain,readonly) JYUser *user;

+ (instancetype)showMessageWithUser:(JYUser *)user inViewController:(UIViewController *)viewController;

@end
