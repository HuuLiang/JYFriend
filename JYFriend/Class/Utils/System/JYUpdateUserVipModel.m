//
//  JYUpdateUserVipModel.m
//  JYFriend
//
//  Created by Liang on 2017/1/16.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYUpdateUserVipModel.h"

@implementation JYUpdateUserVipModel

- (BOOL)updateUserVipInfo:(JYVipType)vipType CompletionHandler:(QBCompletionHandler)handler {
    NSDictionary *params = @{};
    
    BOOL success = [self requestURLPath:nil
                         standbyURLPath:nil
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        
    }];
    
    return success;
}

@end
