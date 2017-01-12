//
//  JYDynamicCell.h
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYDynamicModel;


@interface JYDynamicCell : UICollectionViewCell

//- (void)updateCellContentWithInfo:(JYDynamic *)dynamic;

@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *nickName;
@property (nonatomic) JYUserSex userSex;
@property (nonatomic) NSString * age;
@property (nonatomic) BOOL isFocus;
@property (nonatomic) BOOL isGreet;
@property (nonatomic) NSInteger timeInterval;
@property (nonatomic) NSString *content; 

@property (nonatomic) JYDynamicType dynamicType;
@property (nonatomic) NSArray *moodUrl;

@end
