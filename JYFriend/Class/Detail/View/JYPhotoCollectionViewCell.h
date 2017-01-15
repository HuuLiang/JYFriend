//
//  JYPhotoCollectionViewCell.h
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSString *imageUrl;
@property (nonatomic,assign)BOOL isVideoImage;
@property (nonatomic) BOOL isFirstPhoto;

@end
