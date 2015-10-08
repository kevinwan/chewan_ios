//
//  CPMyInfoController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/29.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoController.h"
#import "CPMyInfoFirCell.h"
#import "CPMyInfoSecCell.h"
#import "CPMyInfoThrCell.h"
#import "CPMyInfoHead.h"

@interface CPMyInfoController ()

@end

@implementation CPMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    self.title = @"个人信息";
    [self setRightNavigationBarItemWithTitle:@"完成" Image:nil highImage:nil  target:self action:@selector(finish)];
    
    // 设置head
    self.tableView.tableHeaderView = [CPMyInfoHead createHead];
    

    
}

- (void)finish{
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CPMyInfoFirCell *cell = [CPMyInfoFirCell cellWithTableView:tableView];
        return cell;
    }else if (indexPath.row == 1) {
        CPMyInfoSecCell *cell = [CPMyInfoSecCell cellWithTableView:tableView];
        return cell;
    }else if (indexPath.row == 2) {
        CPMyInfoThrCell *cell = [CPMyInfoThrCell cellWithTableView:tableView];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [Tools getColor:@"efefef"];
        return cell;
    }
       

}




@end
