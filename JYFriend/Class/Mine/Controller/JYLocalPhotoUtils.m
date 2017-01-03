//
//  JYLocaolPhotoUtils.m
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYLocalPhotoUtils.h"
#import "JYUsrImageCache.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface JYLocalPhotoUtils ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation JYLocalPhotoUtils

+ (instancetype)shareManager{
    static JYLocalPhotoUtils *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JYLocalPhotoUtils alloc] init];
    });
    return _instance;
}

- (void)getImageWithSourceType:(UIImagePickerControllerSourceType)sourceType WithCurrentVC:(UIViewController *)currentVC isVideo:(BOOL)isVideo{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.editing = YES;
        picker.delegate = self;
        picker.sourceType = sourceType;
        if (isVideo) picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];//判断是否是视频
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            picker.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        if ([JYUtil isIpad]) {
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
            [popover presentPopoverFromRect:CGRectMake(0, 0, kScreenWidth, 200) inView:currentVC.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [currentVC presentViewController:picker animated:YES completion:nil];
        }
    } else {
        NSString *sourceTypeTitle = sourceType == (UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum) ? @"相册":@"相机";
        [[JYHudManager manager] showHudWithTitle:sourceTypeTitle message:[NSString stringWithFormat:@"请在设备的\"设置-隐私-%@\"中允许访问%@",sourceTypeTitle,sourceTypeTitle]];
    }
}

- (void)dealloc {

}

#pragma mark UIImagePickerControllerDelegate 相机相册访问

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if ([self.delegate respondsToSelector:@selector(JYLocalPhotoUtilsWithPicker:DidFinishPickingMediaWithInfo:)]) {
        [self.delegate JYLocalPhotoUtilsWithPicker:picker DidFinishPickingMediaWithInfo:info];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
