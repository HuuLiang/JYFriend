//
//  JYPaymentViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/15.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYPaymentViewController.h"
#import "JYPayHeaderCell.h"
#import "JYPayNewDynamicCell.h"
#import "JYPayPointCell.h"
#import "JYPayTypeCell.h"

static NSString *const kPayNewDynamicCellIdentifier = @"jy_new_dynamic_cell_identifier";
static NSString *const kPayHeaderCellIdentifier = @"jy_pay_header_cell_indetifier";
static NSString *const kPayPointCellIdentifier = @"jy_pay_point_cell_identifier";
static NSString *const kPayTypeCellIdentifier = @"jy_pay_type_cell_identifier";

typedef NS_ENUM(NSUInteger , JYPayCellSection) {
    JYPayCellSectionNewDynamicCell,//最新动态
    JYPayCellSectionTitleCell,//标题
    JYPayCellSectionPayPointCell,//计费点
    JYPayCellSectionPayTypeCell,//支付方式
    JYPayCellSectionCount
};

typedef NS_ENUM(NSUInteger , JYPayPointRow) {
    JYPayPointRowYear,
    JYPayPointRowQuarter,
    JYPayPointRowMonth,
    JYPayPointRowCount
};

typedef NS_ENUM(NSUInteger , JYPayTypeRow) {
    JYPayTypeRowWechat,
    JYPayTypeRowAlipay,
    JYPayTypeRowCount
};

@interface JYPaymentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
}

@end

@implementation JYPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    [_layoutTableView registerClass:[JYPayHeaderCell class] forCellReuseIdentifier:kPayHeaderCellIdentifier];
    [_layoutTableView registerClass:[JYPayNewDynamicCell class] forCellReuseIdentifier:kPayNewDynamicCellIdentifier];
    [_layoutTableView registerClass:[JYPayPointCell class] forCellReuseIdentifier:kPayPointCellIdentifier];
    [_layoutTableView registerClass:[JYPayTypeCell class] forCellReuseIdentifier:kPayTypeCellIdentifier];
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
}


#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return JYPayCellSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JYPayCellSectionPayPointCell) {
        return JYPayPointRowCount;
    }else if (section == JYPayCellSectionPayTypeCell){
        return JYPayTypeRowCount;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYPayCellSectionNewDynamicCell) {
        JYPayNewDynamicCell *newDynamicCell = [tableView dequeueReusableCellWithIdentifier:kPayNewDynamicCellIdentifier forIndexPath:indexPath];
        return newDynamicCell;
    } else if (indexPath.section == JYPayCellSectionTitleCell) {
        JYPayHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayHeaderCellIdentifier forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == JYPayCellSectionPayPointCell){
        JYPayPointCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayPointCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYPayPointRowYear) {
            cell.vipLevel = JYVipTypeYear;
            cell.isSelected = YES;
        }else if (indexPath.row == JYVipTypeQuarter){
            cell.vipLevel = JYVipTypeQuarter;
            cell.isSelected = NO;
        }else if (indexPath.row == JYVipTypeMonth){
            cell.vipLevel = JYVipTypeMonth;
            cell.isSelected = NO;
        }
        return cell;
    
    } else if (indexPath.section == JYPayCellSectionPayTypeCell){
        JYPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayTypeCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYPayTypeRowWechat) {
            cell.orderPayType = QBOrderPayTypeWeChatPay;
        }else if (indexPath.row == JYPayTypeRowAlipay){
            cell.orderPayType = QBOrderPayTypeAlipay;
        }
        
        cell.payAction = ^(void){
        
        
        };
        
        return cell;
    }
    return nil;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JYPayCellSectionNewDynamicCell) {
        return kWidth(110);
    }else if (indexPath.section == JYPayCellSectionTitleCell){
        return kWidth(170);
    }else if (indexPath.section == JYPayCellSectionPayPointCell){
    
        return kWidth(200);
    }else if (indexPath.section == JYPayCellSectionPayTypeCell){
        return kWidth(130);
    }

    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == JYPayCellSectionPayPointCell) {

        for (int i = 0; i < [_layoutTableView numberOfRowsInSection:JYPayCellSectionPayPointCell]; i++) {
           JYPayPointCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:JYPayCellSectionPayPointCell]];
            cell.isSelected = NO;
        }
        JYPayPointCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = YES;

    }
}


@end
