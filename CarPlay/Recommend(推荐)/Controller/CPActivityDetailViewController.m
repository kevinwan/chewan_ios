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

@interface CPActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CPActivityDetailFooterView *footerView;
@property (strong, nonatomic) CPActivityDetailHeaderView *headerView;
@property (nonatomic, assign) BOOL isActivityPathOpen;
@property (nonatomic, strong) CPRecommendModel *model;
@property (nonatomic, assign) CGFloat activityPathHeight;
@property (nonatomic, strong) NSMutableArray *datas;
@end

static NSString *ID = @"partCell";
@implementation CPActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"laile" action:^{
        self.headerView.height = 200;
        self.tableView.tableHeaderView = self.headerView;
        self.footerView.height = 200;
        self.tableView.tableFooterView = self.footerView;
    }];
    self.title = @"活动详情";
    [self loadData];
}

- (void)loadData
{
    NSString *url = [NSString stringWithFormat:@"official/activity/%@/info",self.officialActivityId];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = CPUserId;
    param[@"token"] = CPToken;
    [ZYNetWorkTool getWithUrl:url params:param success:^(id responseObject) {
        self.model = [CPRecommendModel objectWithKeyValues:responseObject[@"data"]];
        [self reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)reloadData
{
    self.headerView.model = self.model;
    self.tableView.tableHeaderView = self.headerView;
    self.footerView.model = self.model;
    [self.tableView reloadData];
}

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if ([notifyName isEqualToString:CPActivityDetailOpenPathKey]) {
        self.isActivityPathOpen = !self.isActivityPathOpen;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }else if ([notifyName isEqualToString:CPActivityDetailHeaderDetailOpenKey]){
        self.tableView.tableHeaderView = self.headerView;
    }else if ([notifyName isEqualToString:CPActivityFooterViewOpenKey]){
        self.tableView.tableFooterView = self.footerView;
    }
}

#pragma mark - delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
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
