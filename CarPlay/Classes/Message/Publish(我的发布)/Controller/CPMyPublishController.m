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
    
    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
        self.navigationItem.title = @"我的发布";
    }else{
        self.navigationItem.title = @"他的发布";
    }
    
    self.tableView.allowsSelection = NO;
    
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

@end
