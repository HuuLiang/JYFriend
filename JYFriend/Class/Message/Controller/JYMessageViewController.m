//
//  JYMessageViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageViewController.h"
#import "JYMessageModel.h"
#import <AVFoundation/AVFoundation.h>
#import "JYMessageViewController+XHBMessageDelegate.h"
#import "JYUserCreateMessageModel.h"
#import "JYAutoContactManager.h"


@interface JYMessageViewController ()
{
    BOOL currentUserSendingPhoto;
}
@property (nonatomic,retain) NSMutableArray<JYMessageModel *> *chatMessages;
@property (nonatomic) JYSendMessageModel *sendMessageModel;
@end

@implementation JYMessageViewController
QBDefineLazyPropertyInitialization(NSMutableArray, chatMessages)
QBDefineLazyPropertyInitialization(NSArray, emotionManagers)
QBDefineLazyPropertyInitialization(JYSendMessageModel, sendMessageModel)

+ (instancetype)showMessageWithUser:(JYUser *)user inViewController:(UIViewController *)viewController {
    JYMessageViewController *messageVC = [[self alloc] initWithUser:user];
    [viewController.navigationController pushViewController:messageVC animated:YES];
    return messageVC;
}

- (instancetype)initWithUser:(JYUser *)user {
    self = [self init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messageTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = self.user.nickName;
    self.messageSender = [JYUser currentUser].userId;
    
    
    [self configEmotions];
    [self setXHShareMenu];
}

/**
 点击加号里面
 */
- (void)setXHShareMenu{

   XHShareMenuItem *pictureItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"recommend_refresh"] title:@"图片" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:kWidth(30)]];
    XHShareMenuItem *videoItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"recommend_refresh"] title:@"视频" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:kWidth(30)]];
    
     XHShareMenuItem *photographItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"recommend_refresh"] title:@"拍照" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:kWidth(30)]];
     XHShareMenuItem *videoChatItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:@"recommend_refresh"] title:@"视频聊天" titleColor:[UIColor redColor] titleFont:[UIFont systemFontOfSize:kWidth(30)]];
    self.shareMenuItems = @[pictureItem,videoItem,photographItem,videoChatItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!currentUserSendingPhoto) {
        [self reloadChatMessages];
        [self.messageTableView reloadData];
    } else {
        currentUserSendingPhoto = NO;
    }
    [self scrollToBottomAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)reloadChatMessages {
    self.chatMessages = [JYMessageModel allMessagesForUser:self.user.userId].mutableCopy;
    
    [self.messages removeAllObjects];
    [self.chatMessages enumerateObjectsUsingBlock:^(JYMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XHMessage *message;
        NSDate *date = [JYUtil dateFromString:obj.messageTime WithDateFormat:KDateFormatLong];
        if (obj.messageType == JYMessageTypeText) {
            message = [[XHMessage alloc] initWithText:obj.messageContent
                                                              sender:obj.sendUserId
                                                           timestamp:date];
            message.messageMediaType = XHBubbleMessageMediaTypeText;
        } else if (obj.messageType == JYMessageTypePhoto) {
            message = [[XHMessage alloc] initWithPhoto:obj.photokey ? [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:obj.photokey] : nil
                                          thumbnailUrl:obj.photokey ? nil : obj.messageContent
                                        originPhotoUrl:obj.photokey ? nil : obj.messageContent
                                                sender:obj.sendUserId
                                             timestamp:date];
        } else if (obj.messageType == JYMessageTypeVioce) {
            message = [[XHMessage alloc] initWithVoicePath:obj.messageContent
                                                  voiceUrl:nil
                                             voiceDuration:obj.standbyContent
                                                    sender:obj.sendUserId
                                                 timestamp:date];
        } else if (obj.messageType == JYMessageTypeEmotion) {
            message = [[XHMessage alloc] initWithEmotionPath:obj.messageContent
                                                      sender:obj.sendUserId
                                                   timestamp:date];
        } else if (obj.messageType >= JYMessageTypeNormal) {
            message = [[XHMessage alloc] initWithText:obj.messageContent
                                               sender:obj.sendUserId
                                            timestamp:date];
            message.messageMediaType = XHBubbleMessageMediaTypeCustom;
        }
        
        if ([obj.sendUserId isEqualToString:[JYUser currentUser].userId]) {
            message.bubbleMessageType = XHBubbleMessageTypeSending;
        } else {
            message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        }
        [self.messages addObject:message];
    }];
}


//增加一条文本信息
- (void)addTextMessage:(NSString *)message
            withSender:(NSString *)sender
              receiver:(NSString *)receiver
              dateTime:(NSString *)dateTime
{
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = JYMessageTypeText;
    chatMessage.messageContent = message;
    
    [self addChatMessage:chatMessage];
}

