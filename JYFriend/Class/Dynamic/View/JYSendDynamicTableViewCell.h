//
//  JYSendDynamicTableViewCell.h
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JYCollectionAction)(UIImage *image , NSIndexPath *indexPath,BOOL isAddPhoto);

@interface JYSendDynamicTableViewCell : UITableViewCell

@property (nonatomic,retain) UIViewController *curentVC;
//@property (nonatomic,copy)JYCollectionAction collectAction;
@property (nonatomic,retain) UITabBar *tabBar;

@end
