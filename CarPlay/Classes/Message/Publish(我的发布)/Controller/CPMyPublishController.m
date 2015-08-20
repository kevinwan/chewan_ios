//
//  CPMyPublishController.m
//  CarPlay
//
//  Created by chewan on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMyPublishController.h"
#import "CPMyPublishFrameModel.h"
#import "CPMyPublishModel.h"
#import "MJExtension.h"
#import "CPMyPublishCell.h"
#import "CPActiveDetailsController.h"
#import "MJRefresh.h"

@interface CPMyPublishController ()
@property (nonatomic, strong) NSMutableArray *frameModels;
@property (nonatomic, strong) UIView *timeLine;
@end

@implementation CPMyPublishController

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
//    if ([self.hisUserId isEqualToString:[Tools getValueFromKey:@"userId"]]){
        self.navigationItem.title = @"我的发布";
//    }else{
//        self.navigationItem.title = @"他的发布";
//    }
    __weak typeof(self) weakSelf = self;
    
    self.tableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.ignore = 0;
        [weakSelf loadDataWithParams:0];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.ignore = weakSelf.frameModels.count;
        [weakSelf loadDataWithParams:weakSelf.ignore];
    }];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.footer.hidden = YES;
    ZYJumpToLoginView
    if (CPIsLogin) {
        [self addBottomTimeLine];
    }
    [self reRefreshData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CPNotificationCenter addObserver:self selector:@selector(memberManage:) name:MyPublishToPlayNotify object:nil];
    
    [CPNotificationCenter addObserver:self selector:@selector(joinPerson:) name:MyJoinPersonNotify object:nil];
    self.ignore = 0;
    [self reRefreshData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [CPNotificationCenter removeObserver:self];
}

/**
 *  添加底部时间线,监听刷新状态
 */
- (void)addBottomTimeLine
{
    UIView *timeLine = [UIView new];
    timeLine.backgroundColor = [Tools getColor:@"e7eaee"];
    timeLine.width = 1;
    timeLine.x = 55;
    [self.tableView insertSubview:timeLine atIndex:0];
    self.timeLine = timeLine;
    
    [self.tableView addObserver:self forKeyPath:@"footer.state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];

}

- (void)reRefreshData
{
    self.timeLine.hidden = YES;
    [self showLoading];
    [self loadDataWithParams:0];
}

- (void)createActivity
{
    UIViewController *vc = [UIStoryboard storyboardWithName:@"CPCreatActivityController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadDataWithParams:(NSUInteger)ignore
{
    if (!self.hisUserId.length) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self disMiss];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/post",self.hisUserId];
    [CPNetWorkTool getWithUrl:url params:@{@"ignore" : @(ignore)} success:^(NSDictionary *responseObject) {
        
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (CPSuccess) {
            NSArray *arr = [CPMyPublishModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.ignore == 0) {
                [self.frameModels removeAllObjects];
            }
            if (arr.count) {
                self.timeLine.hidden = NO;
                for (int i = 0; i < arr.count; i++) {
                    CPMyPublishFrameModel *frameModel = [[CPMyPublishFrameModel alloc] init];
                    frameModel.model = arr[i];
                    [self.frameModels addObject:frameModel];
                }
                [self.tableView reloadData];
            }else{
                if (self.frameModels.count > 0) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            if (self.frameModels.count == 0) {
                self.timeLine.hidden = YES;
                [self showNoPublish];
            }
        }else{
            [self showNetWorkFailed];
        }
        
    } failure:^(NSError *error) {
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.frameModels removeAllObjects];
        [self.tableView reloadData];
        [self showNetWorkOutTime];
    }];

}

- (void)dealloc
{
    if (self.timeLine) {
        [self.tableView removeObserver:self forKeyPath:@"footer.state"];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.frameModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMyPublishCell *cell = [CPMyPublishCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    CPMyPublishFrameModel *frameModel = self.frameModels[indexPath.row];
    frameModel.model.row = indexPath.row;
    cell.frameModel = frameModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPMyPublishFrameModel *frameModel = self.frameModels[indexPath.row];
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转到活动详情界面
    CPActiveDetailsController *activityDetailVc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil ].instantiateInitialViewController;
    CPMyPublishFrameModel *frameModel = self.frameModels[indexPath.row];
    activityDetailVc.activeId = frameModel.model.activityId;
    [self.navigationController pushViewController:activityDetailVc animated:YES];
}

/**
 *  KVO监听方法,监控MJRefresh的状态,注意kvo一定要移除监听
 *
 *  @param keyPath 监听的key
 *  @param object  监听对象
 *  @param change  变化内容new/old
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    MJRefreshState state = [change[@"new"] intValue];
    
    if (state == MJRefreshStateRefreshing) {
        self.timeLine.y = self.tableView.contentSize.height;
        CGFloat keyWindowY = [self.view convertPoint:CGPointMake(0 , self.tableView.contentSize.height)toView:[UIApplication sharedApplication].keyWindow].y;
        self.timeLine.height = kScreenHeight - keyWindowY;
    }else if (MJRefreshStateIdle){
        self.timeLine.y = self.tableView.contentSize.height;
        CGFloat keyWindowY = [self.view convertPoint:CGPointMake(0 , self.tableView.contentSize.height)toView:[UIApplication sharedApplication].keyWindow].y;
        self.timeLine.height = kScreenHeight - keyWindowY;
    }
}

- (void)memberManage:(NSNotification *)notify
{
    
    //根据isOrganizer判断进入那个界面
  
    NSInteger row = [notify.userInfo[MyPublishToPlayInfo] integerValue];
    CPMyPublishFrameModel *model = self.frameModels[row];
    
    if (model.model.isOver) return;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
    
    MembersManageController * vc = sb.instantiateInitialViewController;
    vc.activityId = model.model.activityId;
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)joinPerson:(NSNotification *)notify
{
    NSInteger row = [notify.userInfo[MyJoinPersonInfo] integerValue];
    CPMyPublishFrameModel *model = self.frameModels[row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MembersManage" bundle:nil];
    
    MembersManageController * vc = sb.instantiateInitialViewController;
    vc.activityId = model.model.activityId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
