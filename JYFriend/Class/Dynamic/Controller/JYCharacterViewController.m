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

static NSString *const kCharacterCellReusableIdentifier = @"CharacterCellReusableIdentifier";

@interface JYCharacterViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}
@end

@implementation JYCharacterViewController

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
    [_layoutCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 102;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYCharacterCell *characterCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCharacterCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.item < 102) {
        characterCell.userImgStr = @"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg";
        characterCell.nickNameStr = @"渣渣";
        characterCell.ageStr = @"24岁";
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
    if (indexPath.item < 100) {
        JYDetailViewController *detailVC = [[JYDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[QBStatsManager sharedManager] statsTabIndex:self.tabBarController.selectedIndex subTabIndex:NSNotFound forSlideCount:1];
}


@end
