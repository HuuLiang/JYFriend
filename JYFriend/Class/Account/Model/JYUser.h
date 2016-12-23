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

@property (nonatomic) BOOL          isHuman;    //是否是人
@property (nonatomic) NSString      *userId;    //用户id
@property (nonatomic) JYUserSex     userSex;    //性别
@property (nonatomic) NSString      *nickName;  //昵称
@property (nonatomic) NSString      *account;   //账号
@property (nonatomic) NSString      *password;  //密码
@property (nonatomic) NSString      *birthday;  //生日
@property (nonatomic) NSString      *height;    //身高
@property (nonatomic) NSString      *homeTown;  //家乡

@end
