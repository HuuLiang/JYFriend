//
//  JYDynamicCacheUtil.h
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYDynamicModel.h"

@interface JYDynamicCacheModel :JYDynamic

@property (nonatomic,retain) NSArray <NSString *> *images;

@end


@interface JYDynamicCacheUtil : NSObject

+ (BOOL)saveUserDynamicWithUserState:(NSString *)userState imageUrls:(NSArray <UIImage *>*)imageUrls;
+ (JYDynamicCacheModel *)fetchCurrentUserDynamic;

@end
