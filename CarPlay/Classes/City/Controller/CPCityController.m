//
//  CPCityController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPCityController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "CPHomeStatus.h"
#import "CPHomeUser.h"
#import "CPHomeStatusCell.h"
#import "CPActiveDetailsController.h"
#import "CPSelectView.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "INTULocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "MWPhotoBrowser.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CPNoNet.h"
#import "CPHomeIconCell.h"
#import "CPRefreshHeader.h"
#import "CPRefreshFooter.h"

@interface CPCityController ()<UITableViewDataSource,UITableViewDelegate,CPSelectViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

// 地理编码对象
@property (nonatomic ,strong) CLGeocoder *geocoder;

// 用户id
@property (nonatomic,copy) NSString *userId;

// 用户token
@property (nonatomic,copy) NSString *token;

// 上滑加载条数
@property (nonatomic,assign) NSInteger ignoreNum;

// 热门、附近、最新标识
@property (nonatomic,copy) NSString *selectMark;


// 用户所在城市
@property (nonatomic,copy) NSString *myCity;

// 经度
@property (nonatomic,assign) double longitude;

// 纬度
@property (nonatomic,assign) double latitude;

// 筛选信息类
@property (nonatomic,strong) CPSelectViewModel *selectViewModel;

// 蒙板遮罩
@property (nonatomic,strong) UIButton *coverBtn;

// 蒙板遮罩
@property (nonatomic,strong) CPSelectView *selectView;

// 存储所有活动数据
@property (nonatomic,strong) NSMutableArray *status;

// 存储所有需要显示的图片对象
//@property (nonatomic, strong) NSMutableArray *photos;

// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 缓存cell高度（线程安全、内存紧张时会自动释放、不会拷贝key）
@property (nonatomic,strong) NSCache *rowHeightCache;

// 创建活动
- (IBAction)createActive:(id)sender;

// 筛选
- (IBAction)select:(id)sender;

// 顶部按钮点击
- (IBAction)hotBtnClick:(id)sender;
- (IBAction)nearBtnClick:(id)sender;
- (IBAction)lastestBtnClick:(id)sender;


// 热门底部线
@property (weak, nonatomic) IBOutlet UIView *hotLine;
// 附近底部线
@property (weak, nonatomic) IBOutlet UIView *nearLine;
// 最新底部线
@property (weak, nonatomic) IBOutlet UIView *latestLine;

// 热门约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotConstraint;
// 附近约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nearConstraint;
// 最新约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastestConstraint;

// 热门
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
// 附近
@property (weak, nonatomic) IBOutlet UIButton *nearBtn;
// 最新
@property (weak, nonatomic) IBOutlet UIButton *lastestBtn;

// 是否为第一次加载页面
@property (nonatomic,assign) NSInteger isFirstLoad;
//活动ID
@property (nonatomic, strong) NSString *activeId;

// 遮盖
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) NSMutableArray *pickerArray;
@property (nonatomic, strong) UITextField *carxibTextFeild;
@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation CPCityController
- (void)viewDidLoad {
    [super viewDidLoad];

    // 没网的时候点击重新加载
    if (CPNoNetWork) {
        __weak typeof(self) weakSelf = self;
        CPNoNet *cpNoNet = [CPNoNet footerView];
        cpNoNet.loadHomePage = ^{
            [weakSelf setupLoadStatusWithIgnore:0 Key:@"hot" SelectModel:nil];
            weakSelf.tableView.tableFooterView = nil;
        };
        
        
        self.tableView.tableFooterView = cpNoNet;
    }
    // 导航栏筛选
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNorImage:@"首页筛选" higImage:@"" title:nil target:self action:@selector(select:)];
    
    // 加载活动数据
    [self setupLoadStatusWithIgnore:0 Key:self.selectMark SelectModel:nil];
    
    // 上拉下拉刷新
    [self topAndBottomRefresh];

    // 设置顶部按钮
    [self.hotBtn setHighlighted:NO];
    
    // 获取当前经纬度
    [self getLongitudeAndLatitude];
    
  
}


