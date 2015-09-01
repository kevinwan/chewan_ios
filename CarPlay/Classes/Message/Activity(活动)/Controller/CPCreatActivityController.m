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
#import "UzysAssetsPickerController.h"
#import "CPEditImageView.h"
#import "CPCreatActivityModel.h"
#import "CPLocationModel.h"
#import "NSDate+Extension.h"
#import "UMSocial.h"
#import "UMSocialData.h"
#import "CPActiveDetailsController.h"
#import "MJPhotoBrowser.h"
#import "CPCreatActivityModelTool.h"
#import "UIImage+Extension.h"

#define PhotoViewMargin 6
#define PickerViewHeght 256
#define maxCount 9
#define IntroductFont [UIFont systemFontOfSize:15]
typedef enum {
    ActivityCreateType = 1,
    ActivityCreateStart,
    ActivityCreateEnd,
    ActivityCreatePay,
    ActivityCreateSeat
}ActivityCreate; // 创建活动属性的类型

typedef enum {
    CreateActivityNone = 20,
    CreateActivityShare
}CreateActivityType; //创建完活动之后的操作

@interface CPCreatActivityController ()<ZYPickViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UzysAssetsPickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSUInteger lastRow;
@property (nonatomic, strong) NSArray *activivtyDatas;
@property (nonatomic, strong) ZYPickView *pickView;
@property (nonatomic, assign) CGFloat photoViewHeight;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) CGFloat nameLableHeight;
@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, assign) CGFloat photoWH;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishToFriend;
@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, strong) NSMutableArray *editPhotoViews;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) CPLocationModel *selectLocation;
@property (nonatomic, strong) CPLocalActivityModel *currentModel;
@property (nonatomic, strong) NSMutableArray *seats;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLabelWitdh;

@property (nonatomic, assign) BOOL imageEditing;
@end

@implementation CPCreatActivityController

#pragma mark - lazy


- (NSMutableArray *)seats
{
    if (_seats == nil) {
        _seats = [NSMutableArray array];
    }
    return _seats;
}

- (CPLocalActivityModel *)currentModel
{
    if (_currentModel == nil) {
        _currentModel = [[CPLocalActivityModel alloc] init];
    }
    return _currentModel;
}

- (UIBarButtonItem *)rightItem
{
    if (_rightItem == nil) {
        _rightItem = [UIBarButtonItem itemWithNorImage:@"删除" higImage:nil title:nil target:self action:@selector(showAlertIfDelete)];
    }
    return _rightItem;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = [Tools getColor:@"656c78"];
        _nameLabel.x = 8;
        _nameLabel.y = 42;
        _nameLabel.width = kScreenWidth - 16;
        _nameLabel.font = IntroductFont;
        _nameLabel.tag = 222;
    }
    return _nameLabel;
}

- (NSMutableArray *)editPhotoViews
{
    if (_editPhotoViews == nil) {
        _editPhotoViews = [NSMutableArray array];
    }
    return _editPhotoViews;
}

- (NSArray *)activivtyDatas
{
    if (_activivtyDatas == nil) {
        _activivtyDatas = @[@"吃饭", @"唱歌", @"看电影", @"周边游", @"运动", @"拼车", @"购物", @"亲子游"];
    }
    return _activivtyDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建活动";

    [self setUp];
}

/**
 *  初始化设置
 */
