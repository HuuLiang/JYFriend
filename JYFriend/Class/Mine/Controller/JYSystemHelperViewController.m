//
//  JYSystemHelperViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/19.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYSystemHelperViewController.h"
#import "JYSystemHelperCell.h"

static NSInteger const kDefaultItemSizes = 6;
static NSString *const kSystemHelperCellIdentifier = @"jy_system_helper_cell_identifier";
static NSString *const kSystemHelperHeaderCellIdentifier = @"jy_system_helper_header_cell_identifier";

@interface JYSystemHelperViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_layoutCollectiongView;
}

@end

@implementation JYSystemHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"红娘助手";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    _layoutCollectiongView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectiongView.backgroundColor = self.view.backgroundColor;
    _layoutCollectiongView.delegate = self;
    _layoutCollectiongView.dataSource = self;
    [_layoutCollectiongView registerClass:[JYSystemHelperCell class] forCellWithReuseIdentifier:kSystemHelperCellIdentifier];
    [_layoutCollectiongView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSystemHelperHeaderCellIdentifier];
    [self.view addSubview:_layoutCollectiongView];
    {
    [_layoutCollectiongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    _layoutCollectiongView.contentInset = UIEdgeInsetsMake(0, 40, 0, 40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kDefaultItemSizes ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item == 0) {
//            UICollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:kSystemHelperHeaderCellIdentifier forIndexPath:indexPath];
//            UILabel *titleLabel = [[UILabel alloc] init];
//            titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
//            titleLabel.text = @"红娘今日配对";
//            titleLabel.textColor = kColor(@"#333333");
//            titleLabel.textAlignment = NSTextAlignmentCenter;
//            [headerCell.contentView addSubview:titleLabel];
//            {
//            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(headerCell.contentView);
//                make.height.mas_equalTo(kWidth(30));
//            }];
//            }
//        return headerCell;
//    }
    JYSystemHelperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSystemHelperCellIdentifier forIndexPath:indexPath];
    cell.imageUrl = @"http://mfw.jtd51.com/wysy/images/usericon128.jpg";
    cell.matchRate = 89;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item == 0) {
//        return CGSizeMake(kScreenWidth, kWidth(40));
//    }
    CGFloat width = (kScreenWidth - 20 *2 - 40 *2)/3.;
    return CGSizeMake(width, kWidth(240));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSystemHelperHeaderCellIdentifier forIndexPath:indexPath];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:kWidth(30)];
    titleLabel.text = @"红娘今日配对";
    titleLabel.textColor = kColor(@"#333333");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.right.mas_equalTo(view);
            make.height.mas_equalTo(kWidth(30));
        }];
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kWidth(80.));
}

@end
