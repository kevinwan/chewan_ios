//
//  CPActivityDetailViewController.m
//  CarPlay
//
//  Created by chewan on 10/10/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPActivityDetailViewController.h"

@interface CPActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) BOOL open;
@end

@implementation CPActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = self.view.bounds;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"laile" action:^{
        self.headerView.height = 200;
        self.tableView.tableHeaderView = self.headerView;
        self.footerView.height = 200;
        self.tableView.tableFooterView = self.footerView;
    }];
}

#pragma mark - delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.open) {
            return 10;
        }
        return 0;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = @"fsdakldasfjkladfsj";
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"展开.....");
        self.open = !self.open;
        [self.tableView reloadData];
    }];

    return btn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
}

#pragma mark - lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor redColor];
        _headerView.height = 100;
        _headerView.width = ZYScreenWidth;
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor blueColor];
        _footerView.height = 100;
        _footerView.width = ZYScreenWidth;
    }
    return _footerView;
}

@end
