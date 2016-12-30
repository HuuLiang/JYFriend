//
//  JYMyPhotoBigImageView.h
//  JYFriend
//
//  Created by ylz on 2016/12/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^JYSelectionAction)(NSInteger index, id obj);

@interface JYMyPhotoBigImageView : UIView

@property (nonatomic,retain) NSArray *imageURLStrings;
@property (nonatomic) BOOL shouldAutoScroll;
@property (nonatomic) BOOL shouldInfiniteScroll;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) CGFloat pageControlYAspect;
@property (nonatomic,retain) NSArray <UIImage *>*images;

- (instancetype)initWithImageGroup:(NSArray *)imageGroup frame:(CGRect)frame;
@property (nonatomic,copy) QBAction action;

@end