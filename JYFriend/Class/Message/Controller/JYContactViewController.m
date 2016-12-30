//
//  JYContactViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYContactViewController.h"
#import "JYContactCell.h"
#import "JYMessageViewController.h"
#import "JYContactModel.h"
#import "JYDetailViewController.h"
#import "JYMessageModel.h"

typedef NS_ENUM(NSUInteger, JYUserState) {
    JYUserStick = 0,//置顶用户
    JYUserNormal, //非置顶用户
    JYUserStateSection
};

static NSString *const kContactCellReusableIdentifier = @"ContactCellReusableIdentifier";

@interface JYContactViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableVC;
}
@property (nonatomic) NSMutableArray <JYContactModel *>*normalContacts;
@property (nonatomic) NSMutableArray <JYContactModel *>*stickContacts;
@end

@implementation JYContactViewController
QBDefineLazyPropertyInitialization(NSMutableArray, stickContacts)
QBDefineLazyPropertyInitialization(NSMutableArray, normalContacts)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableVC = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableVC.backgroundColor = kColor(@"#efefef");
    _tableVC.delegate = self;
    _tableVC.dataSource = self;
    [_tableVC registerClass:[JYContactCell class] forCellReuseIdentifier:kContactCellReusableIdentifier];
    [self.view addSubview:_tableVC];
    _tableVC.tableFooterView = [[UIView alloc] init];
    {
        [_tableVC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [_tableVC reloadData];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"增加数据" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        for (NSInteger i = 0; i < 20; i++) {
            JYContactModel *model = [[JYContactModel alloc] init];
            model.userId = [NSString stringWithFormat:@"%ld",i];
            model.logoUrl = @"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg";
            model.nickName = [NSString stringWithFormat:@"渣渣%ld",i];
            model.userType = JYContactUserTypeNormal;
            model.recentTime = [NSString stringWithFormat:@"%0ld",i];
            model.recentMessage = @"你好，很高兴认识你";
            [model saveOrUpdate];
        }
        [_tableVC reloadData];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"清空数据" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [JYContactModel deleteAllContacts];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isMovingToParentViewController) {
        //需要重新刷新UI
        [self reloadContactsWithUIReload:YES];
    }
}

