//
//  JYNearViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNearViewController.h"
#import "JYNearPersonCell.h"
#import "JYNearBottomView.h"

static NSString *const kNearPersonCellIdentifier = @"knearpersoncell_identifier";

@interface JYNearViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    UITableView *_layoutTableView;
}

@property (nonatomic,retain) JYNearBottomView *bottomView;
@property (nonatomic,retain) NSMutableArray  *allSelectCells;
@property (nonatomic,retain) UIActionSheet *actionSheetView;

@end

@implementation JYNearViewController
QBDefineLazyPropertyInitialization(NSMutableArray, allSelectCells)

- (JYNearBottomView *)bottomView {

    if (_bottomView) {
        return _bottomView;
    }
    _bottomView = [[JYNearBottomView alloc] init];
    @weakify(self);
    _bottomView.action = ^(id sender) {
        @strongify(self);
        [self tableViewEditing];
    };
    [self.view addSubview:_bottomView];
    {
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kWidth(88.));
    }];
    }
    
    return _bottomView;
}

- (UIActionSheet *)actionSheetView {
    if (_actionSheetView) {
        return _actionSheetView;
    }
    _actionSheetView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"只看女生" otherButtonTitles:@"只看男生",@"查看全部",@"批量打招呼", nil];

    return _actionSheetView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"near_ filtrate_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        if (self ->_layoutTableView.editing) {
             [self tableViewEditing];
        }else {
            [self.actionSheetView showFromTabBar:self.tabBarController.tabBar];
        }

    }];
    
    _layoutTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.allowsMultipleSelectionDuringEditing = YES;
    _layoutTableView.tintColor = [UIColor colorWithHexString:@"#e147a5"];
    
    _layoutTableView.separatorInset = UIEdgeInsetsMake(0, kWidth(30), 0, 0);
    _layoutTableView.rowHeight = kWidth(180);
    [_layoutTableView registerClass:[JYNearPersonCell class] forCellReuseIdentifier:kNearPersonCellIdentifier];
    [self.view  addSubview:_layoutTableView];
    {
    [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
    }];
    }
    
}

- (void)tableViewEditing{
    
    [self.allSelectCells removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
//        if (isBtnClick) {
            self.bottomView.hidden = YES;
//        }
        
        [self->_layoutTableView setEditing:!self ->_layoutTableView.editing animated:NO];
        
        if (self->_layoutTableView.editing) {
            self-> _layoutTableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
            
        }else {
            self-> _layoutTableView.separatorInset = UIEdgeInsetsMake(0, kWidth(30), 0, 0);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UITableViewDelegate UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYNearPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kNearPersonCellIdentifier forIndexPath:indexPath];
    cell.headerImageUrl = @"http://v1.qzone.cc/avatar/201406/29/18/15/53afe73912959815.jpg%21200x200.jpg";

    cell.age = @"23";
    if (indexPath.row %3 == 0) {
        cell.name = @"新手上路";
        cell.gender = 0;
        cell.distance = 456;
        cell.height = 177;
        cell.vip = NO;
        cell.detaiTitle = @"风流妹逗老司机";
    }else {
        cell.name = @"高冷小仙女";
        cell.gender = 1;
        cell.distance = 1234;
        cell.height = 165;
        cell.vip = YES;
        cell.detaiTitle = @"有句话叫,没有高冷的人,只是她暖的不是你";
    }
//    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
//    
//    view.backgroundColor = [UIColor whiteColor];
////    view.alpha = 0;
//    
//    cell.multipleSelectionBackgroundView = view;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

 return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing) {
        
        if (![self.allSelectCells containsObject:indexPath]) [self.allSelectCells addObject:indexPath];
        self.bottomView.hidden = NO;
        self.bottomView.personNumber = self.allSelectCells.count;
        
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.allSelectCells containsObject:indexPath]) [self.allSelectCells removeObject:indexPath];
    self.bottomView.personNumber = self.allSelectCells.count;
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 3) {
        [self tableViewEditing];
    }
    
}


@end
