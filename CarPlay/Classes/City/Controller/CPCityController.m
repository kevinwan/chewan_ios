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


@interface CPCityController ()<UITableViewDataSource,UITableViewDelegate>

// 存储所有活动数据
@property (nonatomic,strong) NSArray *status;

// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 缓存cell高度（线程安全、内存紧张时会自动释放、不会拷贝key）
@property (nonatomic,strong) NSCache *rowHeightCache;

@end

@implementation CPCityController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 加载活动数据
    [self setupLoadStatus];
    
}


// 加载活动数据
- (void)setupLoadStatus{
    
    // 封装请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"key"] = @"hot";
    parameters[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
    parameters[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    parameters[@"city"] = @"南京";
    
    
    // 获取网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 发送请求
    [manager GET:@"http://cwapi.gongpingjia.com/v1/activity/list" parameters:parameters success:^(NSURLSessionDataTask * task, id responseObject) {
        // 取出活动数据
//        self.status = responseObject[@"data"];
//        NSLog(@"%@",self.status);
        
        // 取出活动数据
        NSArray *dicts = responseObject[@"data"];
        
        // 转换为模型
        self.status = [CPHomeStatus objectArrayWithKeyValuesArray:dicts];
          
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //
        NSLog(@"%@",@"失败");
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
    
//    NSLog(@"%@",ac.activeId);
    
    [self.navigationController pushViewController:ac animated:YES];
    
}


#pragma mark - lazy

- (NSCache *)rowHeightCache{
    if (!_rowHeightCache) {
        _rowHeightCache = [[NSCache alloc] init];
    }
    return _rowHeightCache;
}


@end
