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

static NSString *const kPhotoCollectionViewCellIdentifier = @"PhotoCollectionViewCell_Identifier";
static NSString *const kNewDynamicCellIdentifier = @"newDynamicCell_Identifier";
static NSString *const kDetailUserInfoCellIndetifier = @"detailuserInfoCell_indetifier";
static NSString *const kHomeTownCellIdetifier = @"hometownCell_indetifier";
static NSString *const kSectionHeaderIndetifier = @"sectionHeader_indetifier";

static CGFloat const kPhotoItemSpce = 6.;
static CGFloat const kPhotoLineSpace = 10.;

static NSInteger const kDynamicImageCount = 1;

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

@end

@implementation JYDetailViewController

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
    
    [self.view addSubview:_layoutCollectionView];
    {
    [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    }
    
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
        return 6;
    }else if (section == JYSectionTypeDynamic){
        return JYNewDynamicItemCount + kDynamicImageCount;
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
        cell.imageUrl = @"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg";
        cell.isVideoImage = NO;
        return cell;
    }else if (indexPath.section == JYSectionTypeHomeTown){
        JYHomeTownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeTownCellIdetifier forIndexPath:indexPath];
        cell.gender = 1;
        cell.age = 19;
        cell.height = 168;
        cell.distance = 990;
        cell.vip = YES;
        cell.time = @"3分钟前";
        cell.homeTown = @"安徽黄山";
        return cell;
    
    } else if (indexPath.section == JYSectionTypeDynamic){
        JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
        if (indexPath.item == JYNewDynamicItemTitle) {
            cell.title = @"最新动态";
            return cell;
        }else if (indexPath.item == JYNewDynamicItemDetailTitle){
        cell.detailTitle = @"找个帅哥一起去看日出";
            return cell;
        }else if (indexPath.item == JYNewDynamicItemTime +kDynamicImageCount){
        cell.detailTitle = @"2016年12月8日  11:11";
            cell.detailLabel.font = [UIFont systemFontOfSize:kWidth(24.)];
            return cell;
        }else {

            JYNewDynamicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewDynamicCellIdentifier forIndexPath:indexPath];
            cell.imageUrls = @[@"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg"];
            cell.action = ^(NSInteger index){
                QBLog(@"imageIndex:%ld",index);
            
            };
            return cell;
        }
        
    }else if (indexPath.section == JYSectionTypeInfo){
        JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
        if (indexPath.item == JYUserInfoItemTitle) {
            cell.title = @"个人信息";
            return cell;
        }else if (indexPath.item == JYUserInfoItemName){
            cell.detailTitle = [NSString stringWithFormat:@"昵   称: %@",@"古风心悦"];//;
            return cell;
        }else if (indexPath.item == JYUserInfoItemAge){
        cell.detailTitle = [NSString stringWithFormat:@"年   龄: %d",19];
            return cell;
        }else if (indexPath.item == JYUserInfoItemHeigth){
            cell.detailTitle = [NSString stringWithFormat:@"身   高: %d",169];
            return cell;
        }else if (indexPath.item == JYUserInfoItemConstellation){
            cell.detailTitle = [NSString stringWithFormat:@"星   座: %@",@"狮子座"];
            return cell;
        }else if (indexPath.item == JYUserInfoItemSignature){
            cell.detailTitle = [NSString stringWithFormat:@"个性签名: %@",@"没有什么对不起,只有一句愿不愿意"];
            return cell;
        }
    
    } else if (indexPath.section == JYSectionTypeSectetInfo){
       JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
        if (indexPath.item == JYSectetInfoItemTitle) {
            cell.title = @"私密资料";
            [cell.vipBtn setTitle:@"成为VIP会员" forState:UIControlStateNormal];
            cell.vipAction = ^(id sender){
            
            };
            return cell;
        }else if (indexPath.item == JYSectetInfoItemWechat){
            cell.detailTitle = [NSString stringWithFormat:@"微   信: %@",@"仅限VIP会员查看"];
            return cell;
        }else if (indexPath.item == JYSectetInfoItemQQ){
            cell.detailTitle = [NSString stringWithFormat:@"Q    Q: %@",@"仅限VIP会员查看"];
            return cell;
        }else if (indexPath.item == JYSectetInfoItemPhone){
            cell.detailTitle = [NSString stringWithFormat:@"手机号: %@",@"仅限VIP会员查看"];
            return cell;
        }
    
    }else if (indexPath.section == JYSectionTypeVideo){
        if (indexPath.item == JYVideoItemTitle) {
             JYDetailUserInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDetailUserInfoCellIndetifier forIndexPath:indexPath];
            cell.title = @"TA的视频认证";
            return cell;
        }else if (indexPath.item == JYVideoItemVideo){
            JYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
            cell.imageUrl = @"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg";
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
        }else if (indexPath.item == JYNewDynamicItemTime + kDynamicImageCount){
        return CGSizeMake(kScreenWidth, kWidth(45.));
        }else {
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
    return UIEdgeInsetsZero;
}

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



@end
