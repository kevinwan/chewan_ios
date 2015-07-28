//
//  CPSettingTableViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSettingTableViewController.h"
#import "CPMyBaseCell.h"

@interface CPSettingTableViewController ()
{
    NSArray *titleArray;
}
@end

@implementation CPSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray=[[NSArray alloc]initWithObjects:@"清理缓存",@"喜欢我们打分鼓励",@"关于我们",@"版本介绍",@"当前版本", nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"CPMyBaseCell";
    CPMyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPMyBaseCell" owner:nil options:nil] lastObject];
    }
    cell.icon.image=[UIImage imageNamed:[titleArray objectAtIndex:indexPath.row]];
    cell.titleLable.text=[titleArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

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
@end
