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


@interface CPCityController ()<UITableViewDataSource,UITableViewDelegate, CPSelectViewDelegate>

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
@property (nonatomic,assign) double *longitude;

// 纬度
@property (nonatomic,assign) double *latitude;

// 筛选信息类
@property (nonatomic,strong) CPSelectViewModel *selectViewModel;

// 蒙板遮罩
@property (nonatomic,strong) UIButton *coverBtn;

// 蒙板遮罩
@property (nonatomic,strong) CPSelectView *selectView;

// 存储所有活动数据
@property (nonatomic,strong) NSMutableArray *status;

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


@end

@implementation CPCityController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取用户经纬度和城市
    

    // 加载活动数据
    [self setupLoadStatusWithIgnore:0 Key:self.selectMark SelectModel:nil];
    
    // 添加下拉刷新控件（头部）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownLoadData)];
    
    // 添加上拉刷新控件（底部）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upglideLoadData)];
    
    
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
//    parameters[@"limit"] = @(10);

    parameters[@"city"] = @"南京";
    if (self.userId != nil) {
        parameters[@"userId"] = self.userId;
    }
    if (self.token != nil) {
        parameters[@"token"] = self.token;
    }
    
    if (selectModel.gender != nil) {
        parameters[@"gender"] = selectModel.gender;
    }
    
    if (selectModel.city != nil) {
        parameters[@"city"] = selectModel.city;
    }
    
    if (selectModel.district != nil) {
        parameters[@"district"] = selectModel.district;
    }
    
    if (selectModel.authenticate >= 0) {
        parameters[@"authenticate"] = @(selectModel.authenticate);
    }
    
    if (selectModel.type) {
        parameters[@"type"] = selectModel.type;
    }
    
    if (selectModel.carLevel) {
        parameters[@"carLevel"] = selectModel.carLevel;
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
        [SVProgressHUD showWithStatus:@"获取用户信息失败"];
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
- (UIButton *)coverBtn
{
    if (_coverBtn == nil) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        _coverBtn.frame = self.view.bounds;
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

// 上拉刷新条数
- (NSInteger)ignoreNum{
    if (!_ignoreNum) {
        _ignoreNum = CPPageNum;
    }
    return _ignoreNum;
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



#pragma mark - 按钮点击事件
// 创建活动
- (IBAction)createActive:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPCreatActivityController" bundle:nil];
    
    [self.navigationController pushViewController:sb.instantiateInitialViewController animated:YES];
    
    
}

// 筛选
- (IBAction)select:(id)sender {
    
    if (self.coverBtn.hidden) {
        
        self.coverBtn.hidden = NO;
        
        CPSelectView *selectView = [CPSelectView selectView];
        selectView.delegate = self;
        [selectView showWithView:self.coverBtn];
        
        self.selectView = selectView;
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
    
    [self setupLoadStatusWithIgnore:0 Key:@"nearby" SelectModel:nil];
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
    NSLog(@"%@",[result keyValues]);
    
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

@end
