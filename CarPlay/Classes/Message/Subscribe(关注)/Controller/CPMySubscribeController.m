//
//  CPMySubscribeController.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMySubscribeController.h"
#import "CPMySubscribeCell.h"
#import "MJExtension.h"
#import "CPMySubscribeFrameModel.h"
#import "CPMySubscribeModel.h"
#import "CPActiveDetailsController.h"
#import "CPTaDetailsController.h"
#import "MembersManageController.h"
#import "MembersController.h"
#import "CPModelButton.h"
#import "ZHPickView.h"

@interface CPMySubscribeController () <ZHPickViewDelegate>
@property (nonatomic, strong) NSMutableArray *frameModels;
@property (nonatomic, strong) NSString *activeId;
//遮盖
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) UITextField *carxibTextFeild;
@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) NSMutableArray *pickerArray;
@property (nonatomic, assign) BOOL tapYes;
@property (nonatomic, strong) ZHPickView *picker;


@end

@implementation CPMySubscribeController

#pragma mark - 懒加载
- (NSMutableArray *)frameModels
{
    if (_frameModels == nil) {
        _frameModels = [NSMutableArray array];
    }
    return _frameModels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
//    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
    self.navigationItem.title = @"我的收藏";
//    }else{
//        self.navigationItem.title = @"他的关注";
//    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.ignore = 0;
        [weakSelf loadDataWithParam:0];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.ignore = weakSelf.frameModels.count;
        [weakSelf loadDataWithParam:weakSelf.ignore];
    }];
    
    self.tableView.footer.hidden = YES;
    ZYJumpToLoginView // 跳转到登录界面
    [self reRefreshData];
}

- (void)reRefreshData
{
    [self showLoading];
    [self loadDataWithParam:0];
}

