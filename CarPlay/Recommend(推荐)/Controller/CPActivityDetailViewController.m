//
//  CPActivityDetailViewController.m
//  CarPlay
//
//  Created by chewan on 10/10/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDetailViewController.h"
#import "CPRecommendModel.h"
#import "CPActivityDetailHeaderView.h"
#import "CPActivityDetailFooterView.h"
#import "CPActivityDetailMiddleView.h"
#import "CPActivityPartnerCell.h"
#import "CPActivityPathCell.h"
#import "CPTaInfo.h"

#define CPMemberPageNum 4
@interface CPActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CPActivityDetailFooterView *footerView;
@property (strong, nonatomic) CPActivityDetailHeaderView *headerView;
@property (nonatomic, strong) CPRecommendModel *model;
@property (nonatomic, assign) CGFloat activityPathHeight;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSUInteger showMerberCount;
@end

static NSString *ID = @"partCell";
@implementation CPActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.title = @"活动详情";
    [self loadData];
}

- (void)loadData
{
    [self showLoading];
    NSString *url = [NSString stringWithFormat:@"official/activity/%@/info",self.officialActivityId];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = CPUserId;
    param[@"token"] = CPToken;
    [ZYNetWorkTool getWithUrl:url params:param success:^(id responseObject) {
        [self disMiss];
        self.model = [CPRecommendModel objectWithKeyValues:responseObject[@"data"]];
        [self reloadData];
    } failure:^(NSError *error) {
        [self showInfo:@"加载失败"];
    }];
}

- (void)reloadData
{
    self.headerView.model = self.model;
    self.tableView.tableHeaderView = self.headerView;
    self.footerView.model = self.model;
    self.footerView.officialActivityId = self.officialActivityId;
    NSUInteger count = self.model.members.count;
    self.showMerberCount = count > CPMemberPageNum ? CPMemberPageNum : count;
    [self.tableView reloadData];
}

#pragma mark - 事件交互
- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if ([notifyName isEqualToString:CPActivityDetailHeaderDetailOpenKey]){
        self.tableView.tableHeaderView = self.headerView;
    }else if ([notifyName isEqualToString:CPActivityFooterViewOpenKey]){
        self.tableView.tableFooterView = self.footerView;
    }else if ([notifyName isEqualToString:CPActivityDetailLoadMoreKey]){
        if (self.showMerberCount + CPMemberPageNum > self.model.members.count) {
            self.showMerberCount += CPMemberPageNum;
        }else{
            self.showMerberCount = self.model.members.count;
        }
        [self.tableView reloadData];
    }else if ([notifyName isEqualToString:CPClickUserIcon]){
        CPGoLogin(@"查看TA的详情");
        CPTaInfo *taVc = [UIStoryboard storyboardWithName:@"TaInfo" bundle:nil].instantiateInitialViewController;
        taVc.userId = userInfo;
        [self.navigationController pushViewController:taVc animated:YES];
    }
}

#pragma mark - delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showMerberCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPPartMember *partM = self.model.members[indexPath.row];
    if (partM.acceptCount > 0) {
        return 110;
    }else{
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
    
        CPActivityPartnerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        return cell;
//    }else{
//        
//        CPActivityPathCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (cell == nil) {
//            cell = [[CPActivityPathCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        }
//        
//        cell.activityPathText = @"啊看来的时间考虑的是否健康来打发时间来看打发时间来看的方式了肯定撒风景拉斯加福利卡的是减肥了打扫房间大放送骄傲的发生了空间的罚款了巨大是法律进阿飞的说了句反倒是徕卡的时间来看打发时间来看打发时间看来大家看了都放假快乐的方式健康的法律纠纷的刻录机发哦ijfaifjifdjiadf";
//        return cell;
//    }
}


#pragma mark - lazy

- (CPActivityDetailHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView =  [CPActivityDetailHeaderView activityDetailHeaderView];
    }
    return _headerView;
}

- (CPActivityDetailFooterView *)footerView
{
    if (_footerView == nil) {
        _footerView = [CPActivityDetailFooterView activityDetailFooterView];
    }
    return _footerView;
}

#pragma mark - lazy
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

@end
