//
//  CPMyPublishController.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyPublishController.h"
#import "CPMyPublishFrameModel.h"
#import "CPMyPublishModel.h"
#import "MJExtension.h"
#import "CPMyPublishCell.h"
#import "CPActiveDetailsController.h"
#import "MJRefresh.h"

@interface CPMyPublishController ()
@property (nonatomic, strong) NSMutableArray *frameModels;
@end

@implementation CPMyPublishController

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
//    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
        self.navigationItem.title = @"我的发布";
//    }else{
//        self.navigationItem.title = @"他的发布";
//    }
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.ignore = 0;
        [weakSelf loadDataWithParams:0];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.ignore += CPPageNum;
        [weakSelf loadDataWithParams:weakSelf.ignore];
    }];
//    // 设置了底部inset
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
//   //  忽略掉底部inset
//    self.tableView.footer.ignoredScrollViewContentInsetTop = 30;
//    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.footer.hidden = YES;
    ZYJumpToLoginView
    [self reRefreshData];
}

- (void)reRefreshData
{
    [self showLoading];
    [self loadDataWithParams:0];
}

- (void)loadDataWithParams:(NSUInteger)ignore
{
    if (!self.hisUserId.length) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self disMiss];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/post",self.hisUserId];
    [CPNetWorkTool getWithUrl:url params:@{@"ignore" : @(ignore)} success:^(NSDictionary *responseObject) {
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (CPSuccess) {
            NSArray *arr = [CPMyPublishModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.ignore == 0) {
                [self.frameModels removeAllObjects];
            }
            if (arr.count) {
                for (int i = 0; i < arr.count; i++) {
                    CPMyPublishFrameModel *frameModel = [[CPMyPublishFrameModel alloc] init];
                    frameModel.model = arr[i];
                    [self.frameModels addObject:frameModel];
                }
                [self.tableView reloadData];
            }else{
                if (self.frameModels.count > 0) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            if (self.frameModels.count == 0) {
                [self showNoPublish];
            }
        }else{
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

- (void)dealloc
{
    DLog(@"silekljkl");
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frameModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMyPublishCell *cell = [CPMyPublishCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.frameModel = self.frameModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMyPublishFrameModel *frameModel = self.frameModels[indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到活动详情界面
    CPActiveDetailsController *activityDetailVc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil ].instantiateInitialViewController;
    CPMyPublishFrameModel *frameModel = self.frameModels[indexPath.row];
    activityDetailVc.activeId = frameModel.model.activityId;
    [self.navigationController pushViewController:activityDetailVc animated:YES];
}

@end
