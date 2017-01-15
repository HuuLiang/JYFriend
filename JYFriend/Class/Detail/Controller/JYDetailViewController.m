//
//  JYDetailViewController.m
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDetailViewController.h"
#import "JYNewDynamicCell.h"
#import "JYHomeTownCell.h"
#import "JYPhotoCollectionViewCell.h"
#import "JYDetailUserInfoCell.h"
#import "JYDetailBottotmView.h"
#import "JYUserDetailModel.h"
#import "JYMyPhotoBigImageView.h"
#import "JYLocalVideoUtils.h"

static NSString *const kPhotoCollectionViewCellIdentifier = @"PhotoCollectionViewCell_Identifier";
static NSString *const kNewDynamicCellIdentifier = @"newDynamicCell_Identifier";
static NSString *const kDetailUserInfoCellIndetifier = @"detailuserInfoCell_indetifier";
static NSString *const kHomeTownCellIdetifier = @"hometownCell_indetifier";
static NSString *const kSectionHeaderIndetifier = @"sectionHeader_indetifier";

static CGFloat const kPhotoItemSpce = 6.;
static CGFloat const kPhotoLineSpace = 10.;


typedef NS_ENUM(NSInteger,JYSectionType) {
    JYSectionTypePhoto,
    JYSectionTypeHomeTown,
    JYSectionTypeDynamic,
    JYSectionTypeInfo,
    JYSectionTypeSectetInfo,
    JYSectionTypeVideo,
    JYSectionCount
};

//最新动态
typedef NS_ENUM(NSInteger , JYNewDynamicItem){
    JYNewDynamicItemTitle,
    JYNewDynamicItemDetailTitle,
    JYNewDynamicItemImage,
    JYNewDynamicItemTime,
    JYNewDynamicItemCount
} ;

//用户信息
typedef NS_ENUM(NSInteger , JYUserInfoItem) {
    JYUserInfoItemTitle,
    JYUserInfoItemName,
    JYUserInfoItemAge,
    JYUserInfoItemHeigth,
    JYUserInfoItemConstellation,
    JYUserInfoItemSignature,
    JYUserInfoItemCount
};
//详细信息
typedef NS_ENUM(NSInteger , JYSectetInfoItem) {
    JYSectetInfoItemTitle,
    JYSectetInfoItemWechat,
    JYSectetInfoItemQQ,
    JYSectetInfoItemPhone,
    JYSectetInfoItemCount
};

//视频认证
typedef NS_ENUM(NSInteger , JYVideoItem) {
    JYVideoItemTitle,
    JYVideoItemVideo,
    JYVideoItemCount
};

@interface JYDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}

@property (nonatomic,retain) JYDetailBottotmView *bottomView;//底部视图
@property (nonatomic,retain) JYUserDetailModel *detailModel;

@end

@implementation JYDetailViewController
QBDefineLazyPropertyInitialization(JYUserDetailModel, detailModel)


