//
//  JYVisitMeController.m
//  JYFriend
//
//  Created by ylz on 2016/12/30.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYVisitMeController.h"
#import "JYPhotoCollectionViewCell.h"

static CGFloat const kLineSpace = 15.;
static CGFloat const kitemSpace = 8.;
static NSString *kVisitePhotoCellIdentifier = @"kvisite_photo_cell_identifier";

@interface JYVisitMeController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    UICollectionView *_layoutCollectionView;
}

@end

@implementation JYVisitMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"访问我的人";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kWidth(kLineSpace *2);
   layout.minimumInteritemSpacing = kWidth(kitemSpace *2);
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [_layoutCollectionView registerClass:[JYPhotoCollectionViewCell class] forCellWithReuseIdentifier:kVisitePhotoCellIdentifier];
    _layoutCollectionView.contentInset = UIEdgeInsetsMake(kWidth(30), kWidth(30), kWidth(10), kWidth(30));
    [self.view addSubview:_layoutCollectionView];
    {
    [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVisitePhotoCellIdentifier forIndexPath:indexPath];
    cell.imageUrl = @"http://a.hiphotos.baidu.com/zhidao/pic/item/d1160924ab18972b0c6e3752e0cd7b899f510ad5.jpg";
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kScreenWidth - kWidth(kLineSpace *2)*2 - kWidth(kitemSpace *2)*3) /4.;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


}

@end
