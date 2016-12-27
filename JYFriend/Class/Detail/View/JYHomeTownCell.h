//
//  JYHomeTownCell.h
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeTownCell : UICollectionViewCell

@property (nonatomic) NSInteger gender;
@property (nonatomic) NSInteger age;
@property (nonatomic,assign) NSInteger height;
@property (nonatomic,assign,getter=isVip) BOOL vip;
@property (nonatomic,assign) NSInteger distance;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *homeTown;
@end