- (void)setUp
{
    self.photoWH = (kScreenWidth - 38) / 4;
    self.finishBtn.layer.cornerRadius = 3;
    self.finishBtn.clipsToBounds = YES;
    self.finishToFriend.layer.cornerRadius = 3;
    self.finishToFriend.clipsToBounds = YES;
    self.currentOffset = CGPointMake(0, -64);
    self.locationLabelWitdh.constant = kScreenWidth - 175;
    
    [self labelWithRow:4].text = [self stringFromDate:[NSDate date]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    [CPNotificationCenter addObserver:self selector:@selector(pickerViewCancle:) name:@"PicViewCancle" object:nil];
    [self.seats addObject:@"1个"];
    [self.seats addObject:@"2个"];
    [self labelWithRow:7].text = @"人数";
    [self setUpCellOperation];
    
    self.currentModel.type = @"吃饭";
    self.currentModel.pay = @"我请客";
    
    CPLocalActivityModel *localModel = [CPCreatActivityModelTool getLocalModel];
    if (localModel) {
        self.currentModel = localModel;
        
        [self setLocalData];
    }
}

/**
 *  设置本地数据
 */
- (void)setLocalData
{
    if (self.currentModel == nil) {
        return;
    }
    
    if (self.currentModel.type.length) {
        
        [self labelWithRow:0].text = self.currentModel.type;
    }
    
    if (self.currentModel.introduction.length > 0) {
        [self setNameCellHeightWithString:self.currentModel.introduction];
        self.nameLabel.text = self.currentModel.introduction;
        self.nameLabel.height = [self.currentModel.introduction sizeWithFont:IntroductFont maxW:kScreenWidth - 30].height;
        [self.tableView reloadData];
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd HH:mm";
    NSString *startStr = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.currentModel.start / 1000]];
    if (self.currentModel.latitude) {
        
        self.selectLocation = [[CPLocationModel alloc] init];
        self.selectLocation.latitude = @(self.currentModel.latitude);
        self.selectLocation.longitude = @(self.currentModel.longitude);
        self.selectLocation.city = self.currentModel.city;
        self.selectLocation.district = self.currentModel.district;
        self.selectLocation.province = self.currentModel.province;
        self.selectLocation.address = self.currentModel.address;
        self.selectLocation.location = self.currentModel.location;
        
        [self labelWithRow:3].text = self.currentModel.location;
    }
    
    if (self.currentModel.start) {
        
        [self labelWithRow:4].text = startStr;
    }
    
    if (self.currentModel.end > 0) {
        NSString *endStr = [fmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.currentModel.end / 1000]];
        [self labelWithRow:5].text = endStr;
    }else{
        [self labelWithRow:5].text = @"不确定";
    }
    
    if (self.currentModel.pay.length){
        
        [self labelWithRow:6].text = self.currentModel.pay;
    }
    
    if (self.currentModel.seat) {
        
        [self labelWithRow:7].text = [NSString stringWithFormat:@"%zd个",self.currentModel.seat];
    }
    
    if (self.currentModel.imageNames.count) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            DLog(@"%@",[NSThread currentThread]);
            
            NSMutableArray *imageDatas = [NSMutableArray array];
            [self.currentModel.imageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIImage *img = [UIImage imageWithFileName:obj];
                [imageDatas addObject:img];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addPhoto:imageDatas];
            });
        });
    }
    
    if (self.photoView.subviews.count == 10) {
        [self.photoView.subviews.lastObject setHidden:YES];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (CPUnLogin){
        return;
    }
  
        NSString *userId = [Tools getValueFromKey:@"userId"];
        NSString *url = [NSString stringWithFormat:@"v1/user/%@/seats",userId];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *token = [Tools getValueFromKey:@"token"];
        if (token){
            params[@"token"] = [Tools getValueFromKey:@"token"];
        }
        [ZYNetWorkTool getWithUrl:url params:params success:^(id responseObject) {
            if (CPSuccess){
                // 更改seat的座位
                [self changeSeatWithResult:responseObject[@"data"]];
                
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"加载空座数失败"];
        }];

    
}

- (void)changeSeatWithResult:(NSDictionary *)result
{
 
    if ([result[@"isAuthenticated"] intValue] == 1) {
        self.seatLabel.text = @"提供空座数";
        if (self.currentModel.seat == 0) {
            
            [self labelWithRow:7].text = @"个数";
        }
        [self.seats removeAllObjects];
        for(int i = [result[@"minValue"] intValue]; i <= [result[@"maxValue"] intValue]; i++){
            [self.seats addObject:[NSString stringWithFormat:@"%zd个",i]];
        }
    }else{
        [self.seats removeAllObjects];
        [self.seats addObject:@"1个"];
        [self.seats addObject:@"2个"];
        self.seatLabel.text = @"邀请人数";
        if (self.currentModel.seat == 0) {
            [self labelWithRow:7].text = @"人数";
        }
    }
}

/**
 *  当picker取消时调用
 *
 *  @param notify row
 */
