//
//  JYActivateModel.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "QBJYFriendURLRequest.h"

typedef void (^JYActivateHandler)(BOOL success, NSString *uuid);

@interface JYActivateModel : QBJYFriendURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(JYActivateHandler)handler;

@end
