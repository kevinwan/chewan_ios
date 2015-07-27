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
#import "CPSelectView.h"

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
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"确定" target:self action:@selector(select)];
    
    self.tableView.allowsSelection = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.hisUserId.length == 0){
        [SVProgressHUD showInfoWithStatus:@"你访问的用户不合法"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/post",self.hisUserId];
    [SVProgressHUD showWithStatus:@"努力加载中"];
    [CPNetWorkTool getWithUrl:url params:nil success:^(NSDictionary *responseObject) {
        [SVProgressHUD dismiss];
        if (CPSuccess) {
            NSArray *arr = [CPMyPublishModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            for (int i = 0; i < arr.count; i++) {
                CPMyPublishFrameModel *frameModel = [[CPMyPublishFrameModel alloc] init];
                frameModel.model = arr[i];
                [self.frameModels addObject:frameModel];
            }
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
}

- (void)select
{
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    button.frame = self.view.bounds;
    button.backgroundColor = RGBACOLOR(111, 111, 111, 0.5);
    [self.view addSubview:button];
    
    
    CPSelectView *selectView = [CPSelectView selectView];
    [selectView showWithView:button];
}

- (void)hide
{
    
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
