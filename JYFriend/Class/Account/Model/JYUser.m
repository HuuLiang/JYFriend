//
//  JYUser.m
//  JYFriend
//
//  Created by Liang on 2016/12/23.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYUser.h"

static JYUser *_currentUser;

@implementation JYUser

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentUser = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE isHuman=%d",YES]];
        if (!_currentUser) {
            _currentUser = [[self alloc] init];
            _currentUser.isHuman = YES;
            [_currentUser saveOrUpdate];
        }
    });
    return _currentUser;
}

+ (NSArray *)allUserHeights {
    NSMutableArray *allHeights = [NSMutableArray array];
    for (NSInteger height = 150; height <= 200; height++) {
        NSString *str = [NSString stringWithFormat:@"%ldcm",height];
        [allHeights addObject:str];
    }
    return allHeights;
}

+ (NSArray *)home {
    NSMutableArray *home = [NSMutableArray array];
    NSArray *allProvinces = [self allProvinces];
    [home addObject:allProvinces];
    [home addObject:[self allCitiesWihtProvince:[allProvinces firstObject]]];
    return home;
}

+ (NSArray *)allCitiesWihtProvince:(NSString *)province {
    NSMutableArray *cities = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i ++) {
        NSString *str = [NSString stringWithFormat:@"%@第%ld个市",province,i];
        [cities addObject:str];
    }
    return cities;
}

+ (NSArray *)allProvinces {
    NSMutableArray *provinces = [NSMutableArray array];
    for (NSInteger i = 0; i < 34; i ++) {
        NSString *str = [NSString stringWithFormat:@"第%ld个省",i];
        [provinces addObject:str];
    }
    return provinces;
}

@end
