//
//  JYCharacterModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/11.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYCharacterModel.h"

@implementation JYCharacter

- (BOOL)isSelected {
    return YES;
}

@end


@implementation JYCharacterResponse
- (Class)userListElementClass {
    return [JYCharacter class];
}
@end


@implementation JYCharacterModel

+ (Class)responseClass {
    return [JYCharacterResponse class];
}

-(QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchChararctersInfoWithRobotsCount:(NSInteger)count CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"sex":[JYUserSexStringGet objectAtIndex:[JYUser currentUser].userSex],
                             @"number":@(count)};
    
    BOOL success = [self requestURLPath:JY_CHARACTER_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_CHARACTER_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        JYCharacterResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        
        if (handler) {
            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp.userList);
        }
    }];
    return success;
}

@end
