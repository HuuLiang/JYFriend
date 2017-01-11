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

#define resetTime   (60*60*6)     //重置缓存时间
#define refreshTime (60*5)        //刷新数据时间

static NSString *const kJYDynamicResetTimeKeyName     = @"kJYDynamicResetTimeKeyName";
static NSString *const kJYDynamicRefreshTimeKeyName   = @"kJYDynamicRefreshTimeKeyName";
static NSString *const kJYDynamicOffsetKeyName        = @"kJYDynamicOffsetKeyName";

static NSString *const kDynamicCellReusableIdentifier = @"DynamicCellReusableIdentifier";

@interface JYDynamicViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
    NSUInteger _offset;
    NSUInteger _limit;
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
    
    //预先加载所有缓存数据
    self.dataSource =  [NSMutableArray arrayWithArray:[JYDynamic allDynamics]];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发飙" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        //发表动态
    }];
    
    _offset = [[JYUtil getValueWithKeyName:kJYDynamicOffsetKeyName] unsignedIntegerValue];
    
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
    
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        //刷新数据 判断是初始化所有数据
        [self loadDataWithOffset:self.dataSource.count limit:15 isRefresh:YES];
    }];
    
    [_layoutCollectionView JY_addPagingRefreshWithHandler:^{
        [self loadDataWithOffset:self.dataSource.count limit:5 isRefresh:NO];
    }];
    
    [_layoutCollectionView JY_triggerPullToRefresh];
    
//    for (NSInteger i = 0; i < 50; i++) {
//        JYDynamic *dynamic = [[JYDynamic alloc] init];
//        dynamic.logoUrl = @"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg";
//        dynamic.nickName = @"渣渣";
//        dynamic.userSex = i % 2+1;
//        dynamic.userId = [NSString stringWithFormat:@"%ld",i];
//        dynamic.age = [NSString stringWithFormat:@"%ld",i];
//        dynamic.time = @"1991年9月9日10:11";
//        dynamic.content = @"你好，很高兴认识你";
//        dynamic.isFocus = i % 2;
//        dynamic.isGreet = i % 2;
//        dynamic.dynamicType = i % 4;
//        
//        CGFloat originHeight = kWidth(30) + kWidth(88) + kWidth(32) + kWidth(30) + kWidth(30);
//        CGFloat contentHeight = [dynamic.content boundingRectWithSize:CGSizeMake(kScreenWidth - kWidth(62), MAXFLOAT)
//                                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kWidth(32)]}
//                                                              context:nil].size.height;
//        CGFloat typeHeight = 0;
//        if (dynamic.dynamicType == JYDynamicTypeOnePhoto) {
//            typeHeight = kScreenWidth - kWidth(60);
//        } else if (dynamic.dynamicType == JYDynamicTypeTwoPhotos) {
//            typeHeight = (kScreenWidth - kWidth(70))/2;
//        } else if (dynamic.dynamicType == JYDynamicTypeThreePhotos) {
//            typeHeight = (kScreenWidth - kWidth(72))/3;
//        } else if (dynamic.dynamicType == JYDynamicTypeVideo) {
//            typeHeight = (kScreenWidth - kWidth(60))*207/345;
//        }
//        
//        NSNumber *cellHeight = [NSNumber numberWithFloat:originHeight+contentHeight+typeHeight];
//        [self.cellHeightArray addObject:cellHeight];
//        
//        [self.dataSource addObject:dynamic];
//    }

//    [_layoutCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([JYUtil shouldRefreshContentWithKey:kJYDynamicRefreshTimeKeyName timeInterval:refreshTime]) {
        [self loadDataWithOffset:self.dataSource.count limit:2 isRefresh:YES];
    }
}

//isRefresh 判断是刷新数据还是加载数据
- (void)loadDataWithOffset:(NSUInteger)offset limit:(NSUInteger)limit isRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.dynamicModel fetchDynamicInfoWithOffset:offset limit:limit completionHandler:^(BOOL success, NSArray * obj) {
        @strongify(self);
        if (success) {
            if (isRefresh) {
                //如果是刷新数据
                //如果是初始化数据 重置本地缓存 内存数据
                if ([JYUtil shouldRefreshContentWithKey:kJYDynamicResetTimeKeyName timeInterval:resetTime]) {
                    [JYDynamic clearTable];
                    [self.dataSource removeAllObjects];
                    [self.dataSource addObjectsFromArray:obj];
                } else {
                    //则就是刷新少量最新的动态数据 插入数组前列
                    [self.dataSource insertObjects:obj atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, obj.count)]];
                }
            } else {
                //加载数据 放入数组尾部
                [self.dataSource addObjectsFromArray:obj];
            }
        }
        [JYUtil setValue:@(self.dataSource.count+obj.count) withKeyName:kJYDynamicOffsetKeyName];
        [_layoutCollectionView reloadData];
        [_layoutCollectionView JY_endPullToRefresh];
    }];
}

- (void)setDynamicTimeWithSource:(NSArray *)array atFront:(BOOL)isFront isResetDataSource:(BOOL)isReset {
    if (isReset) {
        
    }
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
