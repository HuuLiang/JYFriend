//
//  JYDynamicCell.h
//  JYFriend
//
//  Created by Liang on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYDynamic;

typedef NS_ENUM(NSUInteger, JYDynamicType) {
    JYDynamicTypeOnePhoto = 0,  //1张照片
    JYDynamicTypeTwoPhotos,     //2张照片
    JYDynamicTypeThreePhotos,   //3张照片
    JYDynamicTypeVideo,         //视频
    JYDynamicTypeCount
};


@interface JYDynamicCell : UICollectionViewCell

- (void)updateCellContentWithInfo:(JYDynamic *)dynamic;

@property (nonatomic) JYDynamicType dynamicType;

@end
