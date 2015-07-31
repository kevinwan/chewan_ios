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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)reRefreshData
{
    [self loadData];
}

- (void)loadData
{
    NSString *userId = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    if (userId.length == 0 || token.length == 0) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/listen",userId];
    [self showLoading];
    [ZYNetWorkTool getWithUrl:url params:@{@"token" : token} success:^(id responseObject) {
        DLog(@"%@...",responseObject);
        if (CPSuccess) {
            [self disMiss];
            NSArray *arr = [CPOrganizer objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (arr.count > 0) {
                [self.datas removeAllObjects];
                [self.datas addObjectsFromArray:arr];
                [self.tableView reloadData];
            }else{
                [self showNoData];
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

- (void)cancleSubscribe:(NSNotification *)notify
{
    NSUInteger row = [notify.userInfo[CPCancleSubscribeInfo] intValue];
    if (self.datas.count > 0) {
        [self showSuccess:@"取消成功"];
        [self.datas removeObjectAtIndex:row];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)dealloc
{
    [CPNotificationCenter removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SubscribePersonCell";
    
    CPSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.row = indexPath.row;
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPMySubscribeController *vc = [[CPMySubscribeController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
