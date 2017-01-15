//
//  JYPayTypeCell.h
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QBOrderInfo.h>

typedef void(^payTypeAction)(void);

@interface JYPayTypeCell : UITableViewCell

@property (nonatomic) QBOrderPayType orderPayType;

@property (nonatomic) payTypeAction payAction;

@end
