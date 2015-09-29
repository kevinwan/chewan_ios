//
//  CPNearViewController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNearViewController.h"
#import "CPBaseViewCell.h"
#import "CPMySwitch.h"

@interface CPNearViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CPActivityModel *> *datas;
@property (nonatomic, strong) UIView *tipView;

@end

@implementation CPNearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"筛选" target:self action:@selector(filter)];
    [self.view addSubview:self.tableView];
    [self tipView];
    ZYWeakSelf
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ZYStrongSelf
        [self test];
    }];
}

- (void)filter
{
    NSLog(@"伟业");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeContactAdd]];
}

- (void)test
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.datas addObject:@"jajaj"];
        [self.tableView reloadData];  [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - 40 + _tableView.rowHeight) animated:YES];
        
        [self.tableView.footer endRefreshing];
    });
}

#pragma mark - dataSource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    CPBaseViewCell *cell = [CPBaseViewCell cellWithTableView:tableView reuseIdentifier:ID];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (UIView *)tipView
{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = ZYColor(0, 0, 0, 0.7);
        [self.view addSubview:_tipView];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@64);
            make.width.equalTo(self.view);
            make.height.equalTo(@35);
        }];
        
        UILabel *textL = [UILabel labelWithText:@"有空,其他人可以邀请你参加活动" textColor:[UIColor whiteColor] fontSize:14];
        [_tipView addSubview:textL];
        [textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(_tipView);
        }];
        
        CPMySwitch *freeTimeBtn = [CPMySwitch new];
        [freeTimeBtn setOnImage:[UIImage imageNamed:@"btn_youkong"]];
        [freeTimeBtn setOffImage:[UIImage imageNamed:@"btn_meikong"]];
        freeTimeBtn.on = YES;
        [_tipView addSubview:freeTimeBtn];
        [[freeTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(CPMySwitch *btn) {
            btn.on = !btn.on;
            if (btn.on) {
                textL.text = @"有空,其他人可以邀请你参加活动";
            }else{
                textL.text = @"没空,你将接受不到任何活动邀请";
            }
        }];
        [freeTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipView);
            make.right.equalTo(@-10);
        }];
    }
    return _tipView;
}

@end
