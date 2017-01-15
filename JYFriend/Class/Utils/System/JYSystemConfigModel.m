//
//  JYSystemConfigModel.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYSystemConfigModel.h"

static NSString *const kPPVideoSystemConfigPayAmountKeyName       = @"PP_SystemConfigPayAmount_KeyName";
static NSString *const kPPVideoSystemConfigPayzsAmountKeyName     = @"PP_SystemConfigPayzsAmount_KeyName";
static NSString *const kPPVideoSystemConfigPayhjAmountKeyName     = @"PP_SystemConfigPayhjAmount_KeyName";

@implementation JYSystemConfigResponse

- (Class)configsElementClass {
    return [JYSystemConfig class];
}

@end

@implementation JYSystemConfigModel

+ (instancetype)sharedModel {
    static JYSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JYSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [JYSystemConfigResponse class];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.payAmount = [[coder decodeObjectForKey:kPPVideoSystemConfigPayAmountKeyName] integerValue];
        self.payzsAmount = [[coder decodeObjectForKey:kPPVideoSystemConfigPayzsAmountKeyName] integerValue];
        self.payhjAmount = [[coder decodeObjectForKey:kPPVideoSystemConfigPayhjAmountKeyName] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.payAmount] forKey:kPPVideoSystemConfigPayAmountKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.payzsAmount] forKey:kPPVideoSystemConfigPayzsAmountKeyName];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.payhjAmount] forKey:kPPVideoSystemConfigPayhjAmountKeyName];
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(JYFetchSystemConfigCompletionHandler)handler {
    
//    NSDictionary *params = @{@"type":@([JYUtil deviceType])};
    
    @weakify(self);
    BOOL success = [self requestURLPath:JY_SYSTEM_CONFIG_URL
                         standbyURLPath:[JYUtil getStandByUrlPathWithOriginalUrl:JY_SYSTEM_CONFIG_URL params:nil]
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        if (respStatus == QBURLResponseSuccess) {
                            JYSystemConfigResponse *resp = self.response;
                            
                            [resp.configs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                JYSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:JY_SYSTEM_PAY_AMOUNT]) {
                                    [JYSystemConfigModel sharedModel].payAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:JY_SYSTEM_PAY_HJ_AMOUNT]) {
                                    [JYSystemConfigModel sharedModel].payhjAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:JY_SYSTEM_PAY_ZS_AMOUNT]) {
                                    [JYSystemConfigModel sharedModel].payzsAmount = [config.value integerValue];
                                } else if ([config.name isEqualToString:JY_SYSTEM_IMAGE_TOKEN]) {
                                    [JYSystemConfigModel sharedModel].imageToken = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_NAME_1]) {
                                    [JYSystemConfigModel sharedModel].contactName1 = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_NAME_2]) {
                                    [JYSystemConfigModel sharedModel].contactName2 = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_NAME_3]) {
                                    [JYSystemConfigModel sharedModel].contactName3 = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_SCHEME_1]) {
                                    [JYSystemConfigModel sharedModel].contactScheme1 = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_SCHEME_2]) {
                                    [JYSystemConfigModel sharedModel].contactScheme2 = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_CONTACT_SCHEME_3]) {
                                    [JYSystemConfigModel sharedModel].contactScheme3 = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_BAIDUYU_URL]) {
                                    [JYSystemConfigModel sharedModel].baiduyuUrl = config.value;
                                } else if ([config.name isEqualToString:JY_SYSTEM_BAIDUYU_CODE]) {
                                    [JYSystemConfigModel sharedModel].baiduyuCode = config.value;
                                }
                                
                                //刷新价格缓存
//                                [PPCacheModel updateSystemConfigModelWithSystemConfigModel:[PPSystemConfigModel sharedModel]];
                            }];
                            _loaded = YES;
                        }
                        
                        if (handler) {
                            handler(respStatus == QBURLResponseSuccess);
                        }
                    }];
    return success;
}


@end
