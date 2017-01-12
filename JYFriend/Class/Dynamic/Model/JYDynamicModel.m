//
//  JYDynamicModel.m
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDynamicModel.h"


@implementation JYDynamic
+ (NSArray <JYDynamic *>*)allDynamics {
    return [self findAll];
}
@end



@implementation JYDynamicResponse


@end


@implementation JYDynamicModel

+ (Class)responseClass {
    return [JYDynamicResponse class];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSTimeInterval)requestTimeInterval {
    return 10;
}

- (BOOL)fetchDynamicInfoWithOffset:(NSUInteger)offset limit:(NSUInteger)limit completionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{@"userId":[JYUser currentUser].userId,
                             @"offset":@(offset),
                             @"limit":@(limit)};
    @weakify(self);
    BOOL success = [self requestURLPath:JY_DYNAMIC_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_DYNAMIC_URL params:params]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        JYDynamicResponse *resp = nil;
                        if (respStatus == QBURLResponseSuccess) {
                            resp = self.response;
                        }
                        if (handler) {
                            QBSafelyCallBlock(handler,respStatus == QBURLResponseSuccess,resp);
                        }
                    }];
    return success;
}

@end
