//
//  JYDetailPhtoCell.m
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDetailPhtoCell.h"
#import "JYPhotoCollectionViewCell.h"

static CGFloat const kLineSpace = 10.;
static CGFloat const kItemSpce = 6.;
static NSString *const kPhotoCollectionCellIdentifier = @"kphonotcollectioncellidentifier";

@interface JYDetailPhtoCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_layoutCollectionView;
}

@end

@implementation JYDetailPhtoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kWidth(kLineSpace *2);
        layout.minimumInteritemSpacing = kWidth(kItemSpce *2);
        _layoutCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _layoutCollectionView.backgroundColor = self.backgroundColor;
        _layoutCollectionView.delegate = self;
        _layoutCollectionView.dataSource = self;
        [_layoutCollectionView registerClass:[JYPhotoCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCollectionCellIdentifier];
        [self addSubview:_layoutCollectionView];
        {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        }
        _layoutCollectionView.contentInset = UIEdgeInsetsMake(kWidth(20.), kWidth(30.), kWidth(10.), kWidth(30.));
        
    }
    return self;
}

#pragma mark UICollectionViewDelegate UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 6;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kScreenWidth - kItemSpce *2 - 30)/3;
    return CGSizeMake(width, width);
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionCellIdentifier forIndexPath:indexPath];
    cell.imageUrl = @"http://f.hiphotos.baidu.com/image/pic/item/b151f8198618367a9f738e022a738bd4b21ce573.jpg";
    
    return cell;
}


@end
