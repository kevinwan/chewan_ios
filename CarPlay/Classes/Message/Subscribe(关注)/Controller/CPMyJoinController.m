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
    
    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
        self.navigationItem.title = @"我的参与";
    }else{
        self.navigationItem.title = @"他的参与";
    }
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/join",[Tools getValueFromKey:@"userId"]];
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [CPNetWorkTool getWithUrl:url params:nil success:^(id responseObject) {
        [SVProgressHUD dismiss];
        NSArray *data = [CPMySubscribeModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        for (CPMySubscribeModel *model in data) {
            CPMySubscribeFrameModel *frameModel = [[CPMySubscribeFrameModel alloc] init];
            frameModel.model = model;
            [self.datas addObject:frameModel];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
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

@end
