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

    [self loadData];
}

- (void)reRefreshData
{
    [self loadData];
}

- (void)loadData
{
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/join",[Tools getValueFromKey:@"userId"]];
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [CPNetWorkTool getWithUrl:url params:nil success:^(id responseObject) {
        if (CPSuccess) {
            [self disMiss];
            NSArray *data = [CPMySubscribeModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for (CPMySubscribeModel *model in data) {
                CPMySubscribeFrameModel *frameModel = [[CPMySubscribeFrameModel alloc] init];
                frameModel.model = model;
                [self.datas addObject:frameModel];
            }
            if (self.datas.count > 0) {
                [self.tableView reloadData];
            }else{
                [self showNoJoin];
            }
        }else{
            [self showInfo:@"加载失败"];
            [self showNetWorkFailed];
        }
    } failure:^(NSError *error) {
        [self showError:@"加载失败"];
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

@end
