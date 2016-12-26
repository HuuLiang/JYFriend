//
//  JYUser.h
//  JYFriend
//
//  Created by Liang on 2016/12/23.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger,JYUserSex) {
    JYUserSexUnKnow,
    JYUserSexMale, //男
    JYUserSexFemale //女
};

@interface JYUser : JKDBModel

+ (instancetype)currentUser;

//是否是人
@property (nonatomic) BOOL          isHuman;
//用户id
@property (nonatomic) NSString      *userId;
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

//身高选择列表
+ (NSArray *)allUserHeights;
//家乡选择列表
+ (NSMutableDictionary *)allProvincesAndCities;
+ (NSArray *)defaultHometown;
+ (NSArray *)allCitiesWihtProvince:(NSString *)province;
@end