- (JYDetailBottotmView *)bottomView {
    if (_bottomView) {
        return _bottomView;
    }
    _bottomView = [[JYDetailBottotmView alloc] init];
//    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#E147a5"];
    _bottomView.buttonModels = @[[JYDetailBottomModel creatBottomModelWith:@"关注TA" withImage:@"detail_attention_icon"],
                                 [JYDetailBottomModel creatBottomModelWith:@"发短信" withImage:@"detail_message_icon"],
                                 [JYDetailBottomModel creatBottomModelWith:@"打招呼" withImage:@"detail_greet_icon"]];
    _bottomView.action = ^(UIButton *btn){
        if ([btn.titleLabel.text isEqualToString:@"关注TA"]) {
            btn.selected = !btn.selected;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.4),@(0.7),@(1.0),@(1.5)];
            animation.keyTimes = @[@(0.0),@(0.3),@(0.7),@(1.0)];
            animation.calculationMode = kCAAnimationLinear;
            [btn.imageView.layer addAnimation:animation forKey:@"SHOW"];
        }
    };
    
    [self.view addSubview:_bottomView];
    {
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kWidth(88));
    }];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    [_layoutCollectionView registerClass:[JYPhotoCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier];
    [_layoutCollectionView registerClass:[JYNewDynamicCell class] forCellWithReuseIdentifier:kNewDynamicCellIdentifier];
    [_layoutCollectionView registerClass:[JYDetailUserInfoCell class] forCellWithReuseIdentifier:kDetailUserInfoCellIndetifier];
    [_layoutCollectionView registerClass:[JYHomeTownCell class] forCellWithReuseIdentifier:kHomeTownCellIdetifier];
    [_layoutCollectionView registerClass:[UICollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeaderIndetifier];
    
    _layoutCollectionView.contentInset = UIEdgeInsetsMake(0, 0, kWidth(88.), 0);
    [self.view addSubview:_layoutCollectionView];
    {
    [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    }
    
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#E147a5"];
    @weakify(self);
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadModels];
    }];
    
    [_layoutCollectionView JY_triggerPullToRefresh];
}

