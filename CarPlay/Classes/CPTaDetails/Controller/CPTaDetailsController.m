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

@interface CPTaDetailsController ()

// 存储所有他详情页的数据
@property (nonatomic,strong) CPTaDetailsStatus *taStatus;

// 存储发布内容数据
@property (nonatomic,strong) NSArray *taPubStatus;

// 缓存cell高度（线程安全、内存紧张时会自动释放、不会拷贝key）
@property (nonatomic,strong) NSCache *rowHeightCache;

@end

@implementation CPTaDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载他的详情页面数据
    [self setupLoadTaStatus];
    
    // 加载他的发布
    [self setupLoadTaPublishStatus];
    
   
    
}


- (void)setupLoadHeadView{
    CPTaDetailsHead *head = [CPTaDetailsHead headView];
    head.taStatus = self.taStatus;
    self.tableView.tableHeaderView = head;
}


// 加载他的详情页面数据
- (void)setupLoadTaStatus{
    
    // 设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    // 发送请求
    [manager GET:@"http://cwapi.gongpingjia.com/v1/user/846de312-306c-4916-91c1-a5e69b158014/info" parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        

        NSLog(@"%@",responseObject[@"data"]);
        
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
- (void)setupLoadTaPublishStatus{
    // 设置请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    
    
    // 获取网络访问者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    // 发送请求
    [manager GET:@"http://cwapi.gongpingjia.com/v1/user/846de312-306c-4916-91c1-a5e69b158014/post" parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        // 去出他发布的数据
        NSArray *taPubArr = responseObject[@"data"];
        
        // 字典数组转模型数组
        self.taPubStatus = [CPTaPublishStatus objectArrayWithKeyValuesArray:taPubArr];
        
//         [self setupLoadHeadView];
        
        // 刷新tableview
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //
    }];
}



#pragma mark - 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taPubStatus.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 创建cell
    CPTaPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:[CPTaPublishCell identifier]];
    
    // 第一行处理
    if (indexPath.row == 0) {
        cell.isFirst = YES;
    }else{
        cell.isFirst = NO;
    }
    
    // 设置数据
    cell.publishStatus = self.taPubStatus[indexPath.row];
    

    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取出对应行模型
    CPTaPublishStatus *status = self.taPubStatus[indexPath.row];
    
    // 先从缓存中获取高度，没有才计算
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
    
}


// 预估每一行cell的高度，可提高性能（只计算可是区域的cell）
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

#pragma mark - lazy

- (NSCache *)rowHeightCache{
    if (!_rowHeightCache) {
        _rowHeightCache = [[NSCache alloc] init];
    }
    return _rowHeightCache;
}

@end
