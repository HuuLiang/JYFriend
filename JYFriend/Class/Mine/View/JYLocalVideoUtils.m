//
//  JYLocalVideoUtils.m
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYLocalVideoUtils.h"

 static NSString *const kUserLocalVideoFiles = @"JYUserVideo.";
 static NSString *const kUserLocalVideoType = @"uer_localvideo_type_key";

@implementation JYLocalVideoUtils

+ (NSString *)currentTime {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [dateFormatter stringFromDate:currentDate];
    
}

+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d",day *D_DAY + house*D_HOUR + minute*D_MINUTE +second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d",house*D_HOUR + minute*D_MINUTE +second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d",minute*D_MINUTE +second];
    }else{
        str = [NSString stringWithFormat:@"%d",second];
    }
    return str.integerValue;
}

+ (UIImage *)getImage:(NSURL*)videoURL

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
    
}

+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)videoUrl {
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:videoUrl options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
}

+ (NSData *)videoDataWithVideo:(NSURL *)videoUrl {
    
    return [[NSData alloc] initWithContentsOfURL:videoUrl];
}

+ (BOOL)writeToFileWithVideoUrl:(NSURL *)videoUrl {
    
    NSData *data = [self videoDataWithVideo:videoUrl];
    
    NSString *boxFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *type = [videoUrl.absoluteString componentsSeparatedByString:@"."].lastObject;
    NSString *videoPath = [boxFile stringByAppendingPathComponent:kUserLocalVideoFiles];
    NSString *newVideoPath =  [videoPath stringByAppendingString:type];
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:kUserLocalVideoType];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    return [[NSFileManager defaultManager] copyItemAtPath:videoUrl.absoluteString toPath:newVideoPath error:nil];
    return [data writeToFile:newVideoPath atomically:YES];
    
}

+ (NSData *)getUserLocalVideoData {
    NSString *boxFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *videoPath = [boxFile stringByAppendingPathComponent:kUserLocalVideoFiles];
    NSData *videoData = [NSData dataWithContentsOfFile:videoPath];
    return videoData;
}

+ (NSString *)getUserLocalVideoPath{
    NSString *boxFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLocalVideoType];
    NSString *videoPath = [boxFile stringByAppendingPathComponent:kUserLocalVideoFiles];
    NSString *newVideoPath =  [videoPath stringByAppendingString:type];
    return newVideoPath;
}


@end
