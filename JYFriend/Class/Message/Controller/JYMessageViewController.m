//
//  JYMessageViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYMessageViewController.h"
#import "JYMessageCell.h"
#import "JYChatViewController.h"

static NSString *const kMessageCellReusableIdentifier = @"MessageCellReusableIdentifier";

@interface JYMessageViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableVC;
}
@end

@implementation JYMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableVC = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    [_tableVC registerClass:[JYMessageCell class] forCellReuseIdentifier:kMessageCellReusableIdentifier];
    [self.view addSubview:_tableVC];
    {
        [_tableVC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [_tableVC reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYMessageCell *message = [tableView dequeueReusableCellWithIdentifier:kMessageCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.row < 30) {
        @weakify(self);
        message.touchUserImgVAction = ^(id obj) {
            @strongify(self);
            //用户详情
        };
        message.userImgStr = @"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg";
        message.nickNameStr = @"渣渣";
        message.timeStr = @"1天前";
        message.latestMessage = @"你好，很高兴认识你";
    }
    return message;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(180);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        
    }];
    deleteAction.backgroundColor = kColor(@"#E55D51");

    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        
        
    }];
    editRowAction.backgroundColor = kColor(@"#DEDEDE");
    
    return @[deleteAction,editRowAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
