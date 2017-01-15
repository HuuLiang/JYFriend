//
//  JYContactModel.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYContactModel.h"
#import "JYCharacterModel.h"
#import "JYMessageModel.h"

@implementation JYContactModel

+ (NSArray<JYContactModel *> *)allContacts {
    return [self findByCriteria:[NSString stringWithFormat:@"order by isStick desc,recentTime desc"]];
}

+ (void)deleteAllContacts {
    [self clearTable];
}

+ (void)insertGreetContact:(NSArray <JYCharacter *>*)usersList {
    [usersList enumerateObjectsUsingBlock:^(JYCharacter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //向消息缓存中加入打招呼的信息
        JYContactModel *contact =  [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=%@",obj.userId]];
        if (!contact) {
            contact = [[JYContactModel alloc] init];
            contact.userType = JYContactUserTypeNormal;
            contact.userId = obj.userId;
            contact.logoUrl = obj.logoUrl;
            contact.nickName = obj.nickName;
        }
        contact.recentMessage = @"用户主动向机器人打了个招呼";
        contact.recentTime = [JYUtil timeStringFromDate:[JYUtil currentDate] WithDateFormat:KDateFormatLong];
        [contact saveOrUpdate];
        
        //向聊天信息缓存中加入信息
        JYMessageModel *message = [[JYMessageModel alloc] init];
        message.sendUserId = [JYUser currentUser].userId;
        message.receiveUserId = obj.userId;
        message.messageTime = contact.recentTime;
        message.messageType = JYMessageTypeText;
        message.messageContent = contact.recentMessage;
        [message saveOrUpdate];
    }];
}


@end
