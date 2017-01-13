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
#import "JYUserCreateMessageModel.h"

@implementation JYAutoReplyMessageModel

@end


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

- (void)saveReplyRobots:(NSArray <JYReplyRobot *> *)replyRobots {
    [replyRobots enumerateObjectsUsingBlock:^(JYReplyRobot * _Nonnull replyRobot, NSUInteger idx, BOOL * _Nonnull stop) {
        [replyRobot.dialogMsgs enumerateObjectsUsingBlock:^(JYRobotReplyMsgs * _Nonnull replyMsg, NSUInteger idx, BOOL * _Nonnull stop) {
            JYAutoReplyMessageModel * message = [JYAutoReplyMessageModel findFirstByCriteria:[NSString stringWithFormat:@"WHERE msgId=%@",replyMsg.msgId]];
            if (!message) {
                message = [[JYAutoReplyMessageModel alloc] init];
                message.userId = replyRobot.userId;
                message.nickName = replyRobot.nickName;
                message.logoUrl = replyRobot.logoUrl;
                message.msgId   = replyMsg.msgId;
                message.msg    = replyMsg.msg;
                message.msgType = replyMsg.msgType;
                [message saveOrUpdate];
            } else {
                return;
            }
        }];
    }];
}

@end
