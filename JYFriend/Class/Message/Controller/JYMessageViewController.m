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

@interface JYMessageViewController ()
@property (nonatomic,retain) NSMutableArray<JYMessageModel *> *chatMessages;
@end

@implementation JYMessageViewController
QBDefineLazyPropertyInitialization(NSMutableArray, chatMessages)
QBDefineLazyPropertyInitialization(NSArray, emotionManagers)

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
    
    
    [self.messageTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self configEmotions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadChatMessages];
    [self.messageTableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)reloadChatMessages {
    self.chatMessages = [JYMessageModel allMessagesForUser:self.user.userId].mutableCopy;
    
    [self.chatMessages enumerateObjectsUsingBlock:^(JYMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XHMessage *message;
        NSDate *date = [JYUtil dateFromString:@"19910901111111" WithDateFormat:KDateFormatLong];
        if (obj.messageType == JYMessageTypeText) {
            message = [[XHMessage alloc] initWithText:obj.messageContent
                                                              sender:obj.sendUserId
                                                           timestamp:date];
            message.messageMediaType = XHBubbleMessageMediaTypeText;
        } else if (obj.messageType == JYMessageTypePhoto) {
            message = [[XHMessage alloc] initWithPhoto:nil
                                          thumbnailUrl:nil
                                        originPhotoUrl:nil
                                                sender:obj.sendUserId
                                             timestamp:date];
        } else if (obj.messageType == JYMessageTypeVioce) {
            message = [[XHMessage alloc] initWithVoicePath:obj.messageContent
                                                  voiceUrl:nil
                                             voiceDuration:obj.standbyContent
                                                    sender:obj.sendUserId
                                                 timestamp:date];
        } else if (obj.messageType == JYMessageTypeSystem) {
            message = [[XHMessage alloc] initWithText:obj.messageContent
                                               sender:obj.sendUserId
                                            timestamp:date];
            message.messageMediaType = XHBubbleMessageMediaTypeCustom;
        } else if (obj.messageType == JYMessageTypeEmotion) {
            message = [[XHMessage alloc] initWithEmotionPath:obj.messageContent
                                                      sender:obj.sendUserId
                                                   timestamp:date];
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
    chatMessage.messageType = JYMessageTypeSystem;
    chatMessage.messageContent = message;
    
    [self addChatMessage:chatMessage];
}

//增加一条图片信息
- (void)addPhotoMessage:(UIImage *)image
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
    chatMessage.photo = image;
    chatMessage.messageContent = thumbnailUrl;
    chatMessage.standbyContent = originPhotoUrl;
    
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
            xhMsg = [[XHMessage alloc] initWithPhoto:chatMessage.photo
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
        } else if (chatMessage.messageType == JYMessageTypeSystem) {
            xhMsg = [[XHMessage alloc] initWithText:chatMessage.messageContent
                                             sender:chatMessage.sendUserId
                                          timestamp:date];
            xhMsg.messageMediaType = XHBubbleMessageMediaTypeCustom;
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
