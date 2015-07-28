//
//  ZYTableViewController.m
//  CarPlay
//
//  Created by chewan on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "ZYTableViewController.h"

@interface ZYTableViewController ()
@property (nonatomic, strong) UIView *noNetWorkView;
@end

@implementation ZYTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 没有网络的提示
    if (CPNoNetWork){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败,请检查你的网络" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
    }
    
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
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

/**
 *  controller布局子控件时调用
 */
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
