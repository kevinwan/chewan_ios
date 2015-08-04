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
#import "AppAppearance.h"
#import "CPTaDetailsController.h"

@interface CPNewMessageController ()

@property (nonatomic, strong) NSCache *cellHeights;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@end

@implementation CPNewMessageController

#pragma mark - lazy

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
        [_deleteBtn setBackgroundColor:[AppAppearance redColor]];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.view insertSubview:_deleteBtn belowSubview:self.navigationController.navigationBar];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}


- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSCache *)cellHeights
{
    if (_cellHeights == nil) {
        _cellHeights = [[NSCache alloc] init];
    }
    return _cellHeights;
}

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新的留言";
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    ZYJumpToLoginView // 跳转到登录页面
    
    [CPNotificationCenter addObserver:self selector:@selector(tableViewEdit:) name:CPNewMsgEditNotifycation object:nil];
    [CPNotificationCenter addObserver:self selector:@selector(userIconClick:) name:CPClickUserIconNotification object:nil];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self showLoading];
    [self loadData];
}

- (void)reRefreshData
{
    [self.tableView.header beginRefreshing];
}

- (void)loadData
{

    NSString *url = [NSString stringWithFormat:@"/v1/user/%@/message/list?token=%@&type=comment",[Tools getValueFromKey:@"userId"],[Tools getValueFromKey:@"token"]];
    [ZYNetWorkTool getWithUrl:url params:nil success:^(id responseObject) {
        [self disMiss];
        [self.tableView.header endRefreshing];
        if (CPSuccess) {
            // 清除之前的数据
            [self.items removeAllObjects];
            
            NSArray *array = [CPNewMsgModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.items addObjectsFromArray:array];
            if (self.items.count == 0) {
                [self showNoData];
            }
            [self.tableView reloadData];
        }else{
            [self showNetWorkFailed];
        }
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self showNetWorkOutTime];
    }];
}

- (void)tableViewEdit:(NSNotification *)notify
{
    if (self.editing == NO) {
        NSNumber *rowNum = notify.userInfo[CPNewMsgEditInfo];
        CPNewMsgModel *model = self.items[rowNum.intValue];
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
    static NSString *ID = @"NewMsgCell";
    CPNewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    CPNewMsgModel *model = [self.items objectAtIndex:indexPath.row];
    model.row = indexPath.row;
    cell.model = model;
    [self.cellHeights setObject:@(cell.cellHeight) forKey:@(indexPath.row)];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

/**
 *  单元格选中效果
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPNewMsgModel *model = [self.items objectAtIndex:indexPath.row];
    
    if (self.editing)
    {
        model.isChecked = !model.isChecked;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - 处理导航条按钮点击
/**
 *  全选
 */
- (void)selectAll
{
    [self.items enumerateObjectsUsingBlock:^(CPNewMsgModel *obj, NSUInteger idx, BOOL *stop) {
        [obj setIsChecked:YES];
    }];
    [self.tableView reloadData];
}

/**
 *  取消选中
 */
- (void)cancleSelect
{
    [self.items enumerateObjectsUsingBlock:^(CPNewMsgModel *obj, NSUInteger idx, BOOL *stop) {
        [obj setIsChecked:NO];
    }];
    [self setEditing:NO animated:YES];
}

- (void)deleteCell
{
    // 必须先获取选中的cell
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSUInteger i = 0; i < self.items.count; i++) {
        CPNewMsgModel *model = self.items[i];
        if (model.isChecked) {
            [indexSet addIndex:i];
        }
    }
    [self.items removeObjectsAtIndexes:indexSet];
    [self setEditing:NO animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userIconClick:(NSNotification *)notify
{
    CPTaDetailsController *vc = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil].instantiateInitialViewController;
    vc.userId1 = notify.userInfo[CPClickUserIconInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
