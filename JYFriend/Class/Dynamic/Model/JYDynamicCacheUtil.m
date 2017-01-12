//
//  JYDynamicCacheUtil.m
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYDynamicCacheUtil.h"
#import "JYUsrImageCache.h"
#import "JYMD5Utils.h"

@implementation JYDynamicCacheModel


@end


@implementation JYDynamicCacheUtil

+ (BOOL)saveUserDynamicWithUserState:(NSString *)userState imageUrls:(NSArray <UIImage *>*)imageUrls {
   
    NSMutableArray *imageMd5s = [NSMutableArray arrayWithCapacity:imageUrls.count];
    if (imageUrls.count >0) {
        [imageUrls enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageMd5s addObject:[JYUsrImageCache writeToFileWithImage:obj]];
        }];
    }
    
     JYDynamicCacheModel *model = [JYDynamicCacheModel findAll].firstObject;
    if (!model) {
        model = [[JYDynamicCacheModel alloc] init];
    }
     if ([model deleteObject]) {
        model.userId = kCurrentUser.userId;
        model.nickName = kCurrentUser.nickName;
        model.text = userState;
        model.timeInterval = [[JYUtil currentDate] timeIntervalSince1970];
        model.images = imageMd5s.copy;
        return [model saveOrUpdate];
    }

    return NO;
}

+ (JYDynamicCacheModel *)fetchCurrentUserDynamic {

    return [JYDynamicCacheModel findAll].firstObject;
}

@end