// 获取当前经纬度
- (void)getLongitudeAndLatitude{
    // 获取用户经纬度和城市
    // 1.创建位置管理者
    INTULocationManager *mgr = [INTULocationManager sharedInstance];
    // 2.利用位置管理者获取位置
    [mgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom  timeout:5 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess || status == INTULocationStatusTimedOut) {

            self.longitude = currentLocation.coordinate.longitude;
            self.latitude = currentLocation.coordinate.latitude;
            
            [self getAtCity];

        }else if(status ==  INTULocationStatusError)
        {
                        NSLog(@"获取失败");
        }
    }];
}


// 获取当前城市
- (void)getAtCity{
   
    // 根据用户输入的经纬度创建CLLocation对象
    CLLocation *cllocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    
    [self.geocoder reverseGeocodeLocation:cllocation completionHandler:^(NSArray *placemarks, NSError *error) {

        for (CLPlacemark *placemark in placemarks) {

            self.myCity = placemark.locality;

        }
//        NSLog(@"%@",self.myCity);
        

    }];
}



- (void)topAndBottomRefresh{
    // 添加下拉刷新控件（头部）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownLoadData)];
    header.arrowView.image = [UIImage imageNamed:@"refreshArrow"];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.automaticallyChangeAlpha = YES;
    header.stateLabel.textColor = [Tools getColor:@"aab2bd"];
    header.lastUpdatedTimeLabel.textColor = [Tools getColor:@"aab2bd"];
    
    self.tableView.header = header;
    
    
    
    
    // 添加上拉刷新控件（底部）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upglideLoadData)];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.automaticallyChangeAlpha = YES;
    footer.stateLabel.textColor = [Tools getColor:@"aab2bd"];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateNoMoreData];

    self.tableView.footer = footer;

}

// 下拉刷新
- (void)dropDownLoadData{
    // 计数清零
    self.ignoreNum = 0;
    [self setupLoadStatusWithIgnore:0 Key:self.selectMark SelectModel:nil];
}

// 上滑
- (void)upglideLoadData{
    self.ignoreNum += CPPageNum;
    [self setupLoadStatusWithIgnore:self.ignoreNum Key:self.selectMark SelectModel:nil];
}


// 加载活动数据
- (void)setupLoadStatusWithIgnore:(NSInteger)ignore Key:(NSString *)key SelectModel:(CPSelectViewModel *)selectModel{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"key"] = key;
    parameters[@"ignore"] = @(ignore);
    
    if ([self.myCity isEqualToString:@""]) {
        parameters[@"city"] = self.myCity;
    }else{
        parameters[@"city"] = @"";
    }
    
   
    parameters[@"longitude"] = [NSString stringWithFormat:@"%f",self.longitude];
    parameters[@"latitude"] = [NSString stringWithFormat:@"%f",self.latitude];


    if (self.userId != nil) {
        parameters[@"userId"] = self.userId;
    }
    if (self.token != nil) {
        parameters[@"token"] = self.token;
    }
    
    // 如果是筛选的情况
    if (selectModel) {
        if (selectModel.gender != nil) {
            parameters[@"gender"] = selectModel.gender;
        }else{
            parameters[@"gender"] = @"";
        }
        
        if (selectModel.province != nil) {
            parameters[@"province"] = selectModel.gender;
        }else{
            parameters[@"province"] = @"";
        }
        
        if (selectModel.city != nil) {
            parameters[@"city"] = selectModel.city;
        }else{
            parameters[@"city"] = @"";
        }
        
        if (selectModel.district != nil) {
            parameters[@"district"] = selectModel.district;
        }else{
            parameters[@"district"] = @"";
        }
        
        parameters[@"authenticate"] = @(selectModel.authenticate);
        
        
        if (selectModel.type) {
            parameters[@"type"] = selectModel.type;
        }else{
            parameters[@"type"] = @"";
        }
        
        if (selectModel.carLevel) {
            parameters[@"carLevel"] = selectModel.carLevel;
        }else{
            parameters[@"carLevel"] = @"";
        }

    }
    
    
    // 获取网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 发送请求
    [manager GET:@"http://cwapi.gongpingjia.com/v1/activity/list" parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        
        // 取出活动数据
        NSArray *dicts = responseObject[@"data"];
    
        
        // 转换为模型数组
       NSArray *models = [CPHomeStatus objectArrayWithKeyValuesArray:dicts];
        
        if (!ignore) {
            [self.status removeAllObjects];
            [self.status addObjectsFromArray:models];
        }else{
            [self.status addObjectsFromArray:models];
        }

        
        // 刷新表格
        [self.tableView reloadData];
        
        // 关闭下拉刷新栏
        [self.tableView.header endRefreshing];
        // 关闭上拉刷新栏
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        [SVProgressHUD showWithStatus:@"获取用户信息失败"];
    }];
    
}



