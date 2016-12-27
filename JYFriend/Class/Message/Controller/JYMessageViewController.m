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


#pragma mark - XHMessageTableViewControllerDelegate

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    
}

- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    
}

- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath targetMessage:(id<XHMessageModel>)message {
    return nil;
}

#pragma mark - XHMessageTableViewCellDelegate

#pragma mark - XHMessageInputViewDelegate

@end
