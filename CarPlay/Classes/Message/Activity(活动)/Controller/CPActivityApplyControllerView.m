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

@interface CPActivityApplyControllerView ()
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UIView *noDataView;
@end

@implementation CPActivityApplyControllerView

- (UIView *)noDataView
{
    if (_noDataView == nil) {
        _noDataView = [[UIView alloc] init];
        _noDataView.height = self.tableView.height - 64;
        _noDataView.width = self.view.width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"没有新数据,点击刷新" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_noDataView addSubview:button];
        [button sizeToFit];
        button.centerX = _noDataView.centerXInSelf;
        button.centerY = _noDataView.centerYInSelf - 30;
    }
    return _noDataView;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动参与申请";
  
    self.tableView.tableFooterView = [[UIView alloc] init];
    [CPNotificationCenter addObserver:self selector:@selector(agreeBtnClick:) name:CPActivityApplyNotification object:nil];
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
    if (userId == nil) {
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/application/list",userId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [Tools getValueFromKey:@"token"];
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [ZYNetWorkTool getWithUrl:url params:params success:^(id responseObject) {
        DLog(@"%@",responseObject);
        if (CPSuccess) {
            NSArray *data = [CPActivityApplyModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (data.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有新的申请"];
                [self showNoData];
                return;
            }
            [self disMiss];
            [self.datas removeAllObjects];
            self.tableView.tableFooterView = [[UIView alloc] init];
            [self.datas addObjectsFromArray:data];
    
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)agreeBtnClick:(NSNotification *)notify
{
    [self showSuccess:@"已同意"];
    NSUInteger row = [notify.userInfo[CPActivityApplyInfo] intValue];
    [self.datas removeObjectAtIndex:row];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    static NSString *ID = @"ActivityApplyCell";
    CPActivityApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.row = indexPath.row;
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPSubscribePersonController *subVc = [UIStoryboard storyboardWithName:@"CPSubscribePersonController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:subVc animated:YES];
}

@end