#pragma mark - 数据源方法
// 1、2、3为数据源方法执行顺序
// 1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.status.count;
}


// 3
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建cell
    CPHomeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPHomeStatusCell identifier]];
    
    // 设置数据
    cell.status = self.status[indexPath.row];
    //绑定tag
    cell.myPlay.tag = indexPath.row;
    
    // 弹出图片浏览器
    if (cell.pictureDidSelected == nil) {
//        __weak typeof(self) weakSelf = self;
        cell.pictureDidSelected = ^(CPHomeStatus *status,NSIndexPath *path, NSArray *srcView){
            
//            // 清空photos中的数据
//            [self.photos removeAllObjects];
//            
//            // 初始化所有数据
//            NSArray *urls = [status.cover valueForKeyPath:@"thumbnail_pic"];
//            
//            for (int i = 0; i < urls.count; ++i) {
//                NSURL *url = [NSURL URLWithString:urls[i]];
//                MWPhoto *photo = [MWPhoto photoWithURL:url];
//                [self.photos addObject:photo];
//            }
//            
//            // 创建浏览器
//            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:weakSelf];
//            [browser setCurrentPhotoIndex:path.item];
//            
//            // 显示浏览器
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
//            [weakSelf presentViewController:nav animated:YES completion:nil];
            
            
            // 1.创建图片浏览器
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
             NSArray *urls = [status.cover valueForKeyPath:@"thumbnail_pic"];
            // 2.设置图片浏览器显示的所有图片
            NSMutableArray *photos = [NSMutableArray array];
            NSUInteger count = urls.count;
            for (int i = 0; i<count; i++) {
              
                MJPhoto *photo = [[MJPhoto alloc] init];
                // 设置图片的路径
                photo.url = [NSURL URLWithString:urls[i]];
                // 设置来源于哪一个UIImageView
//                NSLog(@"weit == %@",[srcView[i] frameStr]);

                photo.srcImageView = srcView[i];
                [photos addObject:photo];
            }
            browser.photos = photos;
            
            // 3.设置默认显示的图片索引
            browser.currentPhotoIndex = path.item;
            
            // 3.显示浏览器
            [browser show];
            

            
        };
    }
    
    //弹出成员列表 防止单元格重用 先判断
    if (cell.tapIcons == nil) {
        __weak typeof(self) weakSelf = self;
        cell.tapIcons = ^(CPHomeStatus *status) {
            [SVProgressHUD showWithStatus:@"努力加载中"];
            //登陆状态下可点 拿出创建者字段,非登陆 自动跳转登陆界面
            NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/info",status.activityId];
            SQLog(@"%@",status.activityId);
            [CPNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
                [weakSelf disMiss];
                if ([responseObject operationSuccess]) {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                    NSString *strOrganizer = [formatter stringFromNumber:responseObject[@"data"][@"isOrganizer"]];
                    if ([strOrganizer isEqualToString:@"1"]) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
                        
                        MembersManageController * vc = sb.instantiateInitialViewController;
                        vc.activityId = status.activityId;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                        
                    } else  {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
                        MembersController * vc = sb.instantiateInitialViewController;
                        vc.activityId = status.activityId;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                    
                } else {
                    [self.view alertError:responseObject];
                }
            } failure:^(NSError *error) {
                [self.view alertError:error];
            }];

        
        };
    }
    
    return cell;
}