- (void)pickerViewCancle:(NSNotification *)notify
{
    [self.tableView setContentOffset:self.currentOffset animated:YES];
    int row = [notify.userInfo[@"row"] intValue];
    if (row == 0) {
        [self closeArrowWithRow:0];
        [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
    }else{
        [self closeArrowWithRow:row];
    }
    self.pickView = nil;
}

/**
 *  进行cell操作的封装
 */
- (void)setUpCellOperation
{
    self.photoViewHeight = self.photoWH + 20;
    __weak typeof(self) weakSelf = self;
    // 设置活动类型
    CPCreatActivityCell *activityTypeCell = [self cellWithRow:0];
    activityTypeCell.operation = ^{
        
        if (weakSelf.pickView.tag == ActivityCreateType && weakSelf.pickView != nil){
            [weakSelf.pickView remove];
            [weakSelf closeArrowWithRow:0];
            weakSelf.pickView = nil;
        }else{
            
            [weakSelf.pickView removeFromSuperview];
            weakSelf.pickView = [[ZYPickView alloc] initPickviewWithArray:weakSelf.activivtyDatas isHaveNavControler:NO];
            [weakSelf.pickView  setBackgroundColor:[UIColor whiteColor]];
            weakSelf.pickView.tag = ActivityCreateType;
            weakSelf.pickView.row = 0;
            weakSelf.pickView.delegate = weakSelf;
            [weakSelf.pickView show];
        }
    };
      // 设置活动名称
    CPCreatActivityCell *activityNameCell = [self cellWithRow:1];
    [activityNameCell.contentView addSubview:weakSelf.nameLabel];
    
    activityNameCell.destClass = [CPActivityNameController class];
    
    CPCreatActivityCell *activityPhotoCell = [self cellWithRow:2];
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.photoViewHeight)];
    [activityPhotoCell.contentView addSubview:photoView];
    self.photoView = photoView;
    
    UIButton *addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoBtn.frame = CGRectMake(10, 10, self.photoWH, self.photoWH);
    [addPhotoBtn setBackgroundColor:[Tools getColor:@"ccd1d9"]];
    [addPhotoBtn setImage:[UIImage imageNamed:@"大相机"] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:addPhotoBtn];

    
    CPCreatActivityCell *activityLocationCell = [self cellWithRow:3];
    activityLocationCell.destClass = [CPMapViewController class];
    
    
    CPCreatActivityCell *activityStartCell = [self cellWithRow:4];
    activityStartCell.operation = ^{
        
        if (weakSelf.pickView.tag == ActivityCreateStart && weakSelf.pickView != nil){
            [weakSelf.pickView remove];
            [weakSelf closeArrowWithRow:4];
            weakSelf.pickView = nil;
        }else{
            
            [weakSelf.pickView removeFromSuperview];
            weakSelf.pickView  = [[ZYPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeTime isHaveNavControler:NO];
            NSTimeInterval time = [NSDate date].timeIntervalSince1970 - 300;
            weakSelf.pickView.datePicker.minLimitDate = [NSDate dateWithTimeIntervalSince1970:time];
            weakSelf.pickView.tag = ActivityCreateStart;
            weakSelf.pickView.row = 4;
            weakSelf.pickView.delegate = weakSelf;
            [weakSelf.pickView show];
        }
    };
    
    CPCreatActivityCell *activityEndCell = [self cellWithRow:5];
    activityEndCell.operation = ^{
        if (weakSelf.pickView.tag == ActivityCreateEnd && weakSelf.pickView != nil){
            [weakSelf.pickView remove];
            [weakSelf closeArrowWithRow:5];
            weakSelf.pickView = nil;
        }else{
            [weakSelf.pickView removeFromSuperview];
            weakSelf.pickView  = [[ZYPickView alloc] initDatePickWithDate:[NSDate date] datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
            weakSelf.pickView.tag = ActivityCreateEnd;
            weakSelf.pickView.row = 5;
            weakSelf.pickView.delegate = weakSelf;
            [weakSelf.pickView show];
        }
    };
    
    
    CPCreatActivityCell *activityPayCell = [self cellWithRow:6];
    activityPayCell.operation = ^{
        
        if (weakSelf.pickView.tag == ActivityCreatePay && weakSelf.pickView != nil){
            [weakSelf.pickView remove];
            [weakSelf closeArrowWithRow:6];
            weakSelf.pickView = nil;
        }else{
            
            [weakSelf.pickView removeFromSuperview];
            weakSelf.pickView=[[ZYPickView alloc] initPickviewWithArray:@[@"我请客", @"AA制", @"请我吧" ] isHaveNavControler:NO];
            weakSelf.pickView.tag = ActivityCreatePay;
            weakSelf.pickView.row = 6;
            weakSelf.pickView.delegate = weakSelf;
            [weakSelf.pickView show];
        }
    };
    
    
    CPCreatActivityCell *activitySeatCell = [self cellWithRow:7];
    activitySeatCell.operation = ^{
        
        if (weakSelf.pickView.tag == ActivityCreateSeat && weakSelf.pickView != nil){
            [weakSelf.pickView remove];
            [weakSelf closeArrowWithRow:7];
            weakSelf.pickView = nil;
        }else{
            
            [weakSelf.pickView removeFromSuperview];
            weakSelf.pickView=[[ZYPickView alloc] initPickviewWithArray:weakSelf.seats isHaveNavControler:NO];
            weakSelf.pickView.tag = ActivityCreateSeat;
            weakSelf.pickView.row = 7;
            weakSelf.pickView.delegate = weakSelf;
            [weakSelf.pickView show];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPCreatActivityCell *cell = [self cellWithRow:indexPath.row];
    
    if (indexPath.row != 2 && self.editPhotoViews.count != 0) {
        [self cancleEditPhotoSelect];
    }
    
    if (cell.destClass){
        CPReturnValueControllerView *vc = [[cell.destClass alloc] init];

        if (indexPath.row == 3) {
            if (self.selectLocation) {
                vc.forValue = self.selectLocation;
            }
            vc.completion = ^(CPLocationModel *model){
                if (model) {
                    [self labelWithRow:3].text = model.location;
                    self.selectLocation = model;
                    self.currentModel.latitude = model.latitude.doubleValue;
                    self.currentModel.longitude = model.longitude.doubleValue;
                    self.currentModel.city = model.city;
                    self.currentModel.province = model.province;
                    self.currentModel.district = model.district;
                    self.currentModel.location = model.location;
                    self.currentModel.address = model.address;
                    [CPCreatActivityModelTool save:self.currentModel];
                }
            };
        }
        
        if (indexPath.row == 1) {
            if (self.nameLabel.text.length) {
                vc.forValue = self.nameLabel.text;
            }
            
            vc.completion = ^(NSString *str){
                if (str.length) {
                    [self setNameCellHeightWithString:str];
                    self.nameLabel.text = str;
                    self.nameLabel.height = [str sizeWithFont:IntroductFont maxW:kScreenWidth - 30].height;
                    self.currentModel.introduction = str;
                    [self.tableView reloadData];
                }else{
                    self.nameLabel.text = nil;
                    self.currentModel.introduction = @"";
                    self.nameLableHeight = 50;
                    [self.tableView reloadData];
                }
                [CPCreatActivityModelTool save:self.currentModel];
            };
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
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
    
}

/**
 *  自动调整cell的位置
 *
 *  @param cell cell description
 */
- (void)viewUpWithCell:(CPCreatActivityCell *)cell
{
    CGRect covertedRect = [cell convertRect:cell.bounds toView:self.tableView];
    CGFloat cellBottom = covertedRect.origin.y + covertedRect.size.height - self.tableView.contentOffset.y;

    CGFloat margin = kScreenHeight - PickerViewHeght - cellBottom;
    
    if (margin >= 0) { // 如果间距大于0
        if ([self cellWithRow:0] == cell){
            [self.tableView scrollsToTop];
        }else{
//            [self.tableView setContentOffset:CGPointMake(0,self.tableView.contentOffset.y ) animated:YES];
        }
    }else{
        self.currentOffset = self.tableView.contentOffset;
        [self.tableView setContentOffset:CGPointMake(0,self.tableView.contentOffset.y - margin) animated:YES];
    }
}

/**
 *  根据文字计算cell的高度
 */
- (void)setNameCellHeightWithString:(NSString *)str
{
    self.nameLableHeight = 55 + [str sizeWithFont:IntroductFont maxW:kScreenWidth - 30].height;
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

/**
 *  根据字符串返回一个时间戳
 *
 *  @param dateStr 字符串
 *
 *  @return return value description
 */
- (NSTimeInterval)timeWithString:(NSString *)dateStr
{
    if ([dateStr isEqualToString:@"不确定"]){
        return 0;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
    NSDate *date = [fmt dateFromString:dateStr];
    return date.timeIntervalSince1970 * 1000;
}

/**
 *  转换出当前的时间格式
 *
 *  @return
 */

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
    return [fmt stringFromDate:date];
}

#pragma mark - ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZYPickView *)pickView resultString:(NSString *)resultString{

    switch (pickView.tag) {
        case ActivityCreateType:
        {
            [self labelWithRow:0].text = resultString;
            self.currentModel.type = resultString;
            break;
        }
        case ActivityCreateStart:
        {
            [self labelWithRow:4].text = resultString;
            self.currentModel.start = [self timeWithString:resultString];
            break;
        }
        case ActivityCreateEnd:
        {
            [self labelWithRow:5].text = resultString;
            self.currentModel.end = [self timeWithString:resultString];
            break;
        }
        case ActivityCreatePay:
        {
            [self labelWithRow:6].text = resultString;
            self.currentModel.pay = resultString;
            break;
        }
        case ActivityCreateSeat:
        {
            [self labelWithRow:7].text = resultString;
            self.currentModel.seat = [[resultString substringToIndex:1] intValue];
            break;
        }
            
        default:
            break;
    }
    
    // 及时保存信息
    [CPCreatActivityModelTool save:self.currentModel];
}

- (void)dealloc
{
    [CPNotificationCenter removeObserver:self];
    if (self.pickView) {
        [self.pickView removeFromSuperview];
    }
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
            pick.delegate = self;
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pick animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"相机不可用"];
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
    if (self.photoView.subviews.count == 10) {
        [self.photoView.subviews.lastObject setHidden:YES];
    }
    [SVProgressHUD showWithStatus:@"加载中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    [self showAlert];
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
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


/**
 *  系统的拍照完毕方法
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self addPhoto:@[portraitImg]];
    if (self.photoView.subviews.count == 10) {
        [self.photoView.subviews.lastObject setHidden:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  添加图片
 */
- (void)addPhoto:(NSArray *)arr
{
    if (self.photoView.subviews.count + arr.count > 10){
        [self showAlert];
        return;
    }
    
    for (int i = 0; i < arr.count; i++) {
        CPEditImageView *imageView = [[CPEditImageView alloc] init];
        imageView.image = arr[i];
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [imageView addGestureRecognizer:longPressGes];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        [imageView addGestureRecognizer:tapGes];
        
        [self.photoView insertSubview:imageView atIndex:0];
    }
    
    [self layoutPhotoView];
}

/**
 *  长按的选中效果
 *
 *  @param recognizer
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.imageEditing = YES;
        [self dealImageViewTapWithRecognizer:recognizer];
    }
}

- (void)tapPress:(UITapGestureRecognizer *)recognizer
{
    if (self.imageEditing) {
        [self dealImageViewTapWithRecognizer:recognizer];
    }else{
        
        if (![recognizer.view isKindOfClass:[CPEditImageView class]]) {
            return;
        }
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = recognizer.view.tag - 20;
        NSMutableArray *photos = [NSMutableArray array];
        for (int i = 0; i < self.photoView.subviews.count - 1; i ++) {
            UIImageView *imageView = (UIImageView *)[self.photoView viewWithTag:i + 20];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.srcImageView = imageView;
            photo.image = imageView.image;
            [photos addObject:photo];
        }
        browser.photos = photos;
        [browser show];
    }
}

/**
 *  处理图片手势的触发
 *
 *  @param recognizer recognizer description
 */
- (void)dealImageViewTapWithRecognizer:(UIGestureRecognizer *)recognizer
{
    CPEditImageView *editImageView = (CPEditImageView *)recognizer.view;
    
    if (editImageView.select) {
        [self.editPhotoViews removeObject:editImageView];
    }else{
        [self.editPhotoViews addObject:editImageView];
    }
    editImageView.showSelectImage = !editImageView.select;
    
    if (self.editPhotoViews.count > 0){
        self.navigationItem.rightBarButtonItem = self.rightItem;
    }else{
        self.imageEditing = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }

}

/**
 *  重新布局photoView
 */
- (void)layoutPhotoView
{
    
    CGFloat imgW = self.photoWH;
    CGFloat imgH = imgW;
    NSUInteger count = self.photoView.subviews.count;
    [self.currentModel.imageNames removeAllObjects];
    for (int i = 0; i < count; i++) {
        UIView *subView = self.photoView.subviews[i];
        subView.tag = i + 20;
        subView.x = 10 + (i % 4) * (PhotoViewMargin + imgW);
        subView.y = PhotoViewMargin + (i / 4) * (PhotoViewMargin + imgH);
        subView.width = imgW;
        subView.height = imgH;
        if ([subView isKindOfClass:[CPEditImageView class]]) {
            NSString *imageName = [[Tools getValueFromKey:@"userId"] stringByAppendingString:[NSString stringWithFormat:@"image%zd.data",i]];
            
            // 异步存储数据
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                CPEditImageView *editImageView = (CPEditImageView *)subView;
                [editImageView.image writePngToFile:CPDocmentPath(imageName) atomically:YES];
                [self.currentModel.imageNames addObject:imageName];
                
                // 及时保存信息
                [CPCreatActivityModelTool save:self.currentModel];
            });
            
        }
    }
    NSUInteger column = (count % 4 == 0) ? count / 4 : (count / 4 + 1);
    self.photoViewHeight = column * (imgH + PhotoViewMargin) + PhotoViewMargin;
    self.photoView.height = self.photoViewHeight;
    [self.tableView reloadData];
}

#pragma mark - 处理图片的编辑
/**
 *  取消所有照片的选中
 */
- (void)cancleEditPhotoSelect
{
    for (int i = 0; i < self.photoView.subviews.count; i++) {
        UIView *subView = self.photoView.subviews[i];
        if ([subView isKindOfClass:[CPEditImageView class]]) {
            CPEditImageView *editView = (CPEditImageView *)subView;
            editView.showSelectImage = NO;
        }
    }
    self.navigationItem.rightBarButtonItem = nil;
    self.imageEditing = NO;
}

/**
 *  提示是否删除
 */
- (void)showAlertIfDelete
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除选中的图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    [self deleteSelectPhoto];
}

/**
 *  删除选中的图片
 */
- (void)deleteSelectPhoto
{
    [self.editPhotoViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.editPhotoViews removeAllObjects];
    [self layoutPhotoView];
    self.navigationItem.rightBarButtonItem = nil;
    self.imageEditing = NO;
    if (self.photoView.subviews.count < 10) {
        [self.photoView.subviews.lastObject setHidden:NO];
    }
}

/**
 *  视图即将消失的时候做清理工作
 *
 *  @param animated 是否动画
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 如果有选中图片 清理
    if (self.editPhotoViews.count) {
        [self cancleEditPhotoSelect];
    }
    
    // 去除pickerView
    if (self.pickView) {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.lastRow inSection:0]];
    }
}

#pragma mark - 处理按钮点击事件
/**
 *  点击完成按钮
 */
- (IBAction)finishBtnClick:(UIButton *)button {
    
    if (self.currentModel.introduction.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"活动介绍不能为空"];
        return;
    }
    
    if (self.currentModel.type.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"活动类型不能为空"];
        return;
    }
    
    if (self.currentModel.latitude == 0 || self.currentModel.longitude == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择活动地点"];
        return;
    }
    
    if (self.currentModel.start <= 0){
        [SVProgressHUD showInfoWithStatus:@"请选择开始时间"];
        return;
    }
    if (self.currentModel.end > 0) {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.currentModel.start];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.currentModel.end];
        if([startDate compare:endDate] == NSOrderedDescending){
            [SVProgressHUD showInfoWithStatus:@"结束时间不能早于开始时间"];
            return;
        }
    }
    
    if (self.currentModel.seat == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择空座数"];
        return;
    }
    
    // 上传图片
    NSMutableArray *photoIds = [NSMutableArray array];
    
    NSUInteger photoCount = self.photoView.subviews.count - 1;
    if (photoCount < 1){
        [self showInfo:@"你最少需要上传1张图片"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"创建中"];
    button.userInteractionEnabled = NO;
    for (UIView *subView in self.photoView.subviews) {
        if ([subView isKindOfClass:[CPEditImageView class]]) {
            CPEditImageView *imageView = (CPEditImageView *)subView;
            
            ZYHttpFile *imageFile = [ZYHttpFile fileWithName:@"cover.jpg" data:UIImageJPEGRepresentation(imageView.image, 0.4) mimeType:@"image/jpeg" filename:@"cover.jpg"];
            
            [CPNetWorkTool postFileWithUrl:@"v1/activity/cover/upload" params:nil files:@[imageFile] success:^(id responseObject) {
                if (CPSuccess) {
                    NSString *photoId =
                     responseObject[@"data"][@"photoId"];
                    [photoIds addObject:photoId];
                    
                    // 图片上传完成
                    if (photoIds.count == photoCount) {
                        [self uploadCreatActivtyInfoWithPicId:photoIds button:button];
                    }
                }else{
                    [self showError:@"创建失败"];
                    button.userInteractionEnabled = YES;
                }
                
            } failure:^(NSError *error) {
                [self showError:@"创建失败"];
                button.userInteractionEnabled = YES;
            }];
        }
    }
    
}

