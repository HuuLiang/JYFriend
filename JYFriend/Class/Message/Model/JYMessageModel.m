//
//  JYMessageModel.m
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageModel.h"

@implementation JYMessageModel
+ (NSArray<JYMessageModel *> *)allMessagesForUser:(NSString *)userId {
    return [self findByCriteria:[NSString stringWithFormat:@"WHERE sendUserId=%@ or receiveUserId=%@",userId,userId]];
}

+ (NSArray *)transients
{
    return @[@"photo"];
}


@end