// 2
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出对应行模型
    CPHomeStatus *status = self.status[indexPath.row];
    
    // 先从缓存中获取高度，没有才计算
    NSNumber *rowHeight = [self.rowHeightCache objectForKey:status.activityId];
    
    CGFloat cellHeight = [rowHeight doubleValue];
    
    if (rowHeight == nil) {
        // 取出cell
        CPHomeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPHomeStatusCell identifier]];
        
        // 获取高度
        cellHeight = [cell cellHeightWithStatus:status];
        
        // 缓存每一行的高度
        [self.rowHeightCache setObject:@(cellHeight) forKey:status.activityId];

    }
    
    // 设置高度
    return cellHeight;
}

// 预估每一行cell的高度，可提高性能（只计算可是区域的cell）
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

#pragma mark - MWPhotoBrowserDelegate
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return self.photos.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    if (index < self.photos.count)
//        return [self.photos objectAtIndex:index];
//    return nil;
//}


// 点击cell跳转到活动详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 获取活动详情storyboard中的控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil];
    CPActiveDetailsController *ac = sb.instantiateInitialViewController;
    
    // 取出对应行模型
    CPHomeStatus *status = self.status[indexPath.row];
    
    ac.activeId = status.activityId;
 
    [self.navigationController pushViewController:ac animated:YES];
    
}


#pragma mark - lazy(懒加载)

//- (NSMutableArray *)photos{
//    if (!_photos) {
//        _photos = [NSMutableArray array];
//    }
//    return _photos;
//}
// 地理编码对象
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (UIButton *)coverBtn
{
    if (_coverBtn == nil) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        _coverBtn.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
        [[UIApplication sharedApplication].keyWindow addSubview:_coverBtn];
        _coverBtn.hidden = YES;
    }
    return _coverBtn;
}

// 行高缓存
- (NSCache *)rowHeightCache{
    if (!_rowHeightCache) {
        _rowHeightCache = [[NSCache alloc] init];
    }
    return _rowHeightCache;
}

// 用户id
- (NSString *)userId{
    if (!_userId) {
       _userId = [Tools getValueFromKey:@"userId"];
    }
    return _userId;
}

// 用户token
- (NSString *)token{
    if (!_token) {
        _token = [Tools getValueFromKey:@"token"];
    }
    return _token;
}



- (NSMutableArray *)status{
    if (!_status) {
        _status = [NSMutableArray array];
    }
    return _status;
}

// 热门、附近、最新
- (NSString *)selectMark{
    if (!_selectMark) {
        _selectMark = @"hot";
    }
    return _selectMark;
}

- (NSString *)myCity{
    if (!_myCity) {
        _myCity = @"";
    }
    return _myCity;
}



#pragma mark - 按钮点击事件
// 创建活动
- (IBAction)createActive:(id)sender {
    if (CPUnLogin) {
    // 未登录则提示登录
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPCreatActivityController" bundle:nil];
        
        [self.navigationController pushViewController:sb.instantiateInitialViewController animated:YES];
        
    }

}

// 筛选
- (IBAction)select:(id)sender {
    
    if (self.coverBtn.hidden) {
        
        self.coverBtn.hidden = NO;
        
        CPSelectView *selectView = [CPSelectView selectView];
        selectView.delegate = self;
        [selectView showWithView:self.coverBtn];
        
        self.selectView = selectView;
    }else{
        [self selectViewCancleBtnClick:self.selectView];
    }
    
}

// 热门按钮点击
- (IBAction)hotBtnClick:(id)sender {
    // 按钮颜色
    [self.hotBtn setTitleColor:[Tools getColor:@"fc6e51"] forState:UIControlStateNormal];
    [self.nearBtn setTitleColor:[Tools getColor:@"434a53"] forState:UIControlStateNormal];
    [self.lastestBtn setTitleColor:[Tools getColor:@"434a53"] forState:UIControlStateNormal];
    
    // 底边颜色
    self.hotLine.backgroundColor = [Tools getColor:@"fc6e51"];
    self.nearLine.backgroundColor = [Tools getColor:@"e6e9ed"];
    self.latestLine.backgroundColor = [Tools getColor:@"e6e9ed"];
    
    // 约束调整
    self.hotConstraint.constant = 0;
    self.nearConstraint.constant = 1;
    self.lastestConstraint.constant = 1;
    
    self.myCity = @"";
    
    [self setupLoadStatusWithIgnore:0 Key:@"hot" SelectModel:nil];
    self.selectMark = @"hot";
    
    
    
}

