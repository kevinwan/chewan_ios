//
//  CPMapSearchViewController.m
//  CarPlay
//
//  Created by chewan on 15/8/12.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPMapSearchViewController.h"
#import "ZYSearchBar.h"
#import <AMapSearchKit/AMapSearchAPI.h>
@interface CPMapSearchViewController ()<UITextFieldDelegate, AMapSearchDelegate>
@property (nonatomic, strong) ZYSearchBar *searchBar;
@property (nonatomic, weak) UIView *titileView;
@property (nonatomic, strong) AMapSearchAPI *searchApi;
@property (nonatomic, strong) NSMutableArray *tips;
@end

@implementation CPMapSearchViewController

- (NSMutableArray *)tips
{
    if (_tips == nil) {
        _tips = [NSMutableArray array];
    }
    return _tips;
}

- (AMapSearchAPI *)searchApi
{
    if (_searchApi == nil) {
        _searchApi = [[AMapSearchAPI alloc] initWithSearchKey:GaoDeAppKey Delegate:self];
    }
    return _searchApi;
}

#pragma mark - 视图加载生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setUpSubView];
}

/**
 *  初始化子控件
 */
- (void)setUpSubView
{
    UIView *titleView = [[UIView alloc] init];
    titleView.x = 40;
    titleView.y = 5;
    titleView.width = kScreenWidth - 60;
    titleView.height = 35;
    
    ZYSearchBar *searchBar = [[ZYSearchBar alloc] init];
    UIView *view = [UIView new];
    view.width = 10;
    searchBar.leftView = view;
    searchBar.placeholder = @"输入您的目的地";
    searchBar.frame = CGRectMake(0, 0, titleView.width - 40, titleView.height);
    [titleView addSubview:searchBar];
    [searchBar addTarget:self action:@selector(inputTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 3;
    btn.clipsToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setBackgroundColor:[Tools getColor:@"fd6d53"]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(searchBar.right - 1, 1 , 45, 33);
    [btn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    
    [self.navigationController.navigationBar addSubview:titleView];
    self.titileView = titleView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 57;
    
    if (self.forValue) {
        searchBar.text = self.forValue;
        searchBar.placeholder = self.forValue;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.titileView removeFromSuperview];
}

#pragma mark - 处理文本搜索

- (void)inputTextDidChange:(ZYSearchBar *)searchBar
{
    [self searchTipsWithKey:searchBar.text];
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.searchApi AMapInputTipsSearch:tips];
}

/**
 *  显示模糊搜索的数据
 */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips removeAllObjects];
    if (response.tips.count) {
        [self.tips addObjectsFromArray:response.tips];
    }
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID  = @"cell";
    ZYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZYTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.imageView.image = [UIImage imageNamed:@"定位icon"];
        cell.detailTextLabel.textColor = [Tools getColor:@"aab2bd"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [Tools getColor:@"434a54"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[Tools getColor:@"fd6d53"] forState:UIControlStateNormal];
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"选定" forState:UIControlStateNormal];
        [button sizeToFit];
        cell.accessoryView = button;
    }
    AMapTip *tip = self.tips[indexPath.row];
    NSRange regexRange = [tip.name rangeOfString:self.searchBar.text.trimStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tip.name];
    [str setAttributes:@{NSForegroundColorAttributeName : [Tools getColor:@"48d1d5"]} range:regexRange];
    cell.textLabel.attributedText = str;
    cell.detailTextLabel.text = tip.district;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.look) {
        self.look(self.tips[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)go:(UIButton *)button
{
    if (self.go) {
        self.go(self.tips[button.tag]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchBtnClick
{
    if (self.search) {
        self.search(self.searchBar.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
