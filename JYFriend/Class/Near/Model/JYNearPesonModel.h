//
//  JYNearPesonModel.h
//  JYFriend
//
//  Created by ylz on 2017/1/9.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

typedef void(^JYNearPersonCompleteHander)(BOOL success , id model);

@interface JYNearPersonList : NSObject
@property (nonatomic) NSNumber *age;
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSNumber *isVip;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *note;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSString *userId;

@end

@interface JYNearPerson : QBURLResponse

@property (nonatomic,retain) NSArray <JYNearPersonList *>*programList;
@property (nonatomic) NSNumber *items;

@end


@interface JYNearPesonModel : QBEncryptedURLRequest

- (BOOL)fetchNearPersonModelWithPage:(NSInteger)page pageSize:(NSInteger)pageSize completeHandler:(JYNearPersonCompleteHander)handler;


@end