- (void)loadModels {
    @weakify(self);
    [self.detailModel fetchUserDetailModelWithViewUserId:self.viewUserId CompleteHandler:^(BOOL success, JYUserDetail *useDetai) {
    if (success) {
        @strongify(self);
        [self->_layoutCollectionView reloadData];
        [self->_layoutCollectionView JY_endPullToRefresh];
    }
}];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return JYSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == JYSectionTypePhoto) {
        return self.detailModel.userPhoto.count;
    }else if (section == JYSectionTypeDynamic){
        return JYNewDynamicItemCount ;
    }else if (section == JYSectionTypeInfo){
        return JYUserInfoItemCount;
    }else if (section == JYSectionTypeSectetInfo){
        return JYSectetInfoItemCount;
    }else if (section == JYSectionTypeVideo){
        return JYVideoItemCount;
    }else if (section == JYSectionTypeHomeTown){
        return 1;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYSectionTypePhoto) {
        JYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
        if (indexPath.item == 0) {
            cell.isFirstPhoto = YES;
        }else {
            cell.isFirstPhoto = NO;
        }
        cell.imageUrl = self.detailModel.userPhoto[indexPath.item].smallPhoto;
        cell.isVideoImage = NO;
        return cell;
    }else if (indexPath.section == JYSectionTypeHomeTown){
        JYHomeTownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeTownCellIdetifier forIndexPath:indexPath];
        cell.gender = [self.detailModel.userInfo.sex isEqualToString:@"F"] ? JYUserSexFemale : JYUserSexMale;
        cell.age = self.detailModel.userInfo.age.integerValue;
        cell.height = self.detailModel.userInfo.height.integerValue;
        cell.distance = self.distance;//距离
        cell.vip = self.detailModel.userInfo.isVip.integerValue;
        cell.time = [JYLocalVideoUtils fetchTimeIntervalToCurrentTimeWithStartTime:self.dynamicTiem];
        cell.homeTown = [NSString stringWithFormat:@"%@%@",self.detailModel.userInfo.province,self.detailModel.userInfo.city];
        return cell;
    
    } else if (indexPath.section == JYSectionTypeDynamic){
        JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
        cell.title = nil;
        cell.detailTitle = nil;
        cell.vipTitle = nil;
        if (indexPath.item == JYNewDynamicItemTitle) {
            cell.title = @"最新动态";
            return cell;
        }else if (indexPath.item == JYNewDynamicItemDetailTitle){
        cell.detailTitle = self.detailModel.mood.text;
            return cell;
        }else if (indexPath.item == JYNewDynamicItemTime ){

            cell.detailTitle = self.dynamicTiem ;
            return cell;
        }else if(indexPath.item == JYNewDynamicItemImage){

            JYNewDynamicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewDynamicCellIdentifier forIndexPath:indexPath];
            cell.detaiMoods = self.detailModel.mood.moodUrl;
            cell.action = ^(NSInteger index){
                [self photoBrowseWithImageGroup:[self dynamicImageGroupWithDyImageModels:self.detailModel.mood.moodUrl] currentIndex:index isNeedBlur:NO];
            
            };
            return cell;
        }
        
    }else if (indexPath.section == JYSectionTypeInfo){
        JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
          cell.title = nil;
          cell.detailTitle = nil;
       cell.vipTitle = nil;
        if (indexPath.item == JYUserInfoItemTitle) {
            cell.title = @"个人信息";
//             cell.detailTitle = nil;
            return cell;
        }else if (indexPath.item == JYUserInfoItemName){
            cell.detailTitle = [NSString stringWithFormat:@"昵   称: %@",self.detailModel.userInfo.nickName];//;
            return cell;
        }else if (indexPath.item == JYUserInfoItemAge){
        cell.detailTitle = [NSString stringWithFormat:@"年   龄: %@",self.detailModel.userInfo.age];
            return cell;
        }else if (indexPath.item == JYUserInfoItemHeigth){
            cell.detailTitle = [NSString stringWithFormat:@"身   高: %@",self.detailModel.userInfo.height];
            return cell;
        }else if (indexPath.item == JYUserInfoItemConstellation){
            cell.detailTitle = [NSString stringWithFormat:@"星   座: %@",self.detailModel.userInfo.starSign];
            return cell;
        }else if (indexPath.item == JYUserInfoItemSignature){
            cell.detailTitle = [NSString stringWithFormat:@"个性签名: %@",self.detailModel.userInfo.note];
            return cell;
        }
    
    } else if (indexPath.section == JYSectionTypeSectetInfo){
       JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
         cell.title = nil;
        cell.detailTitle = nil;
        cell.vipTitle = nil;
        if (indexPath.item == JYSectetInfoItemTitle) {
            cell.title = @"私密资料";
//             cell.detailTitle = nil;
//            [cell.vipBtn setTitle:@"成为VIP会员" forState:UIControlStateNormal];
            cell.vipTitle = @"成为VIP会员";
            cell.vipAction = ^(id sender){
            
            };
            return cell;
        }else if (indexPath.item == JYSectetInfoItemWechat){
            
            cell.detailTitle = [NSString stringWithFormat:@"微   信: %@", [JYUser currentUser].isVip.integerValue ? self.detailModel.userInfo.weixinNum : @"仅限VIP会员查看"];
            return cell;
        }else if (indexPath.item == JYSectetInfoItemQQ){
            cell.detailTitle = [NSString stringWithFormat:@"Q    Q: %@",[JYUser currentUser].isVip.integerValue ? self.detailModel.userInfo.qq : @"仅限VIP会员查看"];
            return cell;
        }else if (indexPath.item == JYSectetInfoItemPhone){
            cell.detailTitle = [NSString stringWithFormat:@"手机号: %@",[JYUser currentUser].isVip.integerValue ? self.detailModel.userInfo.phone : @"仅限VIP会员查看"];
            return cell;
        }
    
    }else if (indexPath.section == JYSectionTypeVideo){
        if (indexPath.item == JYVideoItemTitle) {
             JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
            cell.title = @"TA的视频认证";
             cell.detailTitle = nil;
            cell.vipTitle = nil;
            return cell;
        }else if (indexPath.item == JYVideoItemVideo){
            JYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
            cell.imageUrl = self.detailModel.userVideo.imgCover;//@"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg";
            cell.isVideoImage = YES;
            return cell;
        }
    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYSectionTypePhoto) {
        CGFloat width = (kScreenWidth - kWidth(kPhotoItemSpce*2) *2 - kWidth(30.)*2 )/3.;
        return CGSizeMake(width, width);
    }else if (indexPath.section == JYSectionTypeHomeTown){
        return CGSizeMake(kScreenWidth, kWidth(150));
        
    } else if (indexPath.section == JYSectionTypeDynamic){
        if (indexPath.item == JYNewDynamicItemTitle) {
           return CGSizeMake(kScreenWidth, kWidth(90.));
        }else if (indexPath.item == JYNewDynamicItemDetailTitle ){
         return CGSizeMake(kScreenWidth, kWidth(55.));
        }else if (indexPath.item == JYNewDynamicItemTime){
        return CGSizeMake(kScreenWidth, kWidth(45.));
        }else if(indexPath.item == JYNewDynamicItemImage){
            return CGSizeMake(kScreenWidth, kWidth(140));
        }
        
    }else if (indexPath.section == JYSectionTypeInfo || indexPath.section == JYSectionTypeSectetInfo){
        if (indexPath.item == JYUserInfoItemTitle || indexPath.item == JYSectetInfoItemTitle) {
            return CGSizeMake(kScreenWidth, kWidth(90.));
        }
        return CGSizeMake(kScreenWidth, kWidth(55.));
    } else if (indexPath.section == JYSectionTypeVideo){
        if (indexPath.item == JYVideoItemTitle) {
             return CGSizeMake(kScreenWidth, kWidth(90.));
        }else if (indexPath.item == JYVideoItemVideo){
            return CGSizeMake(kScreenWidth *0.92, kWidth(0.74 *kScreenWidth));
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == JYSectionTypePhoto) {
        return kWidth(kPhotoLineSpace *2);
    }else if (section == JYSectionTypeDynamic){
      return kWidth(kPhotoLineSpace );
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == JYSectionTypePhoto) {
        return kWidth(kPhotoItemSpce *2);
    }else if (section == JYSectionTypeDynamic){
        return kWidth(kPhotoItemSpce);
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == JYSectionTypePhoto) {
        return  UIEdgeInsetsMake(kWidth(20.), kWidth(30.), kWidth(10.), kWidth(30.));
    }else if (section == JYSectionTypeVideo){
        return UIEdgeInsetsMake(0, 0, kWidth(20), 0);
    }
    return UIEdgeInsetsZero; }

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kWidth(20.));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeaderIndetifier forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        return reusableView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYSectionTypePhoto) {

        [self photoBrowseWithImageGroup:[self photoImageGroupWithUserPhotosModel:self.detailModel.userPhoto] currentIndex:indexPath.item isNeedBlur:YES];
    }else if (indexPath.section == JYSectionTypeVideo) {
    //播放视频
    
    }
    


}
/**
 用户相册的图片数组
 */
