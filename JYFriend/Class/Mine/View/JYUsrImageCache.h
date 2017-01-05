//
//  JYUsrImageCache.h
//  JYFriend
//
//  Created by ylz on 2016/12/29.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYImageCacheModel : JYUser

@property (nonatomic) NSString *imageName;

@end

@interface JYUsrImageCache : NSObject

+ (void)writeToFileWithImage:(UIImage *)image;

+ (NSArray <UIImage *>*)fetchAllImages;

+ (BOOL)deleteCurrentImageWithIndexPath:(NSIndexPath *)indexPath;
@end
