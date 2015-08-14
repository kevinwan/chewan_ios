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
#import "CPActivityApplyModel.h"
#import "MJRefresh.h"
#import "CPActiveDetailsController.h"
#import "CPTaDetailsController.h"
#import "CPCarAuthoFailedController.h"
#import "CPCarAuthoAllowController.h"

#define ActivityMsgData @"ActivityMsgData"

@interface CPActivityApplyControllerView ()
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIButton *coverView;
@end

@implementation CPActivityApplyControllerView

- (UIButton *)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIButton alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        UIView *bgView = [UIView new];
        bgView.width = kScreenWidth - 30;
        bgView.height = 136;
        bgView.centerX = kScreenWidth * 0.5;
        bgView.centerY = kScreenHeight * 0.5;
        [_coverView addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [Tools getColor:@"656c78"];
        titleLabel.text = @"还没有人提供车";
        [titleLabel sizeToFit];
        titleLabel.centerX = bgView.centerXInSelf;
        titleLabel.y = 20;
        [bgView addSubview:titleLabel];
        
        UILabel *msgLabel = [[UILabel alloc] init];
        msgLabel.font = [UIFont systemFontOfSize:14];
        msgLabel.textColor = [Tools getColor:@"656c78"];
        msgLabel.text = @"请选择\"提供空座\"的人加入活动!";
        [msgLabel sizeToFit];
        msgLabel.centerX = bgView.centerXInSelf;
        msgLabel.y = 12.5 + titleLabel.bottom;
        [msgLabel addSubview:msgLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"我知道了" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.backgroundColor = [Tools getColor:@"48d1d5"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.width = bgView.width - 20;
        button.height = 40;
        button.x = 10;
        button.y = msgLabel.bottom + 20;
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_coverView addSubview:button];
        _coverView.hidden = NO;
        [[UIApplication sharedApplication].windows.lastObject addSubview:_coverView];
    }
    return _coverView;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        _backItem = [UIBarButtonItem itemWithNorImage:@"返回" higImage:nil title:nil target:self action:@selector(back)];
    }
    return _backItem;
}

- (UIBarButtonItem *)leftItem
{
    if (_leftItem == nil) {
        _leftItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"全选" target:self action:@selector(selectAll)];
    }
    return _leftItem;
}

- (UIBarButtonItem *)rightItem
{
    if (_rightItem == nil) {
        _rightItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"取消" target:self action:@selector(cancleSelect)];
    }
    return _rightItem;
}

- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] init];
        _deleteBtn.height = 44;
        _deleteBtn.y = kScreenHeight - 44;
        _deleteBtn.width = kScreenWidth;
        _deleteBtn.x = 0;
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setBackgroundColor:[Tools getColor:@"fc6e51"]];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.view insertSubview:_deleteBtn belowSubview:self.navigationController.navigationBar];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"活动消息";
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    [CPNotificationCenter addObserver:self selector:@selector(tableViewEdit:) name:CPNewActivityMsgEditNotifycation object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(userIconClick:) name:CPClickUserIconNotification object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(agreeBtnClick:) name:CPActivityApplyNotification object:nil];
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.ignore = 0;
        [weakSelf loadDataWithParam:0];
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.ignore = self.datas.count;
        [weakSelf loadDataWithParam:weakSelf.ignore];
    }];
    
    self.tableView.footer.hidden = YES;
    ZYJumpToLoginView // 跳转到登录页面
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
    NSString *token = [Tools getValueFromKey:@"token"];
    if (! userId.length) {
        [self disMiss];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"v1/user/%@/message/list?token=%@&type=application",userId, token];
    [ZYNetWorkTool getWithUrl:url params:@{@"ignore" : @(ignore)} success:^(id responseObject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self disMiss];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        DLog(@"%@",responseObject);
        if (CPSuccess) {
            
            if (self.ignore == 0) {
                [self.datas removeAllObjects];
                [self.tableView.footer resetNoMoreData];
            }
            NSArray *data = [CPActivityApplyModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            if (data.count > 0) {
                [self.datas addObjectsFromArray:data];
                [self.tableView reloadData];
            }else{
                if (self.datas.count > 0) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            if (self.datas.count == 0) {
                [self showNoData];
            }
        }else if (self.datas.count == 0){
            [self showNetWorkFailed];
        }
    } failure:^(NSError *error) {
        [self disMiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.footer.hidden = NO;
        });
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self showNetWorkOutTime];
    }];
}

