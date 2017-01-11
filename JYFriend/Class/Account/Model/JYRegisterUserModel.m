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
    NSDictionary *sexStr = @{@(JYUserSexMale)   : @"M",
                             @(JYUserSexFemale) : @"F"};
    
    NSDictionary *params = @{@"uuid":[JYUtil UUID],
                             @"nickName":user.nickName,
                             @"clientId":@"123123123",
                             @"province":user.homeTown,
                             @"city":user.homeTown,
                             @"sex":sexStr[@(user.userSex)],
                             @"userType":@(2),
                             @"height":user.height,
                             @"birthday":[JYUtil timeStringFromDate:[JYUtil dateFromString:user.birthday WithDateFormat:kDateFormatChina] WithDateFormat:kDateFormatShort]};
    
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
