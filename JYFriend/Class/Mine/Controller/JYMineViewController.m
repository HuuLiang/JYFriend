//
//  JYMineViewController.m
//  JYFriend
//
//  Created by Liang on 2016/11/28.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMineViewController.h"
#import "JYTableHeaderFooterView.h"
#import "JYMineCell.h"
#import "JYMineAvatarView.h"
#import "JYDredgeVipViewController.h"
#import "JYMyPhotosController.h"
#import "JYVisitMeController.h"
#import "JYDetailVideoViewController.h"

typedef NS_ENUM(NSUInteger, JYMineSection) {
    JYMineFunctinSection,//功能分组
    JYMineDetailSection, //资料分组
    JYMineEditSection, //编辑分组
    JYMineSectionCount
};

typedef NS_ENUM(NSUInteger, JYMineFunctionRow) {
    JYMineFunctionVipRow, //开通VIP
    JYMineFunctionRobotRow, //红娘助手
    JYMineFunctionGuestRow, //访问我的人
    JYMineFunctionRowCount
};

typedef NS_ENUM(NSUInteger, JYMineDetailRow) {
    JYMineDetailAlbumRow, //相册
    JYMineDetailVideoRow, //视频认证
    JYMineDetailRowCount
};

typedef NS_ENUM(NSUInteger, JYMineEditRow) {
    JYMineEditUpdateRow, //资料修改
    JYMineEditRowCount
};

static NSString *const kMineCellReusableIdentifier = @"MineCellReusableIdentifier";
static NSString *const kHeaderViewReusableIdentifier = @"HeaderViewReusableIdentifier";


@interface JYMineViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *   _tableView;
    JYMineAvatarView *_avtarView;
}
@end

@implementation JYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = MAX(kScreenHeight*0.09, 44);
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView registerClass:[JYMineCell class] forCellReuseIdentifier:kMineCellReusableIdentifier];
    [_tableView registerClass:[JYTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderViewReusableIdentifier];
    [self.view addSubview:_tableView];
    {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    _avtarView = [[JYMineAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(150))];
    _avtarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.66];
    _tableView.tableHeaderView = _avtarView;
}

- (BOOL)alwaysHideNavigationBar {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return JYMineSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JYMineFunctinSection){
        return JYMineFunctionRowCount;
    }else if (section == JYMineDetailSection) {
        return JYMineDetailRowCount;
    } else if (section == JYMineEditSection) {
        return JYMineEditRowCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYMineCell *cell;
    if (indexPath.section == JYMineFunctinSection || indexPath.section == JYMineDetailSection || indexPath.section == JYMineEditSection) {
        cell = [tableView dequeueReusableCellWithIdentifier:kMineCellReusableIdentifier forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.section == JYMineFunctinSection) {
            if (indexPath.row == JYMineFunctionVipRow) {
                cell.iconImage = [UIImage imageNamed:@""];
                cell.title = @"开通VIP";
            } else if(indexPath.row == JYMineFunctionRobotRow){
                cell.iconImage = [UIImage imageNamed:@""];
                cell.title = @"红娘助手";
            } else if (indexPath.row == JYMineFunctionGuestRow) {
                cell.iconImage = [UIImage imageNamed:@""];
                cell.title = @"访问我的人";
            }
        } else if (indexPath.section == JYMineDetailSection) {
            if (indexPath.row == JYMineDetailAlbumRow) {
                cell.iconImage = [UIImage imageNamed:@""];
                cell.title = @"我的相册";
            } else if (indexPath.row == JYMineDetailVideoRow) {
                cell.iconImage = [UIImage imageNamed:@""];
                cell.title = @"视频认证";
            }
        } else if (indexPath.section == JYMineEditSection) {
            if (indexPath.row == JYMineEditUpdateRow)  {
                cell.iconImage = [UIImage imageNamed:@""];
                cell.title = @"修改资料";
            }
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JYTableHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderViewReusableIdentifier];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == JYMineFunctinSection) {
        return 0;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == JYMineFunctinSection) {
        if (indexPath.row == JYMineFunctionVipRow) {
            JYDredgeVipViewController *vipVC  = [[JYDredgeVipViewController alloc] init];
            [self.navigationController pushViewController:vipVC animated:YES];
            
        } else if (indexPath.row == JYMineFunctionRobotRow) {
            
        } else if (indexPath.row == JYMineFunctionGuestRow) {
            JYVisitMeController *visitVC = [[JYVisitMeController alloc] init];
            [self.navigationController pushViewController:visitVC animated:YES];
            
        }
    } else if (indexPath.section == JYMineDetailSection) {
        if (indexPath.row == JYMineDetailAlbumRow)  {
            JYMyPhotosController *photoVC = [[JYMyPhotosController alloc] init];
            [self.navigationController pushViewController:photoVC animated:YES];
            
        } else if (indexPath.row == JYMineDetailVideoRow) {
            JYDetailVideoViewController *detailVC = [[JYDetailVideoViewController alloc] init];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
    } else if (indexPath.section == JYMineEditSection) {
        if (indexPath.row == JYMineEditUpdateRow) {
            
        }
    }
}
@end
