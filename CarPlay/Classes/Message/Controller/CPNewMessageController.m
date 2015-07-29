//
//  CPNewMessageController.m
//  CarPlay
//
//  Created by chewan on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNewMessageController.h"
#import "CPNewMessageCell.h"
#import "UIBarButtonItem+Extension.h"
#import "CPActivityApplyControllerView.h"
#import "CPNetWork.h"
#import "CPMyPublishController.h"
#import "CPCreatActivityController.h"
#import "CPEditActivityController.h"
#import "CPMySubscribeController.h"
#import "CPMyJoinController.h"
#import "CPNewMsgModel.h"

@interface CPNewMessageController ()
@property (nonatomic, strong) NSCache *cellHeights;
@end

@implementation CPNewMessageController

- (NSCache *)cellHeights
{
    if (_cellHeights == nil) {
        _cellHeights = [[NSCache alloc] init];
    }
    return _cellHeights;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新的留言";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"NewMsgCell";
    CPNewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = [[CPNewMsgModel alloc] init];
    [self.cellHeights setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

/**
 *  滑动删除单元格
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CPMyPublishController *vc = [[CPMyPublishController alloc] init];
//    vc.hisUserId = [Tools getValueFromKey:@"userId"];
//    [self.navigationController pushViewController:vc animated:YES];
//    CPCreatActivityController *vc = [UIStoryboard storyboardWithName:@"CPCreatActivityController" bundle:nil].instantiateInitialViewController;
//    [self.navigationController pushViewController:vc animated:YES];
    CPEditActivityController *vc = [UIStoryboard storyboardWithName:@"CPEditActivityController" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
//    CPMySubscribeController *vc = [[CPMySubscribeController alloc] init];
//    vc.hisUserId = [Tools getValueFromKey:@"userId"];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    CPMyJoinController *vc = [[CPMyJoinController alloc] init];
//    vc.hisUserId = [Tools getValueFromKey:@"userId"];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *number = [self.cellHeights objectForKey:@(indexPath.row)];
    
    if (number) {
        return number.floatValue;
    }else{
      CPNewMessageCell *cell = (CPNewMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [self.cellHeights setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
        return cell.cellHeight;
    }
    
}

@end
