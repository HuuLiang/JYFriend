//
//  JYDynamicViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDynamicViewController.h"
#import "JYDynamicCell.h"
#import "JYDynamicModel.h"

static NSString *const kDynamicCellReusableIdentifier = @"DynamicCellReusableIdentifier";

@interface JYDynamicViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSMutableArray *cellHeightArray;
@property (nonatomic) JYDynamicModel *dynamicModel;
@end

@implementation JYDynamicViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
QBDefineLazyPropertyInitialization(NSMutableArray, cellHeightArray)
QBDefineLazyPropertyInitialization(JYDynamicModel, dynamicModel)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发飙" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        //发表动态
    }];
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[JYDynamicCell class] forCellWithReuseIdentifier:kDynamicCellReusableIdentifier];
    
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    for (NSInteger i = 0; i < 50; i++) {
        JYDynamic *dynamic = [[JYDynamic alloc] init];
        dynamic.logoUrl = @"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg";
        dynamic.nickName = @"渣渣";
        dynamic.userSex = i % 2+1;
        dynamic.userId = [NSString stringWithFormat:@"%ld",i];
        dynamic.age = [NSString stringWithFormat:@"%ld",i];
        dynamic.time = @"1991年9月9日10:11";
        dynamic.content = @"你好，很高兴认识你";
        dynamic.isFocus = i % 2;
        dynamic.isGreet = i % 2;
        dynamic.dynamicType = i % 4;
        
        CGFloat originHeight = kWidth(30) + kWidth(88) + kWidth(32) + kWidth(30) + kWidth(30);
        CGFloat contentHeight = [dynamic.content boundingRectWithSize:CGSizeMake(kScreenWidth - kWidth(62), MAXFLOAT)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kWidth(32)]}
                                                              context:nil].size.height;
        CGFloat typeHeight = 0;
        if (dynamic.dynamicType == JYDynamicTypeOnePhoto) {
            typeHeight = kScreenWidth - kWidth(60);
        } else if (dynamic.dynamicType == JYDynamicTypeTwoPhotos) {
            typeHeight = (kScreenWidth - kWidth(70))/2;
        } else if (dynamic.dynamicType == JYDynamicTypeThreePhotos) {
            typeHeight = (kScreenWidth - kWidth(72))/3;
        } else if (dynamic.dynamicType == JYDynamicTypeVideo) {
            typeHeight = (kScreenWidth - kWidth(60))*207/345;
        }
        
        NSNumber *cellHeight = [NSNumber numberWithFloat:originHeight+contentHeight+typeHeight];
        [self.cellHeightArray addObject:cellHeight];
        
        [self.dataSource addObject:dynamic];
    }
    
    [_layoutCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYDynamicCell *dynamicCell = [collectionView dequeueReusableCellWithReuseIdentifier:kDynamicCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.dataSource.count) {
        JYDynamic *dynamic = self.dataSource[indexPath.item];
        dynamicCell.logoUrl = dynamic.logoUrl;
        dynamicCell.nickName = dynamic.nickName;
        dynamicCell.age = dynamic.age;
        dynamicCell.userSex = dynamic.userSex;
        dynamicCell.time = dynamic.time;
        dynamicCell.content = dynamic.content;
        dynamicCell.isFocus = dynamic.isFocus;
        dynamicCell.isGreet = dynamic.isGreet;
        dynamicCell.dynamicType = dynamic.dynamicType;
    }
    return dynamicCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.item < self.dataSource.count) {
        CGFloat width = fullWidth;
        CGFloat height = [self.cellHeightArray[indexPath.item] floatValue];
        return CGSizeMake((long)width, (long)height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), 0, kWidth(20), 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}
@end
