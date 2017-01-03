//
//  JYChangeUserInfoController.m
//  JYFriend
//
//  Created by ylz on 2017/1/3.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYChangeUserInfoController.h"

static NSString *const kUserInfosCellIdentifier = @"kuserinfo_cell_indetifier";

typedef NS_ENUM(NSInteger,JYUserInfoSection) {//section
    JYUserInfoSectionData,//资料
    JYUserInfoSectionContact,//联系方式
    JYUserInfoSectionSignature,//签名
    JYUserInfoSectionCount
};

typedef NS_ENUM(NSInteger,JYUserInfoDataRow) {
    JYUserInfoDataRowName,
    JYUserInfoDataRowBirthDay,
    JYUserInfoDataRowGender,
    JYUserInfoDataRowHeight,
    JYUserInfoDataRowHome,
    JYUserInfoDataRowCount
};

typedef NS_ENUM(NSInteger,JYUserInfoContactRow) {
    JYUserInfoContactRowWechat,
    JYUserInfoContactRowQQ,
    JYUserInfoContactRowPhone,
    JYUserInfoContactRowCount
};

@interface JYChangeUserInfoController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_layoutTableView;
}

@end

@implementation JYChangeUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    [_layoutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUserInfosCellIdentifier];
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


#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return JYUserInfoSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JYUserInfoSectionData) {
        return JYUserInfoDataRowCount;
    }else if (section == JYUserInfoSectionContact) {
        return JYUserInfoContactRowCount;
    }else if (section == JYUserInfoSectionSignature){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfosCellIdentifier forIndexPath:indexPath];
//    if () {
//        <#statements#>
//    }
    
    
    return cell;
}


@end