//增加一条图片信息
- (void)addPhotoMessage:(NSString *)imagekey
           thumbnailUrl:(NSString *)thumbnailUrl
         originPhotoUrl:(NSString *)originPhotoUrl
             withSender:(NSString *)sender
               receiver:(NSString *)receiver
               dateTime:(NSString *)dateTime {
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = JYMessageTypePhoto;
    chatMessage.photokey = imagekey;
    chatMessage.messageContent = thumbnailUrl;
    chatMessage.standbyContent = originPhotoUrl;
    
    currentUserSendingPhoto = YES;
    
    [self addChatMessage:chatMessage];
}

//增加一条音频信息
- (void)addVoiceMessage:(NSString *)voicePath
          voiceDuration:(NSString *)voiceDuration
             withSender:(NSString *)sender
               receiver:(NSString *)receiver
               dateTime:(NSString *)dateTime {
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = JYMessageTypeVioce;
    chatMessage.messageContent = voicePath;
    chatMessage.standbyContent = voiceDuration;
    
    [self addChatMessage:chatMessage];
}

//增加一个表情
- (void)addEmotionMessage:(NSString *)emotionPath
               WithSender:(NSString *)sender
                 receiver:(NSString *)receiver
                 dateTime:(NSString *)dateTime {
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageTime = dateTime;
    chatMessage.messageType = JYMessageTypeEmotion;
    chatMessage.messageContent = emotionPath;
    
    [self addChatMessage:chatMessage];
}

//加入信息到数据源
- (void)addChatMessage:(JYMessageModel *)chatMessage {
    {
        //向服务器发送消息
        
        NSString *msg = nil;
        NSString *contentType = nil;
        if (chatMessage.messageType == JYMessageTypeText) {
            msg = chatMessage.messageContent;
            contentType = @"TEXT";
        } else if (chatMessage.messageType == JYMessageTypePhoto) {
            msg = [[SDImageCache sharedImageCache] defaultCachePathForKey:chatMessage.photokey];
            contentType = @"IMG";
        } else if (chatMessage.messageType == JYMessageTypeVioce) {
            msg = chatMessage.messageContent;
            contentType = @"VOICE";
        }
        
//        @weakify(self);
        [self.sendMessageModel fetchRebotReplyMessagesWithRobotId:self.user.userId
                                                              msg:msg
                                                      ContentType:contentType
                                                          msgType:JYUserCreateMessageTypeChat
                                                CompletionHandler:^(BOOL success, id obj)
         {
//            @strongify(self);
            if (success) {
                [[JYAutoContactManager manager] saveReplyRobots:obj];
            }
        }];
    }

    
    [self.chatMessages addObject:chatMessage];
    [chatMessage saveOrUpdate];
    
    if (self.isViewLoaded) {
        XHMessage *xhMsg;
        NSDate *date = [JYUtil dateFromString:chatMessage.messageTime WithDateFormat:KDateFormatLong];
        if (chatMessage.messageType == JYMessageTypeText) {
            xhMsg = [[XHMessage alloc] initWithText:chatMessage.messageContent
                                             sender:chatMessage.sendUserId
                                          timestamp:date];
        } else if (chatMessage.messageType == JYMessageTypePhoto) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:chatMessage.photokey];
            
            xhMsg = [[XHMessage alloc] initWithPhoto:image
                                        thumbnailUrl:chatMessage.messageContent
                                      originPhotoUrl:chatMessage.standbyContent
                                              sender:chatMessage.sendUserId
                                           timestamp:date];
        } else if (chatMessage.messageType == JYMessageTypeVioce) {
            xhMsg = [[XHMessage alloc] initWithVoicePath:chatMessage.messageContent
                                                voiceUrl:nil
                                           voiceDuration:chatMessage.standbyContent
                                                  sender:chatMessage.sendUserId
                                               timestamp:date isRead:NO];
        } else if (chatMessage.messageType == JYMessageTypeEmotion) {
            xhMsg = [[XHMessage alloc] initWithEmotionPath:chatMessage.messageContent
                                                    sender:chatMessage.sendUserId
                                                 timestamp:date];
        } else if (chatMessage.messageType >= JYMessageTypeNormal) {
            xhMsg = [[XHMessage alloc] initWithText:chatMessage.messageContent
                                             sender:chatMessage.sendUserId
                                          timestamp:date];
            //2种数据模型枚举匹配
            xhMsg.messageMediaType = JYMessageTypeNormal + 2;
        }
        
        if ([chatMessage.sendUserId isEqualToString:[JYUser currentUser].userId]) {
            xhMsg.bubbleMessageType = XHBubbleMessageTypeSending;
        } else {
            xhMsg.bubbleMessageType = XHBubbleMessageTypeReceiving;
        }
        [self addMessage:xhMsg];
    }
}




@end
