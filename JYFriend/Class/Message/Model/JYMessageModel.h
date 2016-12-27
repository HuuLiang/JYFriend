//
//  JYMessageModel.h
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger, JYMessageType) {
    JYMessageTypeText,      //文字消息
    JYMessageTypePhoto,     //图片消息
    JYMessageTypeVioce,     //声音消息
    JYMessageTypeSystem,    //系统消息
    JYMessageTypeCount
};

//XHBubbleMessageMediaTypeText = 0,
//XHBubbleMessageMediaTypePhoto = 1,
//XHBubbleMessageMediaTypeVideo = 2,
//XHBubbleMessageMediaTypeVoice = 3,
//XHBubbleMessageMediaTypeEmotion = 4,

@interface JYMessageModel : JKDBModel

//@property (nonatomic) NSString *sendUserId;
//@property (nonatomic) NSString *receiveUserId;

@property (nonatomic) NSString *messageId;
@property (nonatomic) NSString *sendUserId;
@property (nonatomic) NSString *receiveUserId;

@property (nonatomic) JYMessageType messageType;
@property (nonatomic) NSString *messageContent;
@property (nonatomic) NSString *messageTime;

//@property (nonatomic) NSString *options;

//+ (instancetype)chatMessage;
+ (NSArray<JYMessageModel *> *)allMessagesForUser:(NSString *)userId;

//+ (instancetype)chatMessageFromPushedMessage:(YPBPushedMessage *)message;



@end
