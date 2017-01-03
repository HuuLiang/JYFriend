//
//  JYMyPhotosController.m
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMyPhotosController.h"
#import "JYMyPhotoCell.h"
#import "JYMyPhotoBigImageView.h"
#import "JYUsrImageCache.h"
#import "JYLocalPhotoUtils.h"

static CGFloat klineSpace = 7.;
static CGFloat kitemSpace = 10.;

static NSString *const kMyPhotoChcheIndex = @"my_photo_chche_index";
static NSString *const kMyPhotoCellIndetifier = @"myphotocell_indetifier";

@interface JYMyPhotosController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,JYLocalPhotoUtilsDelegate>
{
    UICollectionView *_layoutCollectionView;
}

@property (nonatomic,retain) UIActionSheet *photoActionSheet;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic) NSString *imagePath;
@end

@implementation JYMyPhotosController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (UIActionSheet *)photoActionSheet {
    if (_photoActionSheet) {
        return _photoActionSheet;
    }
    _photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    
    return _photoActionSheet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的相册";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kWidth(kitemSpace *2);
    layout.minimumLineSpacing = kWidth(klineSpace *2);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.contentInset = UIEdgeInsetsMake(kWidth(30), kWidth(30), kWidth(20), kWidth(30));
    [_layoutCollectionView registerClass:[JYMyPhotoCell class] forCellWithReuseIdentifier:kMyPhotoCellIndetifier];
    [self.view addSubview:_layoutCollectionView];
    {
    [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        [self loadPhotoMode];
    }];
    [_layoutCollectionView JY_triggerPullToRefresh];
}

- (void)loadPhotoMode {
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        self.dataSource = [JYUsrImageCache fetchAllImages].mutableCopy;
        [self->_layoutCollectionView reloadData];
        [self->_layoutCollectionView JY_endPullToRefresh];
    });

}

- (NSData *)imageTranslationDateWithImageArr:(NSArray *)imageArr {
    NSData *date = [NSKeyedArchiver archivedDataWithRootObject:imageArr];
    return date;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)getImageWithSourceType:(UIImagePickerControllerSourceType)sourceType {
//    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.delegate = self;
//        picker.allowsEditing = YES;
//        picker.sourceType = sourceType;
//        if ([JYUtil isIpad]) {
//            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
//            [popover presentPopoverFromRect:CGRectMake(0, 0, kScreenWidth, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        } else {
//            [self presentViewController:picker animated:YES completion:nil];
//        }
//    } else {
//        NSString *sourceTypeTitle = sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? @"相册":@"相机";
//        [[JYHudManager manager] showHudWithTitle:sourceTypeTitle message:[NSString stringWithFormat:@"请在设备的\"设置-隐私-%@\"中允许访问%@",sourceTypeTitle,sourceTypeTitle]];
//    }
//}


#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count +1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYMyPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyPhotoCellIndetifier forIndexPath:indexPath];
    if (indexPath.item == self.dataSource.count) {
        cell.isAdd = YES;
        cell.imageUrl = nil;
    }else {
        cell.isAdd = NO;
        cell.image = self.dataSource[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        CGFloat width = (kScreenWidth - kWidth(30)*2 - kWidth(kitemSpace*2)*2)/3.;
    
        return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.dataSource.count) {
        [self.photoActionSheet showFromTabBar:self.tabBarController.tabBar];
    }else {
        
        JYMyPhotoBigImageView *bigImageView = [[JYMyPhotoBigImageView alloc] initWithImageGroup:self.dataSource frame:self.view.window.frame];
//        bigImageView.frame = self.view.window.frame;
        bigImageView.backgroundColor = [UIColor whiteColor];
//        bigImageView.images = self.dataSource;
        bigImageView.shouldAutoScroll = NO;
        bigImageView.shouldInfiniteScroll = NO;
        bigImageView.pageControlYAspect = 0.8;
        bigImageView.currentIndex = indexPath.item;
        
        @weakify(bigImageView);
        bigImageView.action = ^(id sender){
            @strongify(bigImageView);
            
            [UIView animateWithDuration:0.5 animations:^{
                bigImageView.alpha = 0;

            } completion:^(BOOL finished) {
                
                [bigImageView removeFromSuperview];
            }];
         
        };
        [self.view.window addSubview:bigImageView];
        bigImageView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            bigImageView.alpha = 1;
        }];
        
    }

}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
        //相册
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (buttonIndex == 1){//相机
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    if (type == UIImagePickerControllerSourceTypePhotoLibrary || type == UIImagePickerControllerSourceTypeCamera) {
        [JYLocalPhotoUtils shareManager].delegate = self;
        [[JYLocalPhotoUtils shareManager] getImageWithSourceType:type WithCurrentVC:self isVideo:NO];
    }
    
}


#pragma mark JYLocalPhotoUtilsDelegate 相机相册访问

- (void)JYLocalPhotoUtilsWithPicker:(UIImagePickerController *)picker DidFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
     [JYUsrImageCache writeToFileWithImage:info[UIImagePickerControllerOriginalImage]];
     [_layoutCollectionView JY_triggerPullToRefresh];
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            if (self.dataSource.count != [JYUsrImageCache fetchAllImages].count) {
    
                [self.dataSource addObject:[JYUsrImageCache fetchAllImages].lastObject];
                [self->_layoutCollectionView reloadData];
                [self->_layoutCollectionView JY_triggerPullToRefresh];
            }
        });

}



@end
