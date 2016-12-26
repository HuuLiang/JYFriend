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
#import "ActionSheetPicker.h"
#import "VPImageCropperViewController.h"

typedef NS_ENUM(NSUInteger, JYRegisterDetailRow) {
    JYRegisterDetailSexRow, //开通VIP
    JYRegisterDetailBirthRow, //红娘助手
    JYRegisterDetailTallRow, //访问我的人
    JYRegisterDetailHomeRow, //家乡
    JYRegisterDetailCount
};

static NSString *const kDetailCellReusableIdentifier = @"DetailCellReusableIdentifier";

@interface JYRegisterDetailViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ActionSheetMultipleStringPickerDelegate,UIActionSheetDelegate,VPImageCropperDelegate>
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
    
    @weakify(self);
    _setAvatarView = [[JYSetAvatarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(400)) action:^{
        @strongify(self);
        //图片获取
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片获取方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册",@"选择相机", nil];
        [actionSheet showInView:self.view];
    }];
    
    _tableView.tableHeaderView = _setAvatarView;
    
    _nextButton = [[JYNextButton alloc] initWithTitle:@"下一步" action:^{
        @strongify(self);
        NSLog(@"下一步");
        [[JYUser currentUser] saveOrUpdate];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getImageWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        if ([JYUtil isIpad]) {
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
            [popover presentPopoverFromRect:CGRectMake(0, 0, kScreenWidth, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else {
        NSString *sourceTypeTitle = sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? @"相册":@"相机";
        [[JYHudManager manager] showHudWithTitle:sourceTypeTitle message:[NSString stringWithFormat:@"请在设备的\"设置-隐私-%@\"中允许访问%@",sourceTypeTitle,sourceTypeTitle]];
    }
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
    @weakify(self);
    if (indexPath.row < JYRegisterDetailCount) {
        cell = [tableView dequeueReusableCellWithIdentifier:kDetailCellReusableIdentifier forIndexPath:indexPath];
        if (indexPath.row == JYRegisterDetailSexRow) {
            cell.cellType = JYDetailCellTypeSelect;
            cell.title = @"性别";
            cell.sexSelected = ^(NSNumber *userSex) {
//                @strongify(self);
                [JYUser currentUser].userSex = [userSex unsignedIntegerValue];
            };
        } else if(indexPath.row == JYRegisterDetailBirthRow){
            cell.cellType = JYDetailCellTypeContent;
            cell.title = @"生日";
        } else if (indexPath.row == JYRegisterDetailTallRow) {
            cell.cellType = JYDetailCellTypeContent;
            cell.title = @"身高";
        } else if (indexPath.row == JYRegisterDetailHomeRow) {
            cell.cellType = JYDetailCellTypeContent;
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
    
    @weakify(self);
    if (indexPath.row == JYRegisterDetailBirthRow) {
        
        [ActionSheetDatePicker showPickerWithTitle:@"生日选择"
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:[JYUtil dateFromString:KBirthDaySeletedDate WithDateFormat:kDateFormatShort]
                                       minimumDate:[JYUtil dateFromString:kBirthDayMinDate WithDateFormat:kDateFormatShort]
                                       maximumDate:[JYUtil dateFromString:kBirthDayMaxDate WithDateFormat:kDateFormatShort]
                                         doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                             @strongify(self);
                                             NSDate *newDate = [selectedDate dateByAddingTimeInterval:[[NSTimeZone localTimeZone] secondsFromGMTForDate:selectedDate]];
                                             if (newDate) {
                                                 NSString *newDateStr = [JYUtil timeStringFromDate:newDate WithDateFormat:kDateFormatChina];
                                                 [JYUser currentUser].birthday = newDateStr;
                                                 JYRegisterDetailCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
                                                 cell.content = newDateStr;
                                             }
                                        } cancelBlock:nil origin:self.view];
        
    } else if (indexPath.row == JYRegisterDetailTallRow) {
        
        [ActionSheetStringPicker showPickerWithTitle:@"身高(:cm)"
                                                rows:[JYUser allUserHeights]
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               @strongify(self);
                                               [JYUser currentUser].height = selectedValue;
                                               JYRegisterDetailCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
                                               cell.content = selectedValue;
                                           } cancelBlock:nil origin:self.view];
        
    } else if (indexPath.row == JYRegisterDetailHomeRow) {
        
        ActionSheetMultipleStringPicker *picker = [[ActionSheetMultipleStringPicker alloc] initWithTitle:@"家乡"
                                                                                                    rows:[JYUser defaultHometown]
                                                                                        initialSelection:@[@0,@0]
                                                                                               doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues)
                                                   {
                                                       @strongify(self);
                                                       NSString *home = [NSString stringWithFormat:@"%@%@",[selectedValues firstObject],[selectedValues lastObject]];
                                                       [JYUser currentUser].homeTown = home;
                                                       JYRegisterDetailCell *cell = [self->_tableView cellForRowAtIndexPath:indexPath];
                                                       cell.content = home;
                                                   } cancelBlock:nil origin:self.view];
        picker.actionSheetDelegate = self;
        [picker showActionSheetPicker];
    }
}

#pragma mark - UIActionSheetDelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0) {
        //相册
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 1)  {
        //相机
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    if (type == UIImagePickerControllerSourceTypePhotoLibrary || type == UIImagePickerControllerSourceTypeCamera) {
        [self getImageWithSourceType:type];
    }
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self->_setAvatarView.userImg = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    @weakify(self);
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    UIImage *pickedImage;
//    
//    if ([type isEqualToString:@"public.image"]) {
//        pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    }
//    
//    if (pickedImage) {
//        @strongify(self);
//        self->_setAvatarView.userImg = pickedImage;
//    } else {
//        [[JYHudManager manager] showHudWithText:@"图片获取失败"];
//    }
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        @strongify(self);
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
//        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:nil];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- ActionSheetMultipleStringPickerDelegate
- (NSArray *)refreshDataSource:(NSArray *)dataSource atSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *array = [dataSource firstObject];
    NSString *province = array[row];
    NSArray *cities = [JYUser allCitiesWihtProvince:province];
    return cities;
}

@end
