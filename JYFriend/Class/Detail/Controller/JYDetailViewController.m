//
//  JYDetailViewController.m
//  JYFriend
//
//  Created by ylz on 2016/12/26.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYDetailViewController.h"
#import "JYDetailPhtoCell.h"

static NSString *const kDetailPhotCellIdentifier = @"detailPhotoCell_Identifier";

typedef NS_ENUM(NSInteger,JYSectionType) {
    JYSectionTypePhoto,
    JYSectionTypeHomeTown,
//    JYSectionTypeDynamic,
//    JYSectionTypeInfo,
//    JYSectionTypeSectetInfo,
//    JYSectionTypeVideo,
    JYSectionCount
};

@interface JYDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}

@end

@implementation JYDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    [_layoutTableView registerClass:[JYDetailPhtoCell class] forCellReuseIdentifier:kDetailPhotCellIdentifier];
    [_layoutTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_layoutTableView];
    {
    [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return JYSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYSectionTypePhoto) {
        JYDetailPhtoCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailPhotCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYSectionTypePhoto) {
        return kScreenWidth *0.67;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kWidth(20.);
}

@end