- (void)reloadContactsWithUIReload:(BOOL)reloadUI {
    NSArray *allContacts = [JYContactModel allContacts];
    [self.stickContacts removeAllObjects];
    [self.normalContacts removeAllObjects];
    
    __block NSUInteger unreadMessages = 0;
    [allContacts enumerateObjectsUsingBlock:^(JYContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isStick) {
            [self.stickContacts addObject:obj];
        } else {
            [self.normalContacts addObject:obj];
        }
        unreadMessages += obj.unreadMessages;
    }];

    if (![self.navigationController.tabBarItem.badgeValue isEqualToString:[NSString stringWithFormat:@"%ld",unreadMessages]]) {
        reloadUI = YES;
    }
    
    if (unreadMessages > 0) {
        if (unreadMessages < 100) {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadMessages];
        } else {
            self.navigationController.tabBarItem.badgeValue = @"99+";
        }
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
    if (reloadUI) {
        [_tableVC reloadData];
    }
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return JYUserStateSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JYUserStick) {
        return self.stickContacts.count;
    } else if (section == JYUserNormal) {
        return self.normalContacts.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    JYContactCell *contactCell = [tableView dequeueReusableCellWithIdentifier:kContactCellReusableIdentifier forIndexPath:indexPath];
    if (indexPath.section < JYUserStateSection) {
        JYContactModel *contact;
        if (indexPath.section == JYUserStick) {
            if (indexPath.row < self.stickContacts.count) {
                contact = self.stickContacts[indexPath.row];
            }
        } else if (indexPath.section == JYUserNormal) {
            if (indexPath.row < self.normalContacts.count) {
                contact = self.normalContacts[indexPath.row];
            }
        }
        
        if (contact) {
            contactCell.touchUserImgVAction = ^(id obj) {
                @strongify(self);
                //用户详情
                JYDetailViewController *detailVC = [[JYDetailViewController alloc] init];
                [self.navigationController pushViewController:detailVC animated:YES];
            };
            contactCell.userImgStr = contact.logoUrl;
            contactCell.nickNameStr = contact.nickName;
            contactCell.recentTimeStr = contact.recentTime;
            contactCell.recentMessage = contact.recentMessage;
            contactCell.isStick = contact.isStick;
        }
    }
    return contactCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWidth(140);
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    JYContactModel *contact;
    if (indexPath.section == JYUserStick) {
        contact = self.stickContacts[indexPath.row];
    } else if (indexPath.section == JYUserNormal) {
        contact = self.normalContacts[indexPath.row];
    }
    if (contact) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@" 删除 " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            //dataSource 中删除
            if (indexPath.section == JYUserStick) {
                [self.stickContacts removeObject:contact];
            } else if (indexPath.section == JYUserNormal) {
                [self.normalContacts removeObject:contact];
            }
            //删除 动画
            [self->_tableVC beginUpdates];
            [self->_tableVC deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self->_tableVC endUpdates];
            //数据库中删除
            [JYContactModel deleteObjects:@[contact]];

        }];
        deleteAction.backgroundColor = kColor(@"#E55D51");
        
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:contact.isStick ? @"取消置顶" :@" 置顶 " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self->_tableVC setEditing:NO];
            NSIndexPath *newIndexPath;
            if (contact.isStick) {
                //从置顶移动到普通 取消置顶
                [self.stickContacts removeObject:contact];
                contact.isStick = !contact.isStick;
                [self.normalContacts insertObject:contact atIndex:0];
                newIndexPath = [NSIndexPath indexPathForRow:0 inSection:JYUserNormal];

                [self->_tableVC beginUpdates];
                [self->_tableVC deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self->_tableVC insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self->_tableVC endUpdates];
            } else {
                //从普通移动到置顶 设置为置顶
                [self.normalContacts removeObject:contact];
                contact.isStick = !contact.isStick;
                [self.stickContacts insertObject:contact atIndex:0];
                newIndexPath = [NSIndexPath indexPathForRow:0 inSection:JYUserStick];
                
                [self->_tableVC beginUpdates];
                [self->_tableVC deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self->_tableVC insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self->_tableVC endUpdates];
            }
            JYContactCell *cell = (JYContactCell *)[self->_tableVC cellForRowAtIndexPath:newIndexPath];
            cell.isStick = contact.isStick;
            [contact saveOrUpdate];
        }];
        editRowAction.backgroundColor = kColor(@"#DEDEDE");
        
        return @[deleteAction,editRowAction];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [JYUser currentUser].userId = @"93867";
    [JYUser currentUser].nickName = @"我";
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/d1160924ab18972baba3547fe6cd7b899f510aed.jpg"]
                                                    options:SDWebImageAvoidAutoSetImage
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      NSData *data;
                                                      if (UIImagePNGRepresentation(image) == nil) {
                                                          data = UIImageJPEGRepresentation(image, 1);
                                                      } else {
                                                          data = UIImagePNGRepresentation(image);
                                                      }
                                                      [JYUser currentUser].userImg = data;
    }];
    [[JYUser currentUser] saveOrUpdate];
    
    JYUser *user = [[JYUser alloc] init];
    user.userId = @"93866";
    user.nickName = @"渣渣";
    user.userImg = [JYUser currentUser].userImg;
    [user saveOrUpdate];
    
    JYMessageModel *message = [[JYMessageModel alloc] init];

//    message.messageId = @"11";
    message.messageType = JYMessageTypeText;
    message.messageContent = @"你好，很高兴认识你";
    message.sendUserId = [JYUser currentUser].userId;
    message.receiveUserId = user.userId;
    message.messageTime = @"19930218122211";
    [message saveOrUpdate];
    
//    message.messageId = @"22";
//    message.sendUserId = user.userId;
//    message.receiveUserId = [JYUser currentUser].userId;;
//    [message saveOrUpdate];
    
    [JYMessageViewController showMessageWithUser:user inViewController:self];
}

@end
