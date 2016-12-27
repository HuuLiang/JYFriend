//
//  JYContactModel.m
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYContactModel.h"

@implementation JYContactModel

+ (NSArray<JYContactModel *> *)allContacts {
    return [self findByCriteria:[NSString stringWithFormat:@"order by isStick desc,recentTime desc"]];
}

+ (void)deleteAllContacts {
    [self clearTable];
}

//+ (void)deleteOneContactWith:(JYContactModel *)contact {
//    [contact deleteObject];
//}


@end
