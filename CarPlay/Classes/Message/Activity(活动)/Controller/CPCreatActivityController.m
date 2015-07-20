//
//  CPCreatActivityController.m
//  CarPlay
//
//  Created by chewan on 15/7/18.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  创建活动

#import "CPCreatActivityController.h"
#import "CPCreatActivityCell.h"
#import "CPActivityNameController.h"
#import "ZYPickView.h"
#import "CPMapViewController.h"
#import "NSString+Extension.h"
#import <UzysAssetsPickerController/UzysWrapperPickerController.h>
#import "UzysAssetsPickerController.h"

#define maxCount 9
typedef enum {
    ActivityCreateType = 1,
    ActivityCreateStart,
    ActivityCreateEnd,
    ActivityCreatePay,
    ActivityCreateSeat
}ActivityCreate;

@interface CPCreatActivityController ()<ZYPickViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UzysAssetsPickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSUInteger lastRow;
@property (nonatomic, strong) NSArray *activivtyDatas;
@property (nonatomic, strong) ZYPickView *pickView;
@property (nonatomic, assign) CGFloat photoViewHeight;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) CGFloat nameLableHeight;
@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, assign) CGFloat photoWH;
@property (nonatomic, assign) NSUInteger picIndex;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishToFriend;

@end

@implementation CPCreatActivityController

#pragma mark - lazy

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = [Tools getColor:@"656c78"];
        _nameLabel.x = 15;
        _nameLabel.y = 40;
        _nameLabel.width = kScreenWidth - 30;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.tag = 222;
    }
    return _nameLabel;
}

- (NSArray *)activivtyDatas
{
    if (_activivtyDatas == nil) {
        _activivtyDatas = @[@"代驾", @"吃饭", @"唱歌", @"拼车", @"旅行", @"看电影", @"运动"];
    }
    return _activivtyDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建活动";
    self.photoWH = (kScreenWidth - 50) / 4;
    self.finishBtn.layer.cornerRadius = 3;
    self.finishBtn.clipsToBounds = YES;
    self.finishToFriend.layer.cornerRadius = 3;
    self.finishToFriend.clipsToBounds = YES;
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    [CPNotificationCenter addObserver:self selector:@selector(pickerViewCancle:) name:@"PicViewCancle" object:nil];
    
    [self setUpCellOperation];
}

/**
 *  当picker取消时调用
 *
 *  @param notify <#notify description#>
 */
- (void)pickerViewCancle:(NSNotification *)notify
{
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
    int row = [notify.userInfo[@"row"] intValue];
    [self closeArrowWithRow:row];
    self.pickView = nil;
}

/**
 *  进行cell操作的封装
 */
