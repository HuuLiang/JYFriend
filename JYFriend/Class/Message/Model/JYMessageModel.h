//
//  JYMessageModel.h
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger, JYMessageType) {
    JYMessageTypeNormal,//普通消息
    JYMessageTypeSystem, //系统消息
    JYMessageTypeVIP, //vip提示
    JYMessageTypeCount
};

@interface JYMessageModel : JKDBModel
@property (nonatomic) NSString *sendUserId;
@property (nonatomic) NSString *receiveUserId;
@property (nonatomic) NSString *msgContent;
@property (nonatomic) NSString *msgTime;
@property (nonatomic) JYMessageType msgType;
@end
