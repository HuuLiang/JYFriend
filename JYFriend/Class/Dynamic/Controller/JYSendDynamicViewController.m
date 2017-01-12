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

static NSString *const kSendDynamicTableViewCellIdentifier = @"senddynamic_tableviewcell_identifier";

typedef NS_ENUM(NSUInteger , JYDynamicSectionType) {
    JYDynamicSectionTypeMessage,
    JYDynamicSectionTypeCount
};

@interface JYSendDynamicViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_layoutTableView;
}

@end

@implementation JYSendDynamicViewController



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
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return JYDynamicSectionTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == JYDynamicSectionTypeMessage) {
        
        JYSendDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSendDynamicTableViewCellIdentifier forIndexPath:indexPath];
        cell.curentVC = self;
        cell.tabBar = self.tabBarController.tabBar;
        
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



//#pragma mark JYLocalPhotoUtilsDelegate 相机相册访问
//
//- (void)JYLocalPhotoUtilsWithPicker:(UIImagePickerController *)picker DidFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    [JYUsrImageCache writeToFileWithImage:info[UIImagePickerControllerOriginalImage]];
//    @weakify(self);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        @strongify(self);
//        if (self.dataSource.count != [JYUsrImageCache fetchAllImages].count) {
//            
//            [self.dataSource addObject:[JYUsrImageCache fetchAllImages].lastObject];
//            [self->_layoutCollectionView reloadData];
//            [self->_layoutCollectionView JY_triggerPullToRefresh];
//        }
//    });
//    
//}

@end
