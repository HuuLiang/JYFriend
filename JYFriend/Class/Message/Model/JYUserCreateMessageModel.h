//
//  JYUserCreateMessageModel.h
//  JYFriend
//
//  Created by Liang on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>


typedef NS_ENUM(NSUInteger, JYUserMessageContentType) {
    JYUserMessageContentTypeText,      //文字消息
    JYUserMessageContentTypePhoto,     //图片消息
    JYUserMessageContentTypeVioce,     //声音消息
    JYUserMessageContentTypeEmotion,   //表情消息
    JYUserMessageContentTypeSystem,    //系统消息
    JYUserMessageContentTypeeCount
};

@interface JYRobotReplyMsgs : NSObject
@property (nonatomic) NSString   *msg;
@property (nonatomic) NSNumber   *msgType;
@property (nonatomic) NSString   *msgId;
@end

@interface JYReplyRobot : QBURLResponse
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSArray <JYRobotReplyMsgs *> * dialogMsgs;
@end



@interface JYUserCreateMessageResponse : QBURLResponse
@property (nonatomic) NSArray <JYReplyRobot *> *robotMsgs;
@end

@interface JYUserGreetModel : QBEncryptedURLRequest
- (BOOL)fetchRobotsReplyMessagesWithBatchRobotId:(NSArray *)userIdList
                               CompletionHandler:(QBCompletionHandler)handler;
@end


@interface JYUserFollowModel : QBEncryptedURLRequest
- (BOOL)fetchRebotReplyMessagesWithRobotId:(NSString *)receiverId
                                      Type:(JYUserCreateMessageType)type
                         CompletionHandler:(QBCompletionHandler)handler;
@end
