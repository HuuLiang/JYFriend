//
//  JYUser.m
//  JYFriend
//
//  Created by Liang on 2016/12/23.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYUser.h"

static JYUser *_currentUser;

@implementation JYUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentUser = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE isHuman=%d",YES]];
        if (!_currentUser) {
            _currentUser = [[self alloc] init];
            _currentUser.isHuman = YES;
            [_currentUser saveOrUpdate];
        }
    });
    return _currentUser;
}



@end
