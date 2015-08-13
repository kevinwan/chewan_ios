//
//  CPMySubscribeController.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMySubscribeController.h"
#import "CPMySubscribeCell.h"
#import "MJExtension.h"
#import "CPMySubscribeFrameModel.h"
#import "CPMySubscribeModel.h"
#import "CPActiveDetailsController.h"
#import "CPTaDetailsController.h"
#import "MembersManageController.h"
#import "MembersController.h"

@interface CPMySubscribeController ()
@property (nonatomic, strong) NSMutableArray *frameModels;
@end

@implementation CPMySubscribeController

#pragma mark - 懒加载
- (NSMutableArray *)frameModels
{
    if (_frameModels == nil) {
        _frameModels = [NSMutableArray array];
    }
    return _frameModels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
//    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
    self.navigationItem.title = @"我的收藏";
//    }else{
//        self.navigationItem.title = @"他的关注";
//    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.ignore = 0;
        [weakSelf loadDataWithParam:0];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.ignore = weakSelf.frameModels.count;
        [weakSelf loadDataWithParam:weakSelf.ignore];
    }];
    
    self.tableView.footer.hidden = YES;
    ZYJumpToLoginView // 跳转到登陆界面
    [self reRefreshData];
}

- (void)reRefreshData
{
    [self showLoading];
    [self loadDataWithParam:0];
}

- (void)loadDataWithParam:(NSInteger)ignore
{
    NSString *userId = [Tools getValueFromKey:@"userId"];
    if (!userId.length) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self disMiss];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/subscribe",userId];
    
    [CPNetWorkTool getWithUrl:url params:@{@"ignore" : @(ignore)} success:^(id responseObject) {
        DLog(@"%@",responseObject);
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        if (CPSuccess) {
            NSArray *data = [CPMySubscribeModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.ignore == 0) {
                [self.frameModels removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            
            if (data.count) {
                for (CPMySubscribeModel *model in data) {
                    CPMySubscribeFrameModel *frameModel = [[CPMySubscribeFrameModel alloc] init];
                    frameModel.model = model;
                    [self.frameModels addObject:frameModel];
                }

                [self.tableView reloadData];
            }else{
                if (self.frameModels.count > 0) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            
            if (self.frameModels.count == 0) {
                [self showNoSubscribe];
            }
        }else if (self.frameModels.count == 0){
            [self showNetWorkFailed];
        }
    } failure:^(NSError *error) {
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [self showNetWorkOutTime];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CPNotificationCenter addObserver:self selector:@selector(userIconClick:) name:CPClickUserIconNotification object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(toPlayButtonClick:) name:ChatButtonClickNotifyCation object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(joinPersonButtonClick:) name:JoinPersonClickNotifyCation object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CPNotificationCenter removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frameModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMySubscribeCell *cell = [CPMySubscribeCell cellWithTableView:tableView];
    CPMySubscribeFrameModel *frameModel = self.frameModels[indexPath.row];
    frameModel.model.row = indexPath.row;
    cell.frameModel = frameModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMySubscribeFrameModel *frameModel = self.frameModels[indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到活动详情界面
    CPActiveDetailsController *activityDetailVc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil ].instantiateInitialViewController;
    CPMySubscribeFrameModel *frameModel = self.frameModels[indexPath.row];
    activityDetailVc.activeId = frameModel.model.activityId;
    [self.navigationController pushViewController:activityDetailVc animated:YES];
}

/**
 *  点击了用户的头像
 *
 *  @param notify notify description
 */
- (void)userIconClick:(NSNotification *)notify
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    vc.targetUserId = notify.userInfo[CPClickUserIconInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  点击了我要去玩按钮
 *
 *  @param notify notify description
 */
- (void)toPlayButtonClick:(NSNotification *)notify
{
    NSUInteger row = [notify.userInfo[ChatButtonClickInfo] intValue];
#warning 下面两句请勿删除,如果想要切换按钮状态需要修改model数值,重新刷新表格
    // 1. 当前的indexPath,刷新表格时使用
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    // 2. 对按钮状态进行刷新
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    CPMySubscribeFrameModel *frameModel = self.frameModels[row];
    
    // 当前行对应的model
    CPMySubscribeModel *model = frameModel.model;
    
    //根据isOrganizer判断进入那个界面
    if (model.isOrganizer == 1) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
        
        MembersManageController * vc = sb.instantiateInitialViewController;
        vc.activityId = model.activityId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (model.isMember == 1){
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Members" bundle:nil];
        MembersController * vc = sb.instantiateInitialViewController;
        vc.activityId = model.activityId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (model.isMember == 2){ // 申请中
        
    }
    
}

/**
 *  点击了参与人数的按钮
 *
 *  @param notify
 */
- (void)joinPersonButtonClick:(NSNotification *)notify
{
    CPMySubscribeModel *model = notify.userInfo[ChatButtonClickInfo];
}

@end
