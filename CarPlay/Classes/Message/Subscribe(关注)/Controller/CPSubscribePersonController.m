//
//  CPSubscribePersonController.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSubscribePersonController.h"
#import "CPSubscribeCell.h"
#import "CPMySubscribeController.h"
#import "CPMySubscribeModel.h"
#import "CPTaDetailsController.h"

@interface CPSubscribePersonController ()
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation CPSubscribePersonController

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我关注的人";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.ignore = 0;
        [weakSelf loadDataWithParam:0];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.ignore = weakSelf.datas.count;
        [weakSelf loadDataWithParam:weakSelf.ignore];
    }];
    
    self.tableView.footer.hidden = YES;
    ZYJumpToLoginView
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CPNotificationCenter addObserver:self selector:@selector(userIconClick:) name:CPClickUserIconNotification object:nil];
    
    [CPNotificationCenter addObserver:self selector:@selector(cancleSubscribe:) name:CPCancleSubscribeNotify object:nil];
    
    [self reRefreshData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CPNotificationCenter removeObserver:self];
}

- (void)reRefreshData
{
    if (self.datas.count == 0) {
        [self showLoading];
        [self loadDataWithParam:0];
    }
}

- (void)loadDataWithParam:(NSInteger)ignore
{
    NSString *userId = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    if (!userId.length) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self disMiss];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/listen",userId];
    [ZYNetWorkTool getWithUrl:url params:@{@"token" : token,@"ignore" : @(ignore)} success:^(id responseObject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self disMiss];
        if (CPSuccess) {
            NSArray *arr = [CPOrganizer objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.ignore == 0) {
                [self.tableView.footer resetNoMoreData];
                [self.datas removeAllObjects];
            }
            if (arr.count) {
                [self.datas addObjectsFromArray:arr];
                [self.tableView reloadData];
            }else{
                if (self.datas.count > 0) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }

            if (self.datas.count == 0) {
                [self showNoSubscribePerson];
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
        [self.datas removeAllObjects];
        [self.tableView reloadData];
        [self showNetWorkOutTime];
    }];
}

- (void)cancleSubscribe:(NSNotification *)notify
{
    NSUInteger row = [notify.userInfo[CPCancleSubscribeInfo] intValue];
    if (self.datas.count > 0) {
        [self showSuccess:@"取消成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.datas removeObjectAtIndex:row];
            if (self.datas.count) {
                [self.tableView reloadData];
            }else{
                [self showNoSubscribePerson];
            }
        });
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"MySubscribePersonCell";
    
    CPSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.row = indexPath.row;
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)userIconClick:(NSNotification *)notify
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    vc.targetUserId = notify.userInfo[CPClickUserIconInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    CPOrganizer *orz = self.datas[indexPath.row];
    vc.targetUserId = orz.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
