//
//  JYSendDynamicViewController.m
//  JYFriend
//
//  Created by ylz on 2017/1/12.
//  Copyright © 2017年 Liang. All rights reserved.
//

#import "JYSendDynamicViewController.h"
#import "JYSendDynamicTableViewCell.h"
#import "JYLocalPhotoUtils.h"
#import "JYUsrImageCache.h"
#import "JYDynamicCacheUtil.h"

static NSString *const kSendDynamicTableViewCellIdentifier = @"senddynamic_tableviewcell_identifier";

typedef NS_ENUM(NSUInteger , JYDynamicSectionType) {
    JYDynamicSectionTypeMessage,
    JYDynamicSectionTypeCount
};

@interface JYSendDynamicViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_layoutTableView;
    JYSendDynamicTableViewCell *_sendDynamicCell;
}

@property (nonatomic,retain) NSMutableArray *dataSource;//图片或者视频
@end

@implementation JYSendDynamicViewController
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"发动态";
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发布" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [JYDynamicCacheUtil saveUserDynamicWithUserState:self->_sendDynamicCell.textView.text imageUrls:self.dataSource];
        
    }];

    _layoutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.tableFooterView = [UIView new];
    _layoutTableView.estimatedRowHeight = 250.;
    [_layoutTableView registerClass:[JYSendDynamicTableViewCell class] forCellReuseIdentifier:kSendDynamicTableViewCellIdentifier];
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

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return JYDynamicSectionTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == JYDynamicSectionTypeMessage) {
        
        JYSendDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSendDynamicTableViewCellIdentifier forIndexPath:indexPath];
        _sendDynamicCell = cell;
        cell.curentVC = self;
        cell.tabBar = self.tabBarController.tabBar;
        cell.collectAction = ^(UIImage *image){
            [self.dataSource addObject:image];
        
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == JYDynamicSectionTypeMessage) {
        return 250.;
    }
    return 0;
}


@end
