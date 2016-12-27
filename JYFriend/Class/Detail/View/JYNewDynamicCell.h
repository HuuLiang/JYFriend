//
//  JYNewDynamicCell.h
//  JYFriend
//
//  Created by ylz on 2016/12/27.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JYImageClickBlock)(NSInteger idx);

@interface JYNewDynamicCell : UICollectionViewCell

@property (nonatomic,retain) NSArray<NSString *> *imageUrls;
@property (nonatomic,copy)JYImageClickBlock action;

@end
