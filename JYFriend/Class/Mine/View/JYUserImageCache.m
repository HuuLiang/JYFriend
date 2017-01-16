//
//  JYUserImageCache.m
//  JYFriend
//
//  Created by ylz on 2016/12/29.
//  Copyright © 2016年 Liang. All rights reserved.
//
#import "JYUserImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "JYMD5Utils.h"
#import <SDImageCache.h>

static NSString *const filePaths = @"JYMyPhotos";

static NSString *const kJYImageCacheImageName = @"jiaoyou_imagemodel_imagechche_key";

@implementation JYImageCacheModel


@end

@implementation JYUserImageCache

+ (instancetype)shareInstance{
    static JYUserImageCache *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JYUserImageCache alloc] init];
    });
    return _instance;
}


+ (NSString *)writeToFileWithImage:(UIImage *)image needSaveImageName:(BOOL)needSaveName{
    
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width*0.9, image.size.height*0.9));
        [image drawInRect:CGRectMake(0,0,image.size.width*0.9,image.size.height*0.9)];
//        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //~>下面代码通过循环将图片稳定在400k以内
        NSData *data1 = UIImageJPEGRepresentation(image ,1);
       NSData *imageData = data1;
        long long alength= imageData.length;
        NSInteger i = 0;
        for (NSInteger j = 0 ; j < 10; j ++) {
            if (alength/1024 > 300) {
                i ++;
                NSData *data1 = UIImageJPEGRepresentation(image ,1-i * 0.1);
               imageData = data1;
                alength= imageData.length;
//                QBLog(@"alength%lldk",alength/1024);
            }else{
                break;
            }
        }
    UIImage *newImage = [UIImage imageWithData:imageData];
    
//    QBLog(@"newImage%@",newImage)
    
    NSString *imageDataMd5 = [JYMD5Utils md5Data:imageData];
//    QBLog(@"---md5 %@",imageDataMd5)
    if (needSaveName) {
        [self saveImageWithImageName:imageDataMd5];
    }
    
    [[SDImageCache sharedImageCache] storeImage:newImage forKey:imageDataMd5 toDisk:YES];
    
    return imageDataMd5;
}


+ (void)saveImageWithImageName:(NSString *)imageName {

    if ([[self fetchImageNames] containsObject:imageName]) {
        [[JYHudManager manager] showHudWithText:@"您的相册已经有了这张图片"];
        return;
    }
    
   JYImageCacheModel *model = [[JYImageCacheModel alloc] init];
    model.imageName = imageName;
    [model saveOrUpdate];
    
}

+ (NSArray *)fetchImageNames {
     NSMutableArray *imageArr = [NSMutableArray array];
    [[JYImageCacheModel findAll] enumerateObjectsUsingBlock:^(JYImageCacheModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.imageName) {
            [imageArr addObject:obj.imageName];
        }
    }];
    
  return imageArr.copy;
}

+ (NSArray <UIImage *>*)fetchAllImages {

    NSMutableArray *imageArr = [NSMutableArray array];
    [[self fetchImageNames] enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:obj]) {
        [imageArr addObject:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:obj]];
    }
}];
    return imageArr.copy;
}


+ (BOOL)deleteCurrentImageWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= [JYImageCacheModel findAll].count) {
        return NO;
    }
  JYImageCacheModel *model =  [JYImageCacheModel findAll][indexPath.item];
    [[SDImageCache sharedImageCache] removeImageForKey:model.imageName];
  return  [model deleteObject];
}

@end