- (void)loadDataWithParam:(NSInteger)ignore
{
    NSString *userId = [Tools getValueFromKey:@"userId"];
    if (!userId.length) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self disMiss];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/subscribe",userId];
    
    [CPNetWorkTool getWithUrl:url params:@{@"ignore" : @(ignore)} success:^(id responseObject) {
        DLog(@"%@",responseObject);
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        if (CPSuccess) {
            NSArray *data = [CPMySubscribeModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.ignore == 0) {
                [self.frameModels removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            
            if (data.count) {
                for (CPMySubscribeModel *model in data) {
                    CPMySubscribeFrameModel *frameModel = [[CPMySubscribeFrameModel alloc] init];
                    frameModel.model = model;
                    [self.frameModels addObject:frameModel];
                }
                [self.tableView reloadData];
            }else{
                if (self.frameModels.count > 0) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            
            if (self.frameModels.count == 0) {
                [self showNoSubscribe];
            }
        }else if (self.frameModels.count == 0){
            [self showNetWorkFailed];
        }
    } failure:^(NSError *error) {
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [self.frameModels removeAllObjects];
        [self.tableView reloadData];
        [self showNetWorkOutTime];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CPNotificationCenter addObserver:self selector:@selector(userIconClick:) name:CPClickUserIconNotification object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(toPlayButtonClick:) name:ChatButtonClickNotifyCation object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(joinPersonButtonClick:) name:JoinPersonClickNotifyCation object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CPNotificationCenter removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frameModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMySubscribeCell *cell = [CPMySubscribeCell cellWithTableView:tableView];
    CPMySubscribeFrameModel *frameModel = self.frameModels[indexPath.row];
    frameModel.model.row = indexPath.row;
    cell.frameModel = frameModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMySubscribeFrameModel *frameModel = self.frameModels[indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到活动详情界面
    CPActiveDetailsController *activityDetailVc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil ].instantiateInitialViewController;
    CPMySubscribeFrameModel *frameModel = self.frameModels[indexPath.row];
    activityDetailVc.activeId = frameModel.model.activityId;
    [self.navigationController pushViewController:activityDetailVc animated:YES];
}

/**
 *  点击了用户的头像
 *
 *  @param notify notify description
 */
- (void)userIconClick:(NSNotification *)notify
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    vc.targetUserId = notify.userInfo[CPClickUserIconInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  点击了我要去玩按钮
 *
 *  @param notify notify description
 */
- (void)toPlayButtonClick:(NSNotification *)notify
{
    NSUInteger row = [notify.userInfo[ChatButtonClickInfo] intValue];
#warning 下面两句请勿删除,如果想要切换按钮状态需要修改model数值,重新刷新表格
    // 1. 当前的indexPath,刷新表格时使用
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    // 2. 对按钮状态进行刷新
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    CPMySubscribeFrameModel *frameModel = self.frameModels[row];
    
    // 当前行对应的model
    CPMySubscribeModel *model = frameModel.model;
    self.activeId = model.activityId;
    
    //根据isOrganizer判断进入那个界面
    if (model.isOrganizer == 1) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
        
        MembersManageController * vc = sb.instantiateInitialViewController;
        vc.activityId = model.activityId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (model.isMember == 1){
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
        MembersController * vc = sb.instantiateInitialViewController;
        vc.activityId = model.activityId;
        [self.navigationController pushViewController:vc animated:YES];
    }else { // 申请中
        
        if (model.isMember == 2) return;
        
        NSString *userId = [Tools getValueFromKey:@"userId"];
        NSString *token = [Tools getValueFromKey:@"token"];
        NSString *urlStr = [NSString stringWithFormat:@"v1/user/%@/seats?token=%@&activityId=%@",userId,token,self.activeId];
        //主车提供后台返回的车 非车主最多提供两辆车
        [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
            if ([responseObject operationSuccess]) {
                SQLog(@"%@",responseObject);
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                NSString *str = [formatter stringFromNumber:responseObject[@"data"][@"isAuthenticated"]];
                if ([str isEqualToString:@"1"]) {
                    // 遮盖
                    UIButton *cover = [[UIButton alloc] init];
                    self.cover = cover;
                    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
                    cover.frame = [UIScreen mainScreen].bounds;
                    [self.view.window addSubview:cover];
                    UIView *carView = [[[NSBundle mainBundle]loadNibNamed:@"offerCar" owner:self options:nil]lastObject];
                    CGFloat carViewX = self.view.window.center.x;
                    CGFloat carViewY = self.view.window.center.y - 100;
                    carView.center = CGPointMake(carViewX, carViewY);
                    self.carView = carView;
                    [self.view.window addSubview:carView];
                    //注意加载之后才有xib
                    UIButton *noButton = (UIButton *)[carView viewWithTag:1000];
                    self.noButton = noButton;
                    UIButton *yeButton = (UIButton *)[carView viewWithTag:2000];
                    self.yesButton = yeButton;
                    [noButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
                    [yeButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
                    CPModelButton * offerButton = (CPModelButton *)[carView viewWithTag:3000];
                    offerButton.model = model;
                    UITextField * carxibTextFeild = (UITextField *)[carView viewWithTag:4000];
                    self.carxibTextFeild = carxibTextFeild;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
                    [carView addGestureRecognizer:tap];
                    [offerButton addTarget:self action:@selector(offerSeatButton:) forControlEvents:UIControlEventTouchUpInside];
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                    int maxSeat = [[formatter stringFromNumber:responseObject[@"data"][@"maxValue"]] intValue];
                    int minSeat = [[formatter stringFromNumber:responseObject[@"data"][@"minValue"]] intValue];
                    [self.pickerArray removeAllObjects];
                    for (int i = minSeat; i <= maxSeat; i++) {
                        NSString *seat = [NSString stringWithFormat:@"%tu",i];
                        [self.pickerArray addObject:seat];
                    }
                    ZHPickView *picker = [[ZHPickView alloc]initPickviewWithArray:self.pickerArray isHaveNavControler:NO];
                    picker.delegate = self;
                    self.picker = picker;
                    self.carxibTextFeild.font = [AppAppearance textMediumFont];
                    self.carxibTextFeild.textColor = [AppAppearance textDarkColor];
                } else {
                    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/join",self.activeId];
                    [CPNetWorkTool postJsonWithUrl:urlStr params:nil success:^(id responseObject) {
                        if ([responseObject operationSuccess]) {
                            [self showInfo:@"请求成功,等待同意"];
                        } else {
                           [self showError:@"加载失败"];
                        }
                    } failed:^(NSError *error) {
                        [self showError:@"加载失败"];
                    }];
                    
                    
                    
                }
                
            } else {
                [self showError:@"加载失败"];
            }
        } failure:^(NSError *error) {
            [self showError:@"加载失败"];
        }];
        
        
    }
    
}

/**
 *  点击了参与人数的按钮
 *
 *  @param notify
 */
- (void)joinPersonButtonClick:(NSNotification *)notify
{
    NSUInteger row = [notify.userInfo[JoinPersonClickInfo] intValue];
    
    CPMySubscribeFrameModel *frameModel =  self.frameModels[row];
    
    // 当前行对应的model
    CPMySubscribeModel *model = frameModel.model;
    if (model.isOrganizer == 1) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
        
        MembersManageController * vc = sb.instantiateInitialViewController;
        vc.activityId = model.activityId;
       
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
        MembersController * vc = sb.instantiateInitialViewController;
        vc.activityId = model.activityId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//点击提交
- (void)offerSeatButton:(CPModelButton *)button {
    
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/join",self.activeId];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *seatStr = self.carxibTextFeild.text;
    if (seatStr.length!= 0) {
        parameters[@"seat"] = seatStr;
    } else {
        parameters[@"seat"] = @"0";
    }
    
    [self coverClick];
    [CPNetWorkTool postJsonWithUrl:urlStr params:parameters success:^(id responseObject) {
        if ([responseObject operationSuccess]) {
            CPMySubscribeModel *model = button.model;
            [self showInfo:@"请求成功,等待同意"];
            model.isMember = 2;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:model.row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self showError:@"加载失败"];
        }
    } failed:^(NSError *error) {
        [self showError:@"加载失败"];
    }];
    
}


#pragma mark - ZHPickViewDelegate

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    
    self.carxibTextFeild.text = resultString;
    
}



- (void)tap{
    
    if (!self.tapYes) {
        
        [self.picker show];
        
        self.picker.y = kScreenHeight - 256;
        
        self.yesButton.selected = YES;
        
        self.noButton.selected = NO;
        
        self.tapYes = YES;
        
    } else {
        
        [self.picker remove];
        
        self.yesButton.selected = NO;
        
        self.noButton.selected = YES;
        
        self.tapYes = NO;
        self.carxibTextFeild.text = nil;
        
    }
    
    
    
}

- (void)dealloc

{
    
    [CPNotificationCenter removeObserver:self];
    
    if (self.picker) {
        
        [self.picker removeFromSuperview];
        
    }
    
}



- (void)coverClick {
    [_cover removeFromSuperview];
    _cover = nil;
    [_carView removeFromSuperview];
    _carView = nil;
    [_picker removeFromSuperview];
    _picker = nil;
}

#pragma mark - lazy
- (NSMutableArray *)pickerArray {
    if (!_pickerArray) {
        _pickerArray = [[NSMutableArray alloc]init];
    }
    return _pickerArray;
}
@end
