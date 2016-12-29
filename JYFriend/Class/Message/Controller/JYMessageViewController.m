//
//  JYMessageViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageViewController.h"
#import "JYMessageModel.h"

@interface JYMessageViewController ()
@property (nonatomic,retain) NSMutableArray<JYMessageModel *> *chatMessages;
@end

@implementation JYMessageViewController

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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)reloadChatMessages {
    self.chatMessages = [JYMessageModel allMessagesForUser:self.user.userId].mutableCopy;
    
    [self.chatMessages enumerateObjectsUsingBlock:^(JYMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XHMessage *message;
        NSDate *date = [JYUtil dateFromString:@"19910901111111" WithDateFormat:KDateFormatLong];
        if (obj.messageType == JYMessageTypeText || obj.messageType == JYMessageTypeSystem) {
            message = [[XHMessage alloc] initWithText:obj.messageContent
                                                              sender:obj.sendUserId
                                                           timestamp:date];
            message.messageMediaType = XHBubbleMessageMediaTypeText;
        } else if (obj.messageType == JYMessageTypePhoto) {
            message = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:nil originPhotoUrl:nil sender:obj.sendUserId timestamp:date];
        } else if (obj.messageType == JYMessageTypeVioce) {
            message = [[XHMessage alloc] initWithVoicePath:@"" voiceUrl:nil voiceDuration:@"0" sender:obj.sendUserId timestamp:date];
        }
        
        if ([obj.sendUserId isEqualToString:[JYUser currentUser].userId]) {
            message.bubbleMessageType = XHBubbleMessageTypeSending;
        } else {
            message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        }
        [self.messages addObject:message];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadChatMessages];
}

- (void)addTextMessage:(NSString *)message
            withSender:(NSString *)sender
              receiver:(NSString *)receiver
              dateTime:(NSString *)dateTime
{
    JYMessageModel *chatMessage = [[JYMessageModel alloc] init];
    chatMessage.sendUserId = sender;
    chatMessage.receiveUserId = receiver;
    chatMessage.messageType = JYMessageTypeText;
    chatMessage.messageContent = message;
    chatMessage.messageTime = dateTime;

    [self addChatMessage:chatMessage];
}

- (void)addChatMessage:(JYMessageModel *)chatMessage {
    [self.chatMessages addObject:chatMessage];
    [chatMessage saveOrUpdate];
    
    if (self.isViewLoaded) {
        XHMessage *xhMsg;
        NSDate *date = [JYUtil dateFromString:@"19910901111111" WithDateFormat:KDateFormatLong];
        if (chatMessage.messageType == JYMessageTypeText) {
            xhMsg = [[XHMessage alloc] initWithText:chatMessage.messageContent
                                             sender:chatMessage.sendUserId
                                          timestamp:date];
        }
        if ([chatMessage.sendUserId isEqualToString:[JYUser currentUser].userId]) {
            xhMsg.bubbleMessageType = XHBubbleMessageTypeSending;
        } else {
            xhMsg.bubbleMessageType = XHBubbleMessageTypeReceiving;
        }
        xhMsg.avatarUrl = @"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg";
        [self addMessage:xhMsg];
    }
}


#pragma mark - XHMessageTableViewControllerDelegate

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self addTextMessage:text withSender:sender receiver:_user.userId dateTime:[JYUtil timeStringFromDate:date WithDateFormat:KDateFormatLong]];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
}

- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    
}

- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    XHMessage *message = self.messages[indexPath.row];
    
    BOOL isCurrentUser = [message.sender isEqualToString:[JYUser currentUser].userId];
    if (isCurrentUser) {
        [cell.avatarButton setImage:[UIImage imageWithData:[JYUser currentUser].userImg] forState:UIControlStateNormal];
        [cell.avatarButton bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        cell.userNameLabel.text = [JYUser currentUser].nickName;
    } else {
        [cell.avatarButton setImage:[UIImage imageWithData:[JYUser currentUser].userImg] forState:UIControlStateNormal];
        @weakify(self);
        [cell.avatarButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - XHMessageTableViewCellDelegate

#pragma mark - XHMessageInputViewDelegate

@end
