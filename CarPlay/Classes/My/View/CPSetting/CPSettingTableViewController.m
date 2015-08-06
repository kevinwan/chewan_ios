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
#import "CPAbout.h"
#import "CPVersionIntroduction.h"

@interface CPSettingTableViewController ()<UIAlertViewDelegate>
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

-(void)viewWillAppear:(BOOL)animated{
    if (![Tools getValueFromKey:@"userId"]) {
        [self.loginOutBtn setTitle:@"登录" forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        float totalSize = [[SDImageCache sharedImageCache] getSize];
        if (floor(totalSize/1024/1024*100)) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self.tableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"清理成功"];
            }];
        }else{
             [SVProgressHUD showErrorWithStatus:@"没有要清理的内容"];
        }
    }else if (indexPath.row==1){
        
    }else if (indexPath.row == 2){
            CPAbout *CPAbout=[UIStoryboard storyboardWithName:@"CPAbout" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:CPAbout animated:YES];
    }else{
        CPVersionIntroduction *CPVersionIntroduction=[UIStoryboard storyboardWithName:@"CPVersionIntroduction" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:CPVersionIntroduction animated:YES];
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
    if ([Tools getValueFromKey:@"userId"]) {
        [Tools setValueForKey:nil key:@"userId"];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否注销当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil] show];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        LoginViewController *loginVC=[[LoginViewController alloc]init];
        [Tools setValueForKey:@(NO) key:NOTIFICATION_HASLOGIN];
        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.view.window.rootViewController=nav1;
        [self.view.window makeKeyAndVisible];
    }
}

@end
