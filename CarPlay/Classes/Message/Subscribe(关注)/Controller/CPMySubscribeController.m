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
    
    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
        self.navigationItem.title = @"我的关注";
    }else{
        self.navigationItem.title = @"他的关注";
    }
    
    self.tableView.allowsSelection = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)reRefreshData
{
    [self loadData];
}

- (void)loadData
{
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/subscribe",[Tools getValueFromKey:@"userId"]];
    
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [CPNetWorkTool getWithUrl:url params:nil success:^(id responseObject) {
        if (CPSuccess) {
            NSArray *data = [CPMySubscribeModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (data.count > 0) {
                [self.frameModels removeAllObjects];
                for (CPMySubscribeModel *model in data) {
                    CPMySubscribeFrameModel *frameModel = [[CPMySubscribeFrameModel alloc] init];
                    frameModel.model = model;
                    [self.frameModels addObject:frameModel];
                }
            }
            [self disMiss];
            if (self.frameModels.count > 0) {
                [self.tableView reloadData];
            }else{
                [self showNoSubscribe];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
