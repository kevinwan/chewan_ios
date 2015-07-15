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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TestActivity.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in arr) {
            CPMySubscribeFrameModel *frameModel = [[CPMySubscribeFrameModel alloc] init];
            frameModel.model = [CPMySubscribeModel objectWithKeyValues:dict];
            [_frameModels addObject:frameModel];
        }
    }
    return _frameModels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的关注";
    
    self.tableView.allowsSelection = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
