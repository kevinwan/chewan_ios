//
//  CPMessageController.m
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMessageController.h"
#import "CPNewMessageController.h"

@interface CPMessageController ()

@end

@implementation CPMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CPNewMessageController *newMsgVc = [UIStoryboard storyboardWithName:@"CPNewMessageController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:newMsgVc animated:YES];
}

@end
