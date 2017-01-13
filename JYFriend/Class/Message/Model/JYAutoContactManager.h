//
//  JYAutoContactManager.h
//  JYFriend
//
//  Created by Liang on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYContactModel;
@class JYMessageModel;

@interface JYAutoContactManager : NSObject

+ (instancetype)manager;

- (void)autoAddContactInfo:(NSArray <JYContactModel *> *)contacts;

- (void)autoAddMessageInfo:(NSArray <JYMessageModel *> *)messages;

@end
