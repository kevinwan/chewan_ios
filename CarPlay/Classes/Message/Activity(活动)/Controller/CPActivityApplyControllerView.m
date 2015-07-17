//
//  ActivityApplyControllerView.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPActivityApplyControllerView.h"
#import "CPActivityApplyCell.h"
#import "CPSubscribePersonController.h"

@interface CPActivityApplyControllerView ()

@end

@implementation CPActivityApplyControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动参与申请";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ActivityApplyCell";
    CPActivityApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPSubscribePersonController *subVc = [UIStoryboard storyboardWithName:@"CPSubscribePersonController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:subVc animated:YES];
}

@end
