//
//  CPMyDateViewController.m
//  CarPlay
//
//  Created by chewan on 9/29/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPMyDateViewController.h"
#import "CPBaseViewCell.h"

@interface CPMyDateViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CPActivityModel *> *datas;
@end

@implementation CPMyDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的活动";
    [self.view addSubview:self.tableView];
}
- (void)test
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.datas addObject:@"jajaj"];
        [self.tableView reloadData];  [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - 40 + _tableView.rowHeight) animated:YES];
        
        [self.tableView.footer endRefreshing];
    });
}

/**
 *  加载网络数据
 */
- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Token] = CPToken;
    NSString *url = [NSString stringWithFormat:@"v2/user/%@/appointment",CPUserId];
    [ZYNetWorkTool getWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - dataSource & delegate
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *ID = @"cell";
//    CPBaseViewCell *cell = [CPBaseViewCell cellWithTableView:tableView reuseIdentifier:ID];
//    cell.oneType = NO;
//    return cell;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

#pragma mark - 加载子控件

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        CGFloat offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
        _tableView.rowHeight = 401 + offset;
        _tableView.backgroundColor = [Tools getColor:@"efefef"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        ZYWeakSelf
        _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            ZYStrongSelf
            [self test];
        }];
    }
    return _tableView;
}
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
        [_datas addObject:@"1"];
        [_datas addObject:@"2"];
        [_datas addObject:@"3"];
        [_datas addObject:@"4"];
        [_datas addObject:@"5"];
    }
    return _datas;
}
@end