- (void)agreeBtnClick:(NSNotification *)notify
{
    NSUInteger row = [notify.userInfo[CPActivityApplyInfo] intValue];
    if (row == CPActivityNoCheat){
        [self coverView];
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)tableViewEdit:(NSNotification *)notify
{
    if (self.editing == NO) {
        NSNumber *rowNum = notify.userInfo[CPNewActivityMsgEditInfo];
        CPActivityApplyModel *model = self.datas[rowNum.intValue];
        model.isChecked = YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum.intValue inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self setEditing:YES animated:YES];
    }
}

- (void)dealloc
{
    [CPNotificationCenter removeObserver:self];
}

#pragma mark - Table view data source

- (void)setEditing:(BOOL)editting animated:(BOOL)animated
{
    [super setEditing:editting animated:YES];
    
    if (editting) {
        self.navigationItem.rightBarButtonItem = self.rightItem;
        self.navigationItem.leftBarButtonItem = self.leftItem;
        self.deleteBtn.hidden = NO;
    }else{
        self.navigationItem.leftBarButtonItem = self.backItem;
        self.navigationItem.rightBarButtonItem = nil;
        self.deleteBtn.hidden = YES;
    }
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID1 = @"ActivityApplyCell";
    static NSString *ID2 = @"ActivityMsgCell";
    static NSString *ID3 = @"CarAuthoMsgCell";
    CPActivityApplyCell *cell;
    CPActivityApplyModel *model = [self.datas objectAtIndex:indexPath.row];
    model.row = indexPath.row;
    if ([model.type isEqualToString:@"活动申请处理"]) {
       cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        
    }else if ([model.type isEqualToString:@"车主认证"]){
        cell = [tableView dequeueReusableCellWithIdentifier:ID3];
    }else{ // 活动邀请 活动申请处理结果
        cell = [tableView dequeueReusableCellWithIdentifier:ID2];
    }
    cell.model = model;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

/**
 *  单元格选中效果
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPActivityApplyModel *model = [self.datas objectAtIndex:indexPath.row];
    
    if (self.editing)
    {
        model.isChecked = !model.isChecked;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        if ([model.type isEqualToString:@"车主认证"]) {
            if ([model.content contains:@"未通过"]){
                CPCarAuthoFailedController *vc = [[CPCarAuthoFailedController alloc] init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                CPCarAuthoAllowController *vc = [[CPCarAuthoAllowController alloc] init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            return;
        }
        
        if (model.activityId.length) {
            CPActiveDetailsController *vc = [UIStoryboard storyboardWithName:@"CPActiveDetailsController" bundle:nil].instantiateInitialViewController;
            vc.activeId = model.activityId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 处理导航条按钮点击
/**
 *  全选
 */
- (void)selectAll
{
    [self.datas enumerateObjectsUsingBlock:^(CPActivityApplyModel *obj, NSUInteger idx, BOOL *stop) {
        [obj setIsChecked:YES];
    }];
    [self.tableView reloadData];
}

/**
 *  取消选中
 */
- (void)cancleSelect
{
    [self.datas enumerateObjectsUsingBlock:^(CPActivityApplyModel *obj, NSUInteger idx, BOOL *stop) {
        [obj setIsChecked:NO];
    }];
    self.deleteBtn.hidden = YES;
    [self setEditing:NO animated:YES];
}

- (void)deleteCell
{
    // 必须先获取选中的cell
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    NSMutableArray *msgIds = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.datas.count; i++) {
        CPActivityApplyModel *model = self.datas[i];
        if (model.isChecked) {
            [indexSet addIndex:i];
            [msgIds addObject:model.messageId];
        }
    }
    [self showLoading];
    [CPNetWorkTool postJsonWithUrl:@"/v1/message/remove" params:@{@"messages" : msgIds} success:^(id responseObject) {
        if (CPSuccess){
            [self showSuccess:@"删除成功"];
            [self.datas removeObjectsAtIndexes:indexSet];
            [self setEditing:NO animated:YES];
        }else{
            [self showInfo:@"网络异常"];
        }
    } failed:^(NSError *error) {
        [self showInfo:@"网络异常"];
    }];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userIconClick:(NSNotification *)notify
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    vc.targetUserId = notify.userInfo[CPClickUserIconInfo];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)buttonClick
{
    self.coverView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_coverView) {
        _coverView.hidden = YES;
    }
}

@end
