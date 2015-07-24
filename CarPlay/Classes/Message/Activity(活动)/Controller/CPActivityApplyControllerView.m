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
#import "MJExtension.h"

@interface CPActivityApplyControllerView ()
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation CPActivityApplyControllerView

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
    NSString *userId = [Tools getValueFromKey:@"userId"];
    if (userId == nil) {
        return;
    }
    
    [CPNotificationCenter addObserver:self selector:@selector(agreeBtnClick:) name:@"AgreeApply" object:nil];
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/application/list",userId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [Tools getValueFromKey:@"token"];
    [ZYNetWorkTool getWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            NSArray *data = [CPActivityApplyModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (data.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有新的申请"];
                return;
            }
            [self.datas addObjectsFromArray:data];
            
            NSLog(@"%@---%@",responseObject, self.tableView);
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)agreeBtnClick:(NSNotification *)notify
{
    NSString *appid = notify.userInfo[@"appid"];
    NSString *url = [NSString stringWithFormat:@"v1/application/%@/process?userId=%@&token=%@",appid,[Tools getValueFromKey:@"userId"],[Tools getValueFromKey:@"token"]];
    DLog(@"%@---",url);
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json[@"action"] = @"1";
//    [ZYNetWorkTool postWithUrl:url params:json success:^(id responseObject) {
//        DLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
//        
//    }];
    [ZYNetWorkTool postJsonWithUrl:url params:json success:^(id responseObject) {
        DLog(@"%@",responseObject);
        
        if (CPSuccess) {
            
        }
    } failed:^(NSError *error) {
        
    }];
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
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPSubscribePersonController *subVc = [UIStoryboard storyboardWithName:@"CPSubscribePersonController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:subVc animated:YES];
}

/**
 *  下面的方法用来设置tableView全屏的分割线
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
