//
//  JYMessageCell.h
//  JYFriend
//
//  Created by Liang on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYMessageCell : UITableViewCell
@property (nonatomic) QBAction touchUserImgVAction;
@property (nonatomic) NSString *userImgStr;
@property (nonatomic) NSString *nickNameStr;
@property (nonatomic) NSString *timeStr;
@property (nonatomic) NSString *latestMessage;
@end
