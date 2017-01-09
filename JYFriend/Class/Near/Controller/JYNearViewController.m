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
#import <CoreLocation/CoreLocation.h>
#import "JYNotFetchUserlocalView.h"
#import "JYDetailViewController.h"
#import "JYNearPesonModel.h"

static NSString *const kNearPersonCellIdentifier = @"knearpersoncell_identifier";
static NSString *const kSexTypeLocalCacheKey = @"kjysextype_local_cache_key";

@interface JYNearViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,CLLocationManagerDelegate>
{
    UITableView *_layoutTableView;
    
}

@property (nonatomic,retain) JYNearBottomView *bottomView;//批量打招呼
@property (nonatomic,retain) NSMutableArray  *allSelectCells;//所有选中的cell的indexPath
@property (nonatomic,retain) UIActionSheet *actionSheetView;
@property (nonatomic,retain) CLLocationManager  *locationManager;//定位
@property (nonatomic,retain) JYNotFetchUserlocalView *notLocalView;//没有登录时的view

@property (nonatomic) JYUserSex sexType;//性别筛选

@property (nonatomic,retain) JYNearPesonModel *personModel;
@property (nonatomic,retain) NSArray <JYNearPersonList *>*allPersons;
@property (nonatomic,retain) NSMutableArray *dataSource;

@end

@implementation JYNearViewController
QBDefineLazyPropertyInitialization(NSMutableArray, allSelectCells)
QBDefineLazyPropertyInitialization(CLLocationManager, locationManager)
QBDefineLazyPropertyInitialization(JYNearPesonModel, personModel)
QBDefineLazyPropertyInitialization(NSMutableArray, dataSource)
/**
 未获定位权限时的界面
 */
- (JYNotFetchUserlocalView *)notLocalView {
    if (_notLocalView) {
        return _notLocalView;
    }
    _notLocalView = [[JYNotFetchUserlocalView alloc] init];
    [self.view addSubview:_notLocalView];
    {
    [_notLocalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    }
    
    _notLocalView.settingAction = ^(id sender){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    };
    
    return _notLocalView;
}
/**
 批量打招呼
 */
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
    self.title = @"附近的人";
    self.sexType = [[[NSUserDefaults standardUserDefaults] objectForKey:kSexTypeLocalCacheKey] integerValue] != 0 ? : JYUserSexALL;
    BOOL locationEnable = [CLLocationManager locationServicesEnabled];
    int locationStatus = [CLLocationManager authorizationStatus];
    self.locationManager.delegate  = self;
    [self.locationManager startUpdatingLocation];
    if (!locationEnable || (locationStatus != kCLAuthorizationStatusAuthorizedAlways && locationStatus != kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self requestLocationAuthority];
    }
    if(locationEnable && (locationStatus == kCLAuthorizationStatusAuthorizedAlways || locationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)){
        
        [self creartTableViewAndRightBarButtonItem];
        
    }
    if (locationEnable && locationStatus == kCLAuthorizationStatusDenied) {
        
        self.notLocalView.backgroundColor = self.view.backgroundColor;
        
    }
}

/**
 创建tableView
 */
- (void)creartTableViewAndRightBarButtonItem {
    
    if (_notLocalView) {
       _notLocalView.hidden = YES;
        [_notLocalView removeFromSuperview];
    }
    
    if (_layoutTableView) {
        return ;
    }
    @weakify(self);
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[[UIImage imageNamed:@"near_ filtrate_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        if (self ->_layoutTableView.editing) {
            [self tableViewEditing];
        }else {
            [self.actionSheetView showFromTabBar:self.tabBarController.tabBar];
        }
        
    }];
    
    [_layoutTableView JY_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadModels];
    }];
    
}
/**
 加载全部模型
 */
- (void)loadModels {
    @weakify(self);
    [self.personModel fetchNearPersonModelWithPage:0 pageSize:10 completeHandler:^(BOOL success, JYNearPerson *nearPersons) {
        @strongify(self);
        [self->_layoutTableView JY_endPullToRefresh];
        self.allPersons = nearPersons.programList;
       NSArray *arr = [self fetchPersonListWith:self.sexType];
//        QBLog(@"%@",arr)
 
    }];
}
/**
 模拟上拉加载
 */
- (void)pageLoadModelWithPersonSex:(JYUserSex)sex {
    if (!self.allPersons.count) {
        return;
    }
    
}

/**
 根据性别把所有附近的人进行筛选
 */

- (NSArray <JYNearPersonList *>*)fetchPersonListWith:(JYUserSex)sex {
    NSString *gender = nil;
    switch (sex) {
        case 1:
            gender = @"M";
            break;
        case 2:
            gender = @"F";
            break;
        case 3:
            gender = @"ALL";
            break;
            
        default:
            break;
    }
    if (sex == JYUserSexALL) {
        return self.allPersons;
    }
   return  [self.allPersons bk_select:^BOOL(JYNearPersonList *obj) {
        if ([obj.sex isEqualToString:gender]) {
            return YES;
        }
      return NO;
    }];

}



/**
 请求定位权限
 */
- (void)requestLocationAuthority {
    
//    if (!locationEnable ||  locationStatus == kCLAuthorizationStatusNotDetermined) {
        if ([UIDevice currentDevice].systemVersion.floatValue >=8) {
//            _locationManager = [[CLLocationManager alloc] init];
//            _locationManager.delegate = self;
            //获取授权认证
//            [locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
            
//        }
    }

}
/**
 tableView的编辑模式
 */
- (void)tableViewEditing{
    
    [self.allSelectCells removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.hidden = YES;
        
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
    
    JYDetailViewController *detailVC = [[JYDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.allSelectCells containsObject:indexPath]) [self.allSelectCells removeObject:indexPath];
    self.bottomView.personNumber = self.allSelectCells.count;
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            self.sexType = JYUserSexFemale;
            break;
        case 1:
            self.sexType = JYUserSexMale;
            break;
        case 2:
            self.sexType = JYUserSexALL;
            break;
        case 3:
             [self tableViewEditing];
            break;
        default:
            break;
    }
    if (buttonIndex <3) {//保存筛选性别
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.sexType] forKey:kSexTypeLocalCacheKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self creartTableViewAndRightBarButtonItem];
    }else if (status == kCLAuthorizationStatusDenied){
        self.notLocalView.backgroundColor = self.view.backgroundColor;
    }

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        QBLog(@"%@",placemarks.lastObject.name);
    }];
    
    [manager stopUpdatingLocation];

}




@end
