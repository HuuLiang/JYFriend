//
//  JYAutoContactManager.m
//  JYFriend
//
//  Created by Liang on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYAutoContactManager.h"
#import "JYContactModel.h"
#import "JYMessageModel.h"

@implementation JYAutoContactManager

+ (instancetype)manager {
    static JYAutoContactManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JYAutoContactManager alloc] init];
    });
    return _instance;
}

- (void)autoAddContactInfo:(NSArray <JYContactModel *> *)contacts {
    
}

- (void)autoAddMessageInfo:(NSArray <JYMessageModel *> *)messages {
    
}


@end