// 附近按钮点击
- (IBAction)nearBtnClick:(id)sender {
    // 按钮颜色
    [self.hotBtn setTitleColor:[Tools getColor:@"434a53"] forState:UIControlStateNormal];
    [self.nearBtn setTitleColor:[Tools getColor:@"fc6e51"] forState:UIControlStateNormal];
    [self.lastestBtn setTitleColor:[Tools getColor:@"434a53"] forState:UIControlStateNormal];

    // 底边颜色
    self.hotLine.backgroundColor = [Tools getColor:@"e6e9ed"];
    self.nearLine.backgroundColor = [Tools getColor:@"fc6e51"];
    self.latestLine.backgroundColor = [Tools getColor:@"e6e9ed"];
    
    // 约束调整
    self.hotConstraint.constant = 1;
    self.nearConstraint.constant = 0;
    self.lastestConstraint.constant = 1;
    
    // 获取经纬度和城市
//    [self getLongitudeAndLatitude];
    [self setupLoadStatusWithIgnore:0 Key:@"nearby" SelectModel:nil];
//     NSLog(@"self.myCity=%@ %f %f",self.myCity,self.latitude,self.longitude);
    
    
    self.selectMark = @"nearby";
    
    
  
}

// 最新按钮点击
- (IBAction)lastestBtnClick:(id)sender {
    // 按钮颜色
    [self.hotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.lastestBtn setTitleColor:[Tools getColor:@"fc6e51"] forState:UIControlStateNormal];
    
    // 底边颜色
    self.hotLine.backgroundColor = [Tools getColor:@"e6e9ed"];
    self.nearLine.backgroundColor = [Tools getColor:@"e6e9ed"];
    self.latestLine.backgroundColor = [Tools getColor:@"fc6e51"];
    
    
    // 约束调整
    self.hotConstraint.constant = 1;
    self.nearConstraint.constant = 1;
    self.lastestConstraint.constant = 0;
    
    self.myCity = @"";
    
    [self setupLoadStatusWithIgnore:0 Key:@"latest" SelectModel:nil];
    self.selectMark = @"latest";
}



// 蒙版按钮点击
- (void)coverBtnClick
{
    [self.selectView dismissWithCompletion:nil];
}

#pragma mark - CPSelectDelegate
- (void)selectView:(CPSelectView *)selectView finishBtnClick:(CPSelectViewModel *)result
{
    [selectView dismissWithCompletion:nil];
    
    // 根据result中的参数 重新发送请求 刷新表格 reloadData
//    NSLog(@"%@",[result keyValues]);
    
    [self setupLoadStatusWithIgnore:0 Key:@"hot" SelectModel:result];
}

