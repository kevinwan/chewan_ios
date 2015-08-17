//
//  CPTaDetailsController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPTaDetailsController.h"
#import "AFNetworking.h"
#import "CPTaPublishStatus.h"
#import "CPTaDetailsStatus.h"
#import "CPTaPhoto.h"
#import "MJExtension.h"
#import "CPTaPublishCell.h"
#import "CPTaDetailsHead.h"
#import "CPTaNoData.h"
#import "CPHomeStatusCell.h"
#import "CPHomeStatus.h"

@interface CPTaDetailsController ()

// 用户id
@property (nonatomic,copy) NSString *userId;

// 用户token
@property (nonatomic,copy) NSString *token;

// 上滑加载条数
@property (nonatomic,assign) NSInteger ignoreNum;

// 存储所有他详情页的数据
@property (nonatomic,strong) CPTaDetailsStatus *taStatus;

// 存储发布内容数据
@property (nonatomic,strong) NSMutableArray *taPubStatus;

// 缓存cell高度（线程安全、内存紧张时会自动释放、不会拷贝key）
@property (nonatomic,strong) NSCache *rowHeightCache;
@property (nonatomic,strong) NSCache *otherRowHeightCache;

// 三种状态
@property (nonatomic,copy) NSString *threeStates;

@end

@implementation CPTaDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载他的详情页面数据
    [self setupLoadTaStatus];
    
    // 加载他的发布
    [self setupLoadTaPublishStatusWithIgnore:0 SelectStr:@"post"];
    
    // 页面标题
    self.title = @"TA的详情";
    
    // 上拉下拉刷新
    [self topAndBottomRefresh];
    
    
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
//    footer.automaticallyHidden = NO;
    footer.stateLabel.textColor = [Tools getColor:@"aab2bd"];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateNoMoreData];
    
    self.tableView.footer = footer;
}


// 下拉刷新
- (void)dropDownLoadData{
    
    // 计数清零
    self.ignoreNum = 0;
    
    // 刷新他的详情
    [self setupLoadTaStatus];
    
    if ([self.threeStates isEqualToString:@"post"]) {
        [self setupLoadTaPublishStatusWithIgnore:0 SelectStr:@"post"];
    }else if ([self.threeStates isEqualToString:@"join"]){
        [self setupLoadTaPublishStatusWithIgnore:0 SelectStr:@"join"];
    }else{
        [self setupLoadTaPublishStatusWithIgnore:0 SelectStr:@"subscribe"];
    }
    
}

// 上滑
- (void)upglideLoadData{
    self.ignoreNum += CPPageNum;
    
    if ([self.threeStates isEqualToString:@"post"]) {
        [self setupLoadTaPublishStatusWithIgnore:self.ignoreNum SelectStr:@"post"];
    }else if ([self.threeStates isEqualToString:@"join"]){
        [self setupLoadTaPublishStatusWithIgnore:self.ignoreNum SelectStr:@"join"];
    }else{
        [self setupLoadTaPublishStatusWithIgnore:self.ignoreNum SelectStr:@"subscribe"];
    }
}

- (void)setupLoadHeadView{
    CPTaDetailsHead *head = [CPTaDetailsHead headView];
    head.taStatus = self.taStatus;
    __weak typeof(self) weakSelf = self;
    head.statusSelected = ^(NSInteger ignore,NSString *selectStr){
        [weakSelf setupLoadTaPublishStatusWithIgnore:ignore SelectStr:selectStr];
    };
    self.tableView.tableHeaderView = head;
}


// 加载他的详情页面数据
- (void)setupLoadTaStatus{
    
    // 设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (self.userId != nil) {
        parameters[@"userId"] = self.userId;
    }
    if (self.token != nil) {
        parameters[@"token"] = self.token;
    }
    
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *getUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/user/%@/info",self.targetUserId];
    
    
    // 发送请求
    [manager GET:getUrl parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        
        
        // 字典转模型
        self.taStatus = [CPTaDetailsStatus objectWithKeyValues:responseObject[@"data"]];
        
        // 加载headview
        [self setupLoadHeadView];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //
    }];
    
}


