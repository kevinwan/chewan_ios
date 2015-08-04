//
//  CPMessageController.m
//  CarPlay
//
//  Created by 公平价 on 15/6/19.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMessageController.h"
#import "CPNewMessageController.h"
#import "CPMySubscribeController.h"
#import "CPActivityApplyControllerView.h"
#import "CPSubscribePersonController.h"
#import "CPBadgeView.h"

typedef enum {
    CPMessageOptionMsg, // 新留言消息
    CPMessageOptionActivity // 参与活动信息
}CPMessageOption;

@interface CPMessageController ()
@property (weak, nonatomic) IBOutlet CPBadgeView *leaveNewMsgNumber;

@property (weak, nonatomic) IBOutlet CPBadgeView *activityApplyNewMsgNumber;
@property (weak, nonatomic) IBOutlet UILabel *leaveMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityApplyMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *systemTextLabel;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CPMessageController

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:180 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        [self loadData];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    if (CPUnLogin) {
        return;
    }else{
        self.tableView.header = [CPRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [self timer];
    }
}
//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (CPUnLogin){
        return;
    }else{
        if (_timer == nil) {
            [self timer];
        }
    }
    
}

- (void)loadData
{
    NSString *userid = [Tools getValueFromKey:@"userId"];
    NSString *token = [Tools getValueFromKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/message/count?token=%@", userid, token];
    [ZYNetWorkTool getWithUrl:url params:nil success:^(id responseObject) {
        [self.tableView.header endRefreshing];
        if (CPSuccess) {
            
            NSDictionary *comment = responseObject[@"data"][@"comment"];
            
            NSDictionary *application = responseObject[@"data"][@"application"];
            

            NSUInteger newMsgCount = [comment[@"count"] intValue];
            NSUInteger activityApplyCount = [application[@"count"] intValue];
            if (newMsgCount > 0) {
                self.leaveNewMsgNumber.hidden = NO;
                self.leaveNewMsgNumber.badgeValue = [NSString stringWithFormat:@"%zd",newMsgCount];
                
                self.leaveMsgLabel.text = comment[@"content"];
            }
            
            if (activityApplyCount > 0) {
                self.activityApplyNewMsgNumber.hidden = NO;
                self.activityApplyNewMsgNumber.badgeValue = [NSString stringWithFormat:@"%zd", activityApplyCount];
                self.activityApplyMsgLabel.text = application[@"content"];
            }
            
            if (activityApplyCount + newMsgCount > 0) {
                
                self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", activityApplyCount + newMsgCount];
            }else{
                
                self.tabBarItem.badgeValue = nil;
            }
            
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 1) {
        
        self.activityApplyNewMsgNumber.badgeValue = @"0";
        self.activityApplyNewMsgNumber.hidden = YES;
        self.activityApplyMsgLabel.text = @"没有新的申请";
        
        if (self.leaveNewMsgNumber.badgeValue.integerValue > 0) {
            self.tabBarItem.badgeValue = self.leaveNewMsgNumber.badgeValue;
        }else{
            self.tabBarItem.badgeValue = nil;
        }
        CPActivityApplyControllerView *vc = [UIStoryboard storyboardWithName:@"CPActivityApplyControllerView" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.leaveNewMsgNumber.badgeValue = @"0";
        
        if (self.activityApplyNewMsgNumber.badgeValue.integerValue > 0) {
            self.tabBarItem.badgeValue = self.activityApplyNewMsgNumber.badgeValue;
        }else{
            self.tabBarItem.badgeValue = nil;
        }
        self.leaveNewMsgNumber.hidden = YES;
        self.leaveMsgLabel.text = @"没有新的消息";
        CPNewMessageController *newMsgVc = [UIStoryboard storyboardWithName:@"CPNewMessageController" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:newMsgVc animated:YES];
    }
}

@end
