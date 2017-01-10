//
//  JYConfig.h
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#ifndef JYConfig_h
#define JYConfig_h

#define JY_CHANNEL_NO               [JYConfiguration sharedConfig].channelNo
#define JY_REST_APPID               @"QUBA_2026"
#define JY_REST_PV                  @"100"
#define JY_PAYMENT_PV               @"100"
#define JY_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."

#define JY_REST_APP_VERSION         ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
//#define JY_PAYMENT_RESERVE_DATA     [NSString stringWithFormat:@"%@$%@", JY_REST_APPID, JY_CHANNEL_NO]

#define JY_BASE_URL                    @"http://192.168.1.123:8099"//@"http://iv.zcqcmj.com"
#define JY_STANDBY_BASE_URL            @"http://sfs.dswtg.com/"


#define JY_ACTIVATION_URL              @"/mfwcps/jihuo.htm"
#define JY_ACCESS_URL                  @"/iosvideo/userAccess.htm"
#define JY_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"
#define JY_NEAR_PERSON_URL             @"/mfwcps/peopleNearby.htm"
#define JY_USER_DETAIL_URL             @"/mfwcps/userDetails.htm"


//#define JY_TRAIL_URL                   @"/iosvideo/homePage.htm"
//#define JY_VIPA_URL                    @"/iosvideo/vipVideo.htm"
//#define JY_VIPB_URL                    @"/iosvideo/zsVipVideo.htm"
//#define JY_VIPC_URL                    @"/iosvideo/hjVipVideo.htm"
//#define JY_SEX_URL                     @"/iosvideo/channelRanking.htm"
//#define JY_HOT_URL                     @"/iosvideo/hotTag.htm"
//#define JY_SEARCH_URL                  @"/iosvideo/search.htm"
//#define JY_DETAIL_URL                  @"/iosvideo/detailsg.htm"

#define PP_APP_URL                     @"/iosvideo/appSpreadList.htm"
#define JY_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"

#define JY_UMENG_APP_ID                @"580de5dbae1bf85293000504"

#endif /* JYConfig_h */