// 加载他的详情发布
- (void)setupLoadTaPublishStatusWithIgnore:(NSInteger)ignore SelectStr:(NSString *)selectStr{
    
    self.threeStates = selectStr;
    
    // 设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"ignore"] = @(ignore);
    
    if (self.userId != nil) {
        parameters[@"userId"] = self.userId;
    }
    if (self.token != nil) {
        parameters[@"token"] = self.token;
    }
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *getUrl = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/v1/user/%@/%@",self.targetUserId,selectStr];
    
    // 发送请求
    [manager GET:getUrl parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        
        // 去出他发布的数据
        NSArray *taPubArr = responseObject[@"data"];
        
        NSLog(@"%@",responseObject[@"data"]);
        
        // 字典数组转模型数组
        NSArray *models = [CPTaPublishStatus objectArrayWithKeyValuesArray:taPubArr];
        
        if (!ignore) {
            [self.taPubStatus removeAllObjects];
            [self.taPubStatus addObjectsFromArray:models];
        }else{
            [self.taPubStatus addObjectsFromArray:models];
        }
        
        // 如果返回数据为空，则显示无数据footerView
        if (self.taPubStatus.count == 0) {
            CPTaNoData *noData = [CPTaNoData footerView];
            __weak typeof(self) weakSelf = self;
            noData.publishRightNow = ^{
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPCreatActivityController" bundle:nil];
                
                [weakSelf.navigationController pushViewController:sb.instantiateInitialViewController animated:YES];
            };
            if ([selectStr isEqualToString:@"post"]) {
                noData.pictureName = @"暂无发布";
                noData.titleName = @"他还没有发布活动噢~";
                noData.isShowBtn = YES;
            }else if([selectStr isEqualToString:@"subscribe"]){
                noData.pictureName = @"暂无收藏";
                noData.titleName = @"他还没有收藏活动噢~";
                noData.isShowBtn = NO;
            }else{
                noData.pictureName = @"暂无参与";
                noData.titleName = @"他还没有参与活动噢~";
                noData.isShowBtn = NO;
            }
            self.tableView.tableFooterView = noData;
        }else{
            self.tableView.tableFooterView = nil;
        }
        
        // 刷新tableview
        [self.tableView reloadData];
        
        
        // 关闭下拉刷新
        [self.tableView.header endRefreshing];
        
        // 关闭上拉刷新
        [self.tableView.footer endRefreshing];

    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //
    }];
}



#pragma mark - 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taPubStatus.count;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if ([self.threeStates isEqualToString:@"post"]) {
        // 创建cell
        CPTaPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPTaPublishCell identifier]];
        
        //第一行处理
        if (indexPath.row == 0) {
            cell.isFirst = YES;
        }else{
            cell.isFirst = NO;
        }
        
        // 设置数据
        cell.publishStatus = self.taPubStatus[indexPath.row];
        
        return cell;
    }else{
        CPHomeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPHomeStatusCell identifier]];
    
    
        cell.status = self.taPubStatus[indexPath.row];
        
        return cell;
    }
    
}




// 计算cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出对应行模型
    CPTaPublishStatus *status = self.taPubStatus[indexPath.row];
    
    // 先从缓存中获取高度，没有才计算
    if ([self.threeStates isEqualToString:@"post"]) {
        NSNumber *rowHeight = [self.rowHeightCache objectForKey:status.activityId];
        CGFloat cellHeight = [rowHeight doubleValue];
        
        if (rowHeight == nil) {
            
            // 取出cell
            CPTaPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPTaPublishCell identifier]];
            
            // 获取高度
            cellHeight = [cell cellHeightWithTaPublishStatus:status];
            
            // 缓存每一行的高度
            [self.rowHeightCache setObject:@(cellHeight) forKey:status.activityId];
        }
        
        // 设置高度
        return cellHeight;

    }else{
        
        NSNumber *rowHeight = [self.otherRowHeightCache objectForKey:status.activityId];
        CGFloat cellHeight = [rowHeight doubleValue];
        
        if (rowHeight == nil) {
            
            // 取出cell
            CPHomeStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPHomeStatusCell identifier]];
            
            CPHomeStatus *homeStatus = [[CPHomeStatus alloc] init];
            homeStatus.activityId = status.activityId;
            homeStatus.introduction = status.introduction;
            homeStatus.publishTime = status.publishTime;
            homeStatus.start = status.start;
            homeStatus.location = status.location;
            homeStatus.totalSeat = status.totalSeat;
            homeStatus.holdingSeat = status.holdingSeat;
            homeStatus.pay = status.pay;
            homeStatus.type = status.type;
            homeStatus.isOrganizer = status.isOrganizer;
            homeStatus.isMember = status.isMember;
            homeStatus.organizer = status.organizer;
            homeStatus.cover = status.cover;
            homeStatus.members = status.members;

            // 获取高度
            cellHeight = [cell cellHeightWithStatus:homeStatus];
            
            // 缓存每一行的高度
            [self.otherRowHeightCache setObject:@(cellHeight) forKey:status.activityId];
        }
        
        // 设置高度
        return cellHeight;

    }
    
}


// 预估每一行cell的高度，可提高性能（只计算可是区域的cell）
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

#pragma mark - lazy(懒加载)

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

// 他的详情数据
- (NSMutableArray *)taPubStatus{
    if (!_taPubStatus) {
        _taPubStatus = [NSMutableArray array];
    }
    return _taPubStatus;
}

// 三种状态
- (NSString *)threeStates{
    if (!_threeStates) {
        _threeStates = @"post";
    }
    return _threeStates;
}

@end
