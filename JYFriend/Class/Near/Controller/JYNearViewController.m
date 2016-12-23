//
//  JYNearViewController.m
//  JYFriend
//
//  Created by Liang on 2016/12/22.
//  Copyright © 2016年 Liang. All rights reserved.
//

#import "JYNearViewController.h"
#import "JYNearPersonCell.h"

static NSString *const kNearPersonCellIdentifier = @"knearpersoncell_identifier";

@interface JYNearViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTableView;
}

@end

@implementation JYNearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"near_ filtrate_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
//        [self->_layoutTableView setEditing:!self ->_layoutTableView.editing animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            
          [self->_layoutTableView setEditing:!self ->_layoutTableView.editing animated:NO];
            
            if (self->_layoutTableView.editing) {
                    self-> _layoutTableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
                
            }else {
               self-> _layoutTableView.separatorInset = UIEdgeInsetsMake(0, kWidth(30), 0, 0);
            }
        }];
    }];
    
    _layoutTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _layoutTableView.backgroundColor = self.view.backgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.allowsMultipleSelectionDuringEditing = YES;

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

    return cell;
}



@end
