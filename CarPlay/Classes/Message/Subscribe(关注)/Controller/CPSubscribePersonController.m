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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        [self disMiss];
        if (CPSuccess) {
            NSArray *arr = [CPOrganizer objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:arr];
            [self.tableView reloadData];
        }else{
            [self showInfo:@"加载失败"];
        }
    } failure:^(NSError *error) {
        [self disMiss];
        [self showError:@"加载失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SubscribePersonCell";
    
    CPSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
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