- (void)setUpCellOperation
{
    self.photoViewHeight = self.photoWH + 20;
    
    // 设置活动类型
    CPCreatActivityCell *activityTypeCell = [self cellWithRow:0];
    activityTypeCell.operation = ^{
        
        if (_pickView.tag == ActivityCreateType && _pickView != nil){
            [_pickView remove];
            [self closeArrowWithRow:0];
            _pickView = nil;
        }else{
            
            [_pickView removeFromSuperview];
            _pickView=[[ZYPickView alloc] initPickviewWithArray:self.activivtyDatas isHaveNavControler:NO];
            [_pickView  setBackgroundColor:[UIColor whiteColor]];
            _pickView.tag = ActivityCreateType;
            _pickView.row = 0;
            _pickView.delegate = self;
            [_pickView show];
        }
    };
    
    // 设置活动名称
    CPCreatActivityCell *activityNameCell = [self cellWithRow:1];
    [activityNameCell.contentView addSubview:self.nameLabel];
    
    activityNameCell.destClass = [CPActivityNameController class];
    
    CPCreatActivityCell *activityPhotoCell = [self cellWithRow:2];
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.photoViewHeight)];
    [activityPhotoCell.contentView addSubview:photoView];
    self.photoView = photoView;
    
    UIButton *addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoBtn.tag = 9;
    addPhotoBtn.frame = CGRectMake(10, 10, self.photoWH, self.photoWH);
    [addPhotoBtn setBackgroundColor:[Tools getColor:@"ccd1d9"]];
    [addPhotoBtn setImage:[UIImage imageNamed:@"大相机"] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:addPhotoBtn];

    
    CPCreatActivityCell *activityLocationCell = [self cellWithRow:3];
    activityLocationCell.destClass = [CPMapViewController class];
    
    
    CPCreatActivityCell *activityStartCell = [self cellWithRow:4];
    activityStartCell.operation = ^{
        
        if (_pickView.tag == ActivityCreateStart && _pickView != nil){
            [_pickView remove];
            [self closeArrowWithRow:4];
            _pickView = nil;
        }else{
            
            [_pickView removeFromSuperview];
            _pickView  = [[ZYPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
            _pickView.tag = ActivityCreateStart;
            _pickView.row = 4;
            _pickView.delegate = self;
            _pickView.height = 80;
            [_pickView show];
        }
    };
    
    
    CPCreatActivityCell *activityEndCell = [self cellWithRow:5];
    activityEndCell.operation = ^{
        if (_pickView.tag == ActivityCreateEnd && _pickView != nil){
            [_pickView remove];
            [self closeArrowWithRow:5];
            _pickView = nil;
        }else{
            [_pickView removeFromSuperview];
            _pickView  = [[ZYPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
            _pickView.tag = ActivityCreateEnd;
            _pickView.row = 5;
            _pickView.delegate = self;
            [_pickView show];
        }
    };
    
    
    CPCreatActivityCell *activityPayCell = [self cellWithRow:6];
    activityPayCell.operation = ^{
        
        if (_pickView.tag == ActivityCreatePay && _pickView != nil){
            [_pickView remove];
            [self closeArrowWithRow:6];
            _pickView = nil;
        }else{
            
            [_pickView removeFromSuperview];
            _pickView=[[ZYPickView alloc] initPickviewWithArray:@[@"我请客", @"你请客", @"AA制"] isHaveNavControler:NO];
            _pickView.tag = ActivityCreatePay;
            _pickView.row = 6;
            _pickView.delegate = self;
            [_pickView show];
        }
    };
    
    
    CPCreatActivityCell *activitySeatCell = [self cellWithRow:7];
    activitySeatCell.operation = ^{
        
        if (_pickView.tag == ActivityCreateSeat && _pickView != nil){
            [_pickView remove];
            [self closeArrowWithRow:7];
            _pickView = nil;
        }else{
            
            [_pickView removeFromSuperview];
            _pickView=[[ZYPickView alloc] initPickviewWithArray:@[@"2个", @"3个", @"4个", @"5个"] isHaveNavControler:NO];
            _pickView.tag = ActivityCreateSeat;
            _pickView.row = 7;
            _pickView.delegate = self;
            [_pickView show];
        }
    };
    
}

/**
 *  返货获取到得cell
 *
 *  @param row 行号
 */
- (CPCreatActivityCell *)cellWithRow:(NSUInteger)row
{
    return  (CPCreatActivityCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

- (UILabel *)labelWithRow:(NSUInteger)row
{
    CPCreatActivityCell *cell = [self cellWithRow:row];
    return (UILabel *)[cell viewWithTag:222];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPCreatActivityCell *cell = [self cellWithRow:indexPath.row];
    if (self.isOpen) {
        [self closeArrowWithRow:indexPath.row];
    }else{
        [self closeArrowWithRow:self.lastRow];
        [self openArrowWithRow:indexPath.row];
    }
    
    self.lastRow = indexPath.row;
    
    if (cell.operation) {
        cell.operation();
        [self viewUpWithCell:cell];
        return;
    }
    if (cell.destClass){
        CPReturnValueControllerView *vc = [[cell.destClass alloc] init];
        if (indexPath.row == 3) {
            
            vc.completion = ^(NSString *str){
                
            };
        }
        
        if (indexPath.row == 1) {
            vc.completion = ^(NSString *str){
                NSLog(@"%@...",str);
                [self setNameCellHeightWithString:str];
                
                self.nameLabel.text = str;
                self.nameLabel.height = [str sizeWithFont:[UIFont systemFontOfSize:16] maxW:kScreenWidth - 30].height;
                [self.tableView reloadData];
            };
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)viewUpWithCell:(CPCreatActivityCell *)cell
{
    CGRect covertedRect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
    if (covertedRect.origin.y + 20 >= kScreenHeight - self.pickView.height) {
        [self.tableView setContentOffset:CGPointMake(0, covertedRect.origin.y + self.tableView.contentOffset.y - (kScreenHeight - self.pickView.height - 50)) animated:YES];
    }else{
         [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
    }
}

/**
 *  根据文字计算cell的高度
 */
- (void)setNameCellHeightWithString:(NSString *)str
{
    self.nameLableHeight = 60 + [str sizeWithFont:[UIFont systemFontOfSize:16] maxW:kScreenWidth - 30].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return self.nameLableHeight > 50 ? self.nameLableHeight : 50;
    }else if (indexPath.row == 2){
        return self.photoViewHeight;
    }
    return 50;
}

#pragma mark - ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZYPickView *)pickView resultString:(NSString *)resultString{

    switch (pickView.tag) {
        case ActivityCreateType:
        {
            [self labelWithRow:0].text = resultString;
            break;
        }
        case ActivityCreateStart:
        {
            [self labelWithRow:4].text = resultString;
            break;
        }
        case ActivityCreateEnd:
        {
            [self labelWithRow:5].text = resultString;
            break;
        }
        case ActivityCreatePay:
        {
            [self labelWithRow:6].text = resultString;
            break;
        }
        case ActivityCreateSeat:
        {
            [self labelWithRow:7].text = resultString;
            break;
        }
            
        default:
            break;
    }
}

- (void)dealloc
{
    [CPNotificationCenter removeObserver:self];
}

/**
 *  旋转箭头的方法
 */
- (void)openArrowWithRow:(NSUInteger)row
{
    UIView *arrow = [[self cellWithRow:row] viewWithTag:111];
    
    [UIView animateWithDuration:0.25 animations:^{
        arrow.transform = CGAffineTransformRotate(arrow.transform, M_PI_2);
    }];
}

- (void)closeArrowWithRow:(NSUInteger)row
{
    UIView *arrow = [[self cellWithRow:row] viewWithTag:111];
    
    [UIView animateWithDuration:0.25 animations:^{
        arrow.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  下面的方法用来设置tableView全屏的分割线
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - 添加相片的相关方法
- (void)addPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.allowsEditing = YES;
            pick.delegate = self;
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pick animated:YES completion:nil];
        }else{

            
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
            picker.delegate = self;
            
            picker.maximumNumberOfSelectionPhoto = 10 - self.photoView.subviews.count;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}
/**
 *  照片选择完毕
 *
 *  @param picker picker description
 *  @param info   info description
 */

#pragma mark - <UZYImagePickerController>

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *arr = [NSMutableArray array];
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            [arr addObject:img];
            
            
        }];
    [self addPhoto:arr];
        
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"您最多只能上传9张图片"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DLog(@"系统的....");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  添加图片
 */
- (void)addPhoto:(NSArray *)arr
{
    for (int i = 0; i < arr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = arr[i];
        [self.photoView insertSubview:imageView atIndex:0];
    }
    
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    CGFloat imgW = self.photoWH;
    CGFloat imgH = imgW;
    NSUInteger count = self.photoView.subviews.count;
    for (int i = 0; i < count; i++) {
        UIView *subView = self.photoView.subviews[i];
        subView.x = 10 + (i % 4) * (10 + imgW);
        subView.y = 10 + (i / 4) * (10 + imgH);
        subView.width = imgW;
        subView.height = imgH;
    }
    NSUInteger column = (count % 4 == 0) ? count / 4 : (count / 4 + 1);
    self.photoViewHeight = column * (imgH + 10) + 10;
    self.photoView.height = self.photoViewHeight;
    [self.tableView reloadData];
}

@end
