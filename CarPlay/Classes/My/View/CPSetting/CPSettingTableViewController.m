//
//  CPSettingTableViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/27.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSettingTableViewController.h"
#import "CPMyBaseCell.h"
#import "LoginViewController.h"

@interface CPSettingTableViewController ()
{
    NSArray *titleArray;
}
@end

@implementation CPSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView=self.footView;
    titleArray=[[NSArray alloc]initWithObjects:@"清理缓存",@"喜欢我们打分鼓励",@"关于我们",@"版本介绍",@"当前版本", nil];
    self.loginOutBtn.layer.cornerRadius=3.0;
    self.loginOutBtn.layer.masksToBounds=YES;
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
    if (indexPath.row==0) {
        float totalSize = [[SDImageCache sharedImageCache] getSize];
        cell.valueLable.text=[[NSString alloc]initWithFormat:@"%.2fM",totalSize/1024/1024];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self.tableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"清理成功"];
        }];
    }
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
- (IBAction)loginOutBtnClick:(id)sender {
    LoginViewController *loginVC=[[LoginViewController alloc]init];
    [loginVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