- (void)selectViewCancleBtnClick:(CPSelectView *)selectView
{
    [selectView dismissWithCompletion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.coverBtn) {
        self.coverBtn.hidden = YES;
    }
}
//点击我要玩
- (IBAction)goToPlay:(UIButton *)sender {
    
    [SVProgressHUD showWithStatus:@"努力加载中"];
    CPHomeStatus *model = self.status[sender.tag];
    NSString *activeId = model.activityId;
    self.activeId = activeId;
    //登陆状态下可点 拿出创建者字段,非登陆 自动跳转登陆界面
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/info",self.activeId];
    [CPNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self disMiss];
        if ([responseObject operationSuccess]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            NSString *strOrganizer = [formatter stringFromNumber:responseObject[@"data"][@"isOrganizer"]];
            NSString *strMember = [formatter stringFromNumber:responseObject[@"data"][@"isMember"]];
            NSString *userId = [Tools getValueFromKey:@"userId"];
            SQLog(@"%@",userId);
            SQLog(@"%@",strMember);
            SQLog(@"%@",self.activeId);
            //根据isOrganizer判断进入那个界面
            if ([strOrganizer isEqualToString:@"1"]) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
                
                MembersManageController * vc = sb.instantiateInitialViewController;
                vc.activityId = self.activeId;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if ([strMember isEqualToString:@"1"]){
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
                MembersController * vc = sb.instantiateInitialViewController;
                vc.activityId = self.activeId;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
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
                            UIButton * offerButton = (UIButton *)[carView viewWithTag:3000];
                            UITextField * carxibTextFeild = (UITextField *)[carView viewWithTag:4000];
                            self.carxibTextFeild = carxibTextFeild;
                            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
                            [carView addGestureRecognizer:tap];
                            [offerButton addTarget:self action:@selector(offerSeatButton) forControlEvents:UIControlEventTouchUpInside];
                            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                            int maxSeat = [[formatter stringFromNumber:responseObject[@"data"][@"maxValue"]] intValue];
                            int minSeat = [[formatter stringFromNumber:responseObject[@"data"][@"minValue"]] intValue];
                            [self.pickerArray removeAllObjects];
                            for (int i = minSeat; i <= maxSeat; i++) {
                                NSString *seat = [NSString stringWithFormat:@"%tu",i];
                                [self.pickerArray addObject:seat];
                            }
                            UIPickerView *picker = [[UIPickerView alloc]init];
                            picker.delegate = self;
                            picker.dataSource = self;
                            self.carxibTextFeild.inputView = picker;
                            self.carxibTextFeild.delegate = self;
                            self.carxibTextFeild.font = [AppAppearance textMediumFont];
                            self.carxibTextFeild.textColor = [AppAppearance textDarkColor];
                            [self tap:yeButton];
                            
                        } else {
                            NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/join",self.activeId];
                            [CPNetWorkTool postJsonWithUrl:urlStr params:nil success:^(id responseObject) {
                                if ([responseObject operationSuccess]) {
                                    [self.view alert:@"请求成功,等待同意"];
                                } else {
                                    [self.view alertError:responseObject];
                                }
                            } failed:^(NSError *error) {
                                [self.view alertError:error];
                            }];
                            
                            
                            
                        }
                        
                    } else {
                        [self.view alertError:responseObject];
                    }
                } failure:^(NSError *error) {
                    [self.view alertError:error];
                }];
                
                
            }
            
        } else {
            [self.view alertError:responseObject];
        }
        
    } failure:^(NSError *error) {
        [self.view alertError:error];
    }];

    
    
}
- (void)tap:(UIButton *)btn{
    btn = self.btn;
    if (btn == self.yesButton) {
        self.btn = self.noButton;
        self.yesButton.selected = YES;
        self.noButton.selected = NO;
        self.carxibTextFeild.enabled = YES;
        [self.carxibTextFeild becomeFirstResponder];
    } else {
        self.btn = self.yesButton;
        self.noButton.selected = YES;
        self.yesButton.selected = NO;
        self.carxibTextFeild.enabled = NO;
        [self.carxibTextFeild resignFirstResponder];
        self.carxibTextFeild.text = nil;
    }
    
    
    
}
//点击提交
- (void)offerSeatButton {
    
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
            [self.view alert:@"请求成功,等待同意"];
        } else {
            [self.view alertError:responseObject];
        }
    } failed:^(NSError *error) {
        [self.view alertError:error];
    }];
    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.carxibTextFeild.text = [NSString stringWithFormat:@"%@",self.pickerArray[row]];
}


- (void)coverClick {
    [_cover removeFromSuperview];
    _cover = nil;
    
    [_carView removeFromSuperview];
    _carView = nil;

}
#pragma mark - lazy
- (NSMutableArray *)pickerArray {
    if (!_pickerArray) {
        _pickerArray = [[NSMutableArray alloc]init];
    }
    return _pickerArray;
}

@end
