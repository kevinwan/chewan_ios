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
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor redColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    header.autoChangeAlpha = YES;
    self.tableView.header = header;
    
    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
        self.navigationItem.title = @"我的发布";
    }else{
        self.navigationItem.title = @"他的发布";
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
}

- (void)reRefreshData
{
    [self loadData];
}

- (void)loadData
{
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/post",self.hisUserId];
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [CPNetWorkTool getWithUrl:url params:nil success:^(NSDictionary *responseObject) {
        [self.tableView.header endRefreshing];
        if (CPSuccess) {
            [SVProgressHUD dismiss];
            NSArray *arr = [CPMyPublishModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (arr.count > 0) {
                [self.frameModels removeAllObjects];
                for (int i = 0; i < arr.count; i++) {
                    CPMyPublishFrameModel *frameModel = [[CPMyPublishFrameModel alloc] init];
                    frameModel.model = arr[i];
                    [self.frameModels addObject:frameModel];
                }
                
            }
            if (self.frameModels.count > 0) {
                [self.tableView reloadData];
            }else{
                [self showNoPublish];
            }
        }else{
            [self showInfo:@"加载失败"];
            [self showNetWorkFailed];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
        [self showError:@"加载失败"];
        [self showNetWorkOutTime];
    }];

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
