//
//  CPMyJoinController.m
//  CarPlay
//
//  Created by chewan on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyJoinController.h"
#import "CPMySubscribeModel.h"
#import "CPMySubscribeCell.h"
#import "CPMySubscribeFrameModel.h"
#import "CPActiveDetailsController.h"
#import "CPTaDetailsController.h"

@interface CPMyJoinController ()
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation CPMyJoinController

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
        self.navigationItem.title = @"我的参与";
    }else{
        self.navigationItem.title = @"他的参与";
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.ignore = 0;
        [weakSelf loadDataWithParam:0];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.ignore = self.datas.count;
        [weakSelf loadDataWithParam:weakSelf.ignore];
    }];
    
    self.tableView.footer.hidden = YES;
    ZYJumpToLoginView
    [self reRefreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CPNotificationCenter addObserver:self selector:@selector(userIconClick:) name:CPClickUserIconNotification object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(chatButtonClick:) name:ChatButtonClickNotifyCation object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CPNotificationCenter removeObserver:self];
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
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/join",userId];
    [CPNetWorkTool getWithUrl:url params:@{@"ignore" : @(ignore)} success:^(id responseObject) {
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (CPSuccess) {
            NSArray *data = [CPMySubscribeModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            if (self.ignore == 0) {
                [self.datas removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            
            if (data.count) {
                for (CPMySubscribeModel *model in data) {
                    CPMySubscribeFrameModel *frameModel = [[CPMySubscribeFrameModel alloc] init];
                    frameModel.model = model;
                    [self.datas addObject:frameModel];
                }
                [self.tableView reloadData];

            }else{
                if (self.datas.count) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            if (self.datas.count == 0) {
                [self showNoJoin];
            }
        }else if (self.datas.count == 0){
            [self showNetWorkFailed];
        }
    } failure:^(NSError *error) {
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self showNetWorkOutTime];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMySubscribeCell *cell = [CPMySubscribeCell cellWithTableView:tableView];
    
    cell.frameModel = self.datas[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMySubscribeFrameModel *frameModel = self.datas[indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到活动详情界面
    CPActiveDetailsController *activityDetailVc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil ].instantiateInitialViewController;
    CPMySubscribeFrameModel *frameModel = self.datas[indexPath.row];
    activityDetailVc.activeId = frameModel.model.activityId;
    [self.navigationController pushViewController:activityDetailVc animated:YES];
}

- (void)userIconClick:(NSNotification *)notify
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    vc.targetUserId = notify.userInfo[CPClickUserIconInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatButtonClick:(NSNotification *)notify
{
    CPMySubscribeModel *model = notify.userInfo[ChatButtonClickInfo];
    
    
}

@end
