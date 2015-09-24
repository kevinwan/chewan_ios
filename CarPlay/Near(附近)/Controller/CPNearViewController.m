//
//  CPNearViewController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNearViewController.h"
#import "CPNearViewCell.h"

@interface CPNearViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation CPNearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    ZYWeakSelf
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ZYStrongSelf
        [self test];
    }];
}

- (void)test
{
    
    [self.tableView.footer endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        [self.datas addObject:@"jajaj"];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datas.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + 401) animated:YES];
    });
}

#pragma mark - dataSource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    CPNearViewCell *cell = [CPNearViewCell cellWithTableView:tableView reuseIdentifier:ID];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
#pragma mark - 处理事件交互
- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    NSLog(@"%@ %@ ",notifyName, userInfo);
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
