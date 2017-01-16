//
//  JYRegisterUserModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/10.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYRegisterUserModel.h"

@implementation JYRegisterUserResponse

@end


@implementation JYRegisterUserModel

+ (Class)responseClass {
    return [JYRegisterUserResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)registerUserWithUserInfo:(JYUser *)user completionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"uuid":[JYUtil UUID],
                             @"nickName":user.nickName,
                             @"clientId":@"defaultClientId",
                             @"province":user.homeTown ? user.homeTown : @"",
                             @"city":user.homeTown ? user.homeTown :@"",
                             @"sex":[JYUserSexStringGet objectAtIndex:user.userSex],
                             @"userType":@(2),
                             @"height":user.height,
                             @"birthday":user.birthday ? [JYUtil timeStringFromDate:[JYUtil dateFromString:user.birthday WithDateFormat:kDateFormatChina] WithDateFormat:kDateFormatShort] : @""};
    
    BOOL success = [self requestURLPath:JY_USERCREATE_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_USERCREATE_URL params:nil]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        JYRegisterUserResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess , resp.userId);
                        }
                    }];
    
    return success;
}


@end
