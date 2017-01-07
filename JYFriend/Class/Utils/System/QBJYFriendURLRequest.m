//
//  QBJYFriendURLRequest.m
//  JYFriend
//
//  Created by Liang on 2017/1/7.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "QBJYFriendURLRequest.h"
#import "NSDictionary+QBSign.h"

NSString *const kQBJYFriendSignKey = @"qdge^%$#@(sdwHs^&";
NSString *const kQBJYFriendEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";


@implementation QBJYFriendURLRequest

//- (QBNetworkingConfiguration *)configuration {
//    return [QBPaymentNetworkingConfiguration defaultConfiguration];
//}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

+ (NSString *)signKey {
    return kQBJYFriendSignKey;
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    if (!params) {
        return nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [array addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    NSString *endataStr = [array componentsJoinedByString:@"&"];
    NSString *encryptedKey = [endataStr encryptedStringWithPassword:[kQBJYFriendEncryptionPassword.md5 substringToIndex:16]];
    
    return @{@"data":encryptedKey};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"data":encryptedKey} options:0 error:nil];
//    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    str = [str stringByReplacingOccurrencesOfString:@"{" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"}" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"="];
//    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    return str;
}


@end
