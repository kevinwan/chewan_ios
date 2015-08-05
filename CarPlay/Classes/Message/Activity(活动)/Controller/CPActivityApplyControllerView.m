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
#import "CPTaDetailsController.h"

#define ActivityMsgData @"ActivityMsgData"

@interface CPActivityApplyControllerView ()
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation CPActivityApplyControllerView

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动消息";
  
    
    [CPNotificationCenter addObserver:self selector:@selector(agreeBtnClick:) name:CPActivityApplyNotification object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(userIconClick:) name:CPClickUserIconNotification object:nil];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.ignore = 0;
        [weakSelf loadDataWithParam:0];
    }];
    
    self.tableView.footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.ignore += CPPageNum;
        [weakSelf loadDataWithParam:weakSelf.ignore];
    }];
    ZYJumpToLoginView
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
    NSString *token = [Tools getValueFromKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/message/list?token=%@&type=application",userId, token];
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [ZYNetWorkTool getWithUrl:url params:@{@"ignore" : @(ignore)} success:^(id responseObject) {
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [self disMiss];
        if (CPSuccess) {
            
            if (self.ignore == 0) {
                [self.datas removeAllObjects];
            }
            NSArray *data = [CPActivityApplyModel objectArrayWithKeyValuesArray:responseObject[@"data"]];

            if (data.count) {
                [self.datas addObjectsFromArray:data];
                [self.tableView reloadData];
            }else{
                if (self.datas.count > 0) {
                    [self showInfo:@"暂无更多数据"];
                }
            }
            if (self.datas.count == 0) {
                [self showNoData];
            }
        }else if (self.datas.count == 0){
            [self showNetWorkFailed];
        }
    } failure:^(NSError *error) {
        [self disMiss];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self showNetWorkOutTime];
    }];
}

- (void)agreeBtnClick:(NSNotification *)notify
{
    [self showSuccess:@"已同意"];
    NSUInteger row = [notify.userInfo[CPActivityApplyInfo] intValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

- (void)userIconClick:(NSNotification *)notify
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    vc.targetUserId = notify.userInfo[CPClickUserIconInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
