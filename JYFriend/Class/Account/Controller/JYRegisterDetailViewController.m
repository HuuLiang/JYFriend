//
//  JYRegisterDetailViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/21.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYRegisterDetailViewController.h"
#import "JYTableHeaderFooterView.h"
#import "JYSetAvatarView.h"
#import "JYNextButton.h"
#import "JYRegisterDetailCell.h"


typedef NS_ENUM(NSUInteger, JYRegisterDetailRow) {
    JYRegisterDetailSexRow, //开通VIP
    JYRegisterDetailBirthRow, //红娘助手
    JYRegisterDetailTallRow, //访问我的人
    JYRegisterDetailHomeRow, //家乡
    JYRegisterDetailCount
};

static NSString *const kDetailCellReusableIdentifier = @"DetailCellReusableIdentifier";

@interface JYRegisterDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *_tableView;
    JYSetAvatarView *_setAvatarView;
    JYNextButton    *_nextButton;
}
@end

@implementation JYRegisterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = MAX(kScreenHeight*0.09, 44);
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerClass:[JYRegisterDetailCell class] forCellReuseIdentifier:kDetailCellReusableIdentifier];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }

    _setAvatarView = [[JYSetAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(400))];
    _setAvatarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.66];
    _tableView.tableHeaderView = _setAvatarView;
    
    @weakify(self);
    _nextButton = [[JYNextButton alloc] initWithTitle:@"下一步" action:^{
        @strongify(self);
        NSLog(@"下一步");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return JYRegisterDetailCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYRegisterDetailCell *cell;

    if (indexPath.row < JYRegisterDetailCount) {
        cell = [tableView dequeueReusableCellWithIdentifier:kDetailCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYRegisterDetailSexRow) {
            cell.title = @"性别";
        } else if(indexPath.row == JYRegisterDetailBirthRow){
            cell.title = @"生日";
        } else if (indexPath.row == JYRegisterDetailTallRow) {
            cell.title = @"身高";
        } else if (indexPath.row == JYRegisterDetailHomeRow) {
            cell.title = @"家乡";
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(96);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kWidth(50), 0, kWidth(50))];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, kWidth(50), 0, kWidth(50))];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == JYRegisterDetailSexRow) {
        
    } else if (indexPath.row == JYRegisterDetailBirthRow) {
        
    } else if (indexPath.row == JYRegisterDetailTallRow) {
        
    } else if (indexPath.row == JYRegisterDetailHomeRow) {
        
    }
}


@end
