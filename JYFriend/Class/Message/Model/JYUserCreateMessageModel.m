//
//  JYUserGreetMessageModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/13.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYUserCreateMessageModel.h"

@implementation JYRobotReplyMsgs
@end

@implementation JYReplyRobot
- (Class)dialogMsgsElementClass {
    return [JYRobotReplyMsgs class];
}
@end



@implementation JYUserCreateMessageResponse
- (Class)robotMsgsElementClass {
    return [JYReplyRobot class];
}
@end

@implementation JYUserGreetModel

+ (Class)responseClass {
    return [JYUserCreateMessageResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchRobotsReplyMessagesWithBatchRobotId:(NSArray *)userIdList CompletionHandler:(QBCompletionHandler)handler {
    
    NSString *str = [userIdList componentsJoinedByString:@"|"];
    
    NSDictionary *params = @{@"sendUserId":[JYUser currentUser].userId,
                             @"receiveUserId":str};
    
    BOOL success = [self requestURLPath:JY_BATCHGREET_URL
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYUserCreateMessageResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.robotMsgs);
        }
    }];
    return success;
}
@end


@implementation JYUserFollowModel
+ (Class)responseClass {
    return [JYUserCreateMessageResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchRebotReplyMessagesWithRobotId:(NSString *)receiverId Type:(JYUserCreateMessageType)type CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{};
    BOOL success = [self requestURLPath:nil
                         standbyURLPath:nil
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYUserCreateMessageResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.robotMsgs);
        }
    }];
    
    return success;
}
@end



