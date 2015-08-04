//
//  ActivityApplyControllerView.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivityApplyControllerView.h"
#import "CPActivityApplyCell.h"
#import "CPSubscribePersonController.h"
#import "CPActivityApplyModel.h"
#import "MJRefresh.h"
#import "CPActiveDetailsController.h"

#define ActivityMsgData @"ActivityMsgData"

@interface CPActivityApplyControllerView ()
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation CPActivityApplyControllerView

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(ActivityMsgData)];
        if (_datas == nil) {
            _datas = [NSMutableArray array];
        }
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动消息";
  
    self.tableView.tableFooterView = [[UIView alloc] init];
    [CPNotificationCenter addObserver:self selector:@selector(agreeBtnClick:) name:CPActivityApplyNotification object:nil];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadData];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reRefreshData)];
}

- (void)reRefreshData
{
    [self loadData];
}

- (void)loadData
{
    if (CPUnLogin) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    
    NSString *userId = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/message/list?token=%@&type=application",userId, token];
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [ZYNetWorkTool getWithUrl:url params:nil success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        [self disMiss];
        DLog(@"%@",responseObject);
        if (CPSuccess) {
            NSArray *data = [CPActivityApplyModel objectArrayWithKeyValuesArray:responseObject[@"data"]];

            [self.datas addObjectsFromArray:data];
            
            if (data.count == 0) {
                [self showNoData];
                return;
            }
    
            [self.tableView reloadData];
            
            // 异步存储数据
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSKeyedArchiver archiveRootObject:self.datas toFile:CPDocmentPath(ActivityMsgData)];
            });
            
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)agreeBtnClick:(NSNotification *)notify
{
    [self showSuccess:@"已同意"];
    NSUInteger row = [notify.userInfo[CPActivityApplyInfo] intValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 异步存储数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSKeyedArchiver archiveRootObject:self.datas toFile:CPDocmentPath(ActivityMsgData)];
    });
}

- (void)dealloc
{
    [CPNotificationCenter removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID1 = @"ActivityApplyCell";
    static NSString *ID2 = @"ActivityMsgCell";
    
    CPActivityApplyModel *model = self.datas[indexPath.row];
    CPActivityApplyCell *cell = nil;
    if ([model.type isEqualToString:@"活动申请处理"]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:ID2];
    }
    
    cell.row = indexPath.row;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPActivityApplyModel *model = self.datas[indexPath.row];
    
    // 如果有activityId,直接跳转到活动详情页面
    if (model.activityId.length) {
        CPActiveDetailsController *activityVc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil].instantiateInitialViewController;;
        activityVc.activeId = model.activityId;
        
        [self.navigationController pushViewController:activityVc animated:YES];
    }
    
}

@end
