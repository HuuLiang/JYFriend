//
//  JYContactModel.h
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger, JYContactUserType) {
    JYContactUserTypeNormal,//普通用户
    JYContactUserTypeSystem, //系统消息
    JYContactUserTypeCount
};

@interface JYContactModel : JKDBModel
//用户id
@property (nonatomic) NSString *userId;
//用户头像
@property (nonatomic) NSString *logoUrl;
//用户昵称
@property (nonatomic) NSString *nickName;
//用户类型
@property (nonatomic) JYContactUserType userType;
//最新消息内容
@property (nonatomic) NSString *recentMessage;
//最新消息时间
@property (nonatomic) NSString *recentTime;
//未读消息条数
@property (nonatomic) NSInteger unreadMessages;
//是否置顶
@property (nonatomic) BOOL isStick;

//获取缓存消息
+ (NSArray<JYContactModel *> *)allContacts;
//清空所有数据
+ (void)deleteAllContacts;
//删除某一条数据
//+ (void)deleteOneContactWith:(JYContactModel *)contact;

//+ (instancetype)contactWithUser:(YPBUser *)user;
//+ (instancetype)contactWithPushedMessage:(YPBPushedMessage *)message;
//+ (instancetype)existingContactWithUserId:(NSString *)userId;
//+ (BOOL)refreshContactRecentTimeWithUser:(YPBUser *)user;

@end