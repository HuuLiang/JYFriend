//
//  JYLocaolPhotoUtils.h
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JYLocalPhotoUtilsDelegate <NSObject>

@optional
- (void)JYLocalPhotoUtilsWithPicker:(UIImagePickerController *)picker DidFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;

@end

@interface JYLocalPhotoUtils : NSObject

@property (nonatomic,weak) id<JYLocalPhotoUtilsDelegate>delegate;

+ (instancetype)shareManager;
- (void)getImageWithSourceType:(UIImagePickerControllerSourceType)sourceType WithCurrentVC:(UIViewController *)currentVC isVideo:(BOOL)isVideo;

@end