- (NSArray *)photoImageGroupWithUserPhotosModel:(NSArray <JYUserPhoto *>*)photoModels {
    NSMutableArray *arrM = [NSMutableArray array];
   [photoModels enumerateObjectsUsingBlock:^(JYUserPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [arrM addObject:obj.bigPhoto];
   }];
    return arrM.copy;
}

/**
 用户动态的图片数组
 */

- (NSArray *)dynamicImageGroupWithDyImageModels:(NSArray <JYUserDetailMood *>*)imageModels {
    NSMutableArray *arrM = [NSMutableArray array];
    [imageModels enumerateObjectsUsingBlock:^(JYUserDetailMood * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrM addObject:obj.url];
    }];
    return arrM.copy;
}

/**
 图片浏览器
 */
- (void)photoBrowseWithImageGroup:(NSArray *)imageGroup currentIndex:(NSInteger)currentIndex isNeedBlur:(BOOL)isNeedBlur{
    JYMyPhotoBigImageView *bigImageView = [[JYMyPhotoBigImageView alloc] initWithImageGroup:imageGroup frame:self.view.window.frame isLocalImage:NO isNeedBlur:isNeedBlur];
    bigImageView.backgroundColor = [UIColor whiteColor];
    bigImageView.shouldAutoScroll = NO;
    bigImageView.shouldInfiniteScroll = NO;
    bigImageView.pageControlYAspect = 0.8;
    bigImageView.currentIndex = currentIndex;
    
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

@end
