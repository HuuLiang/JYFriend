//
//  JYDynamicModel.h
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>



@interface JYDynamic : JKDBModel
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) JYUserSex userSex;
@property (nonatomic) NSString *age;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *content;
@property (nonatomic) NSArray *imgUrls;
@property (nonatomic) BOOL isGreet;
@property (nonatomic) BOOL isFocus;
@property (nonatomic) JYDynamicType dynamicType;
@end

@interface JYDynamicResponse : QBURLResponse

@end

@interface JYDynamicModel : QBEncryptedURLRequest

@end
