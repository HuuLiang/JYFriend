//
//  JYUser.h
//  JYFriend
//
//  Created by Liang on 2016/12/23.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger,JYUserSex) {
    JYUserSexUnKnow = 0,
    JYUserSexMale, //男
    JYUserSexFemale, //女
    JYUserSexALL//所有人(附近的人)
};

@interface JYUser : JKDBModel <NSCoding>

+ (instancetype)currentUser;

//是否是人
@property (nonatomic) BOOL          isHuman;
//用户id
@property (nonatomic) NSString      *userId;
//头像
@property (nonatomic) NSData        *userImg;
//性别
@property (nonatomic) JYUserSex     userSex;
//昵称
@property (nonatomic) NSString      *nickName;
//账号
@property (nonatomic) NSString      *account;
//密码
@property (nonatomic) NSString      *password;
//生日
@property (nonatomic) NSString      *birthday;
//身高
@property (nonatomic) NSString      *height;
//家乡
@property (nonatomic) NSString      *homeTown;
//微信
@property (nonatomic) NSString      *wechat;
//QQ
@property (nonatomic) NSString      *QQ;
//手机
@property (nonatomic) NSString      *phoneNum;
//签名
@property (nonatomic) NSString      *signature;

//身高选择列表
+ (NSArray *)allUserHeights;
//家乡选择列表
+ (NSMutableDictionary *)allProvincesAndCities;
+ (NSArray *)defaultHometown;
+ (NSArray *)allCitiesWihtProvince:(NSString *)province;

@end
