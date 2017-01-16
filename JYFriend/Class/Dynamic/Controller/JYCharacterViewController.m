//
//  JYCharacterViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/19.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYCharacterViewController.h"
#import "JYCharacterCell.h"
#import "JYDetailViewController.h"
#import "JYCharacterModel.h"

static NSString *const kCharacterCellReusableIdentifier = @"CharacterCellReusableIdentifier";

@interface JYCharacterViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic) JYCharacterModel *characterModel;
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation JYCharacterViewController
QBDefineLazyPropertyInitialization(JYCharacterModel, characterModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.minimumLineSpacing = kWidth(20);
    mainLayout.minimumInteritemSpacing = kWidth(10);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
    [_layoutCollectionView registerClass:[JYCharacterCell class] forCellWithReuseIdentifier:kCharacterCellReusableIdentifier];
    
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithRefresh:YES];
    }];
    
    [_layoutCollectionView JY_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithRefresh:NO];
    }];
    
    [_layoutCollectionView JY_triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    [self.characterModel fetchChararctersInfoWithRobotsCount:33 CompletionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            if (isRefresh) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:obj];
            } else {
                [self.dataSource addObjectsFromArray:obj];
            }
            [self->_layoutCollectionView reloadData];
        }
        [self->_layoutCollectionView JY_endPullToRefresh];
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYCharacterCell *characterCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCharacterCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < self.dataSource.count) {
        JYCharacter *character = self.dataSource[indexPath.item];
        characterCell.userImgStr = character.logoUrl;
        characterCell.nickNameStr = character.nickName;
        characterCell.ageStr = [NSString stringWithFormat:@"%@",character.age];
    }
    return characterCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    UIEdgeInsets insets = [self collectionView:collectionView layout:layout insetForSectionAtIndex:indexPath.section];
    CGFloat fullWidth = CGRectGetWidth(collectionView.bounds);
    if (indexPath.item < 102) {
        CGFloat width = (fullWidth - insets.left - insets.right - layout.minimumInteritemSpacing * 2) / 3;
        CGFloat height = width * 13 / 11;
        return CGSizeMake((long)width, (long)height);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kWidth(20), kWidth(30), kWidth(20), kWidth(30));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        JYCharacter *character = self.dataSource[indexPath.item];
        [self pushDetailViewControllerWithUserId:character.userId time:nil distance:nil];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}

@end
