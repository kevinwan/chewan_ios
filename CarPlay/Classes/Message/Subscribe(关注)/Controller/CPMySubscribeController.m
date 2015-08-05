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

@interface CPMySubscribeController ()
@property (nonatomic, strong) NSMutableArray *frameModels;
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
    self.navigationItem.title = @"我的关注";
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
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.ignore += CPPageNum;
        [weakSelf loadDataWithParam:weakSelf.ignore];
    }];
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.tableView.footer.ignoredScrollViewContentInsetTop = 30;
    
    ZYJumpToLoginView // 跳转到登陆界面
    [self reRefreshData];
}

- (void)reRefreshData
{
    [self showLoading];
    [self loadDataWithParam:0];
}

- (void)loadDataWithParam:(NSInteger)ignore
{
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/subscribe",[Tools getValueFromKey:@"userId"]];
    
    [CPNetWorkTool getWithUrl:url params:@{@"ignore" : @(ignore)} success:^(id responseObject) {
        [self disMiss];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        if (CPSuccess) {
            NSArray *data = [CPMySubscribeModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.ignore == 0) {
                [self.frameModels removeAllObjects];
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
                    [self showInfo:@"暂无更多数据"];
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
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [self showNetWorkOutTime];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CPNotificationCenter addObserver:self selector:@selector(userIconClick:) name:CPClickUserIconNotification object:nil];
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
    cell.frameModel = self.frameModels[indexPath.row];
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

- (void)userIconClick:(NSNotification *)notify
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    vc.targetUserId = notify.userInfo[CPClickUserIconInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
