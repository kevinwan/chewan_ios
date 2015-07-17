//
//  CPSubscribePersonController.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPSubscribePersonController.h"
#import "CPSubscribeCell.h"
#import "CPMySubscribeController.h"

@interface CPSubscribePersonController ()

@end

@implementation CPSubscribePersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关注的人";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SubPersonCell";
    CPSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPMySubscribeController *vc = [[CPMySubscribeController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
