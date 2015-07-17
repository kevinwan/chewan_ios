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
#import "ZYNetWorkTool.h"

@interface CPMyPublishController ()
@property (nonatomic, strong) NSMutableArray *frameModels;
@end

@implementation CPMyPublishController

#pragma mark - 懒加载
- (NSMutableArray *)frameModels
{
    if (_frameModels == nil) {
        _frameModels = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TestActivity.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in arr) {
            CPMyPublishFrameModel *frameModel = [[CPMyPublishFrameModel alloc] init];
            frameModel.model = [CPMyPublishModel objectWithKeyValues:dict];
            [_frameModels addObject:frameModel];
        }
    }
    return _frameModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的发布";
    self.tableView.allowsSelection = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/post",@"846de312-306c-4916-91c1-a5e69b158014"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"userId"] = [Tools getValueFromKeyForUserId:@"userId"];
//    params[@"token"] = [Tools getValueFromKey:@"token"];
    
    params[@"token"] = @"750dd49c-6129-4a9a-9558-27fa74fc4ce7";
    params[@"userId"] = @"846de312-306c-4916-91c1-a5e69b158014";
    [ZYNetWorkTool getWithUrl:url params:params success:^(id responseObject) {
        DLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
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

@end
