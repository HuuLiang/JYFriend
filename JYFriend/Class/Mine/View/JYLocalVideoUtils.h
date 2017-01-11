//
//  JYLocalVideoUtils.h
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYLocalVideoUtils : NSObject

+ (NSString *)currentTime;
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+ (UIImage *)getImage:(NSURL*)videoURL;
+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)videoUrl ;
+ (BOOL)writeToFileWithVideoUrl:(NSURL *)videoUrl;
+ (NSData *)getUserLocalVideoData;
+ (NSString *)getUserLocalVideoPath;
//+ (void)getVideo;
@end