/**
 *  上传创建活动的信息
 */
- (void)uploadCreatActivtyInfoWithPicId:(NSArray *)picIds button:(UIButton *)button
{
    if (picIds.count) {
        self.currentModel.cover = picIds;
    }
  
    NSString *currentCity = [CPUserDefaults stringForKey:@"CPUserCity"];
    if (currentCity.length) {
        self.currentModel.currentCity = currentCity;
    }else{
        self.currentModel.currentCity = @"";
    }
    
    NSString *currentDistrict = [CPUserDefaults stringForKey:@"CPUserArea"];
    if (currentDistrict.length) {
        self.currentModel.currentDistrict = currentDistrict;
    }else{
        self.currentModel.currentDistrict = @"";
    }
    
    NSDictionary *params = [CPCreatActivityModelTool paramsWithLocalModel:self.currentModel];

    DLog(@"%@",params);
    [CPNetWorkTool postJsonWithUrl:@"v1/activity/register" params:params success:^(id responseObject) {
        
        if (CPSuccess){
            [self showSuccess:@"创建成功"];
            [CPCreatActivityModelTool save:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (button.tag == CreateActivityNone) {
                    // 跳转到活动详情界面
                    CPActiveDetailsController *activityDetailVc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil ].instantiateInitialViewController;
                    activityDetailVc.isFromCreateActivity = YES;
                    activityDetailVc.activeId = responseObject[@"data"][@"activityId"];
                    [self.navigationController pushViewController:activityDetailVc animated:YES];
                    
                }else if (button.tag == CreateActivityShare){
                    // 分享给好友
                    [self shareToFriendWithDict:responseObject[@"data"]];
                    // 跳转到活动详情界面
                    CPActiveDetailsController *activityDetailVc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil ].instantiateInitialViewController;
                    activityDetailVc.isFromCreateActivity = YES;
                    activityDetailVc.activeId = responseObject[@"data"][@"activityId"];
                    [self.navigationController pushViewController:activityDetailVc animated:YES];
                }

            });
        }else{
            [self showError:@"创建失败"];
            button.userInteractionEnabled = YES;
        }
    } failed:^(NSError *error) {
        [self showError:@"创建失败"];
        button.userInteractionEnabled = YES;
    }];
}

/**
 *  根据创建活动成功返回的数据分享给好友
 *
 *  @param data 成功后返回的数据
 */
- (void)shareToFriendWithDict:(NSDictionary *)data
{
    SQLog(@"%@",data);
    UIImage *image = nil;
    NSData *dataUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:data[@"imgUrl"]]];
    if (dataUrl!=nil) {
        image = [[UIImage alloc]initWithData:dataUrl];
    }
    [UMSocialData defaultData].extConfig.wechatSessionData.url = data[@"shareUrl"];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = data[@"shareTitle"];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = data[@"shareUrl"];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = data[@"shareTitle"];
    [UMSocialData defaultData].extConfig.qqData.url = data[@"shareUrl"];
    [UMSocialData defaultData].extConfig.qqData.title = data[@"shareTitle"];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:nil shareText:data[@"shareContent"] shareImage:image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ, nil] delegate:nil];
}

@end
