//
//  CPEditInfoTableViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPEditInfoTableViewController.h"
#import "CPEditHeadIconCell.h"
#import "CPRegisterCellsTableViewCell3.h"

@interface CPEditInfoTableViewController ()

@end

@implementation CPEditInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
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
    static NSString *cellIdentifier1=@"CPEditHeadIconCell";
    static NSString *cellIdentifier2=@"CPRegisterCellsTableViewCell3";
    if (indexPath.row==0) {
        CPEditHeadIconCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPEditHeadIconCell" owner:nil options:nil] lastObject];
        }
        return cell;
    }else{
        CPRegisterCellsTableViewCell3 *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CPRegisterCellsTableViewCell3" owner:nil options:nil] lastObject];
        }
        
//        NSString *phone=[Tools getValueFromKey:@"phone"];
//        NSString *password=[Tools getValueFromKey:@"password"];
//        NSString *code=[Tools getValueFromKey:@"code"];
//        NSString *nickname=[Tools getValueFromKey:@"nickname"];
//        NSString *gender=[Tools getValueFromKey:@"gender"];
//        NSString *province=[Tools getValueFromKey:@"province"];
//        NSString *city=[Tools getValueFromKey:@"city"];
//        NSString *district=[Tools getValueFromKey:@"district"];
//        NSString *photo=[Tools getValueFromKey:@"photoId"];
        
        
        if (indexPath.row==1) {
            cell.cellTitle.text=@"昵称";
        }else if (indexPath.row==2){
            cell.cellTitle.text=@"性别";
        }else if (indexPath.row==3){
            cell.cellTitle.text=@"驾龄";
        }else if (indexPath.row==4){
            cell.cellTitle.text=@"地区";
        }
        return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
