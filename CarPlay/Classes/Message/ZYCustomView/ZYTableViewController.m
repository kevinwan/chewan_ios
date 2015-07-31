//
//  ZYTableViewController.m
//  CarPlay
//
//  Created by chewan on 15/7/27.
//  Copyright (c) 2015年 苏兆云. All rights reserved.
//

#import "ZYTableViewController.h"

@interface ZYTableViewController ()
@property (nonatomic, strong) UIView *tipView;
@end

@implementation ZYTableViewController

#pragma mark - lazy
- (UIView *)tipView
{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:self.view.bounds];
        _tipView.hidden = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"网"]];
        imageView.tag = 1;
        imageView.centerX = _tipView.centerXInSelf;
        imageView.centerY = _tipView.centerYInSelf - 50;
        [_tipView addSubview:imageView];
        _tipView.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"网络错误";
        tipLabel.tag = 2;
        tipLabel.x = 0;
        tipLabel.y = imageView.bottom + 20;
        tipLabel.width = kScreenWidth;
        tipLabel.height = 20;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [_tipView addSubview:tipLabel];
        tipLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *subTipLabel = [[UILabel alloc] init];
        subTipLabel.text = @"当前网络不可用,请检查网络哦~";
        subTipLabel.tag = 3;
        subTipLabel.x = 0;
        subTipLabel.y = tipLabel.bottom + 10;
        subTipLabel.width = kScreenWidth;
        subTipLabel.height = 20;
        subTipLabel.textAlignment = NSTextAlignmentCenter;
        [_tipView addSubview:subTipLabel];
        subTipLabel.font = [UIFont systemFontOfSize:12];
        subTipLabel.textColor = [Tools getColor:@"aab2bd"];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 4;
        btn.width = 160;
        btn.height = 40;
        btn.centerX = kScreenWidth * 0.5;
        btn.y = subTipLabel.bottom + 20;
        btn.layer.cornerRadius = 3;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(reRefresh) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setBackgroundColor:[Tools getColor:@"48d1d5"]];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_tipView addSubview:btn];

    }
    return _tipView;
}


#pragma mark - 控制器的生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加入提示信息的View
    [self.navigationController.view insertSubview:[self tipView] belowSubview:self.navigationController.navigationBar];

    // 没有网络的提示
    if (CPNoNetWork){
        [self showNoNetWork];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 防止弹窗不消失
    [SVProgressHUD dismiss];
    
    if (!self.tipView.isHidden) {
        self.tipView.hidden = YES;
    }
}

- (void)dealloc
{
    DLog(@"%@控制器销毁了...",self);
}

#pragma mark - 下面的方法用来设置tableView全屏的分割线

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

/**
 *  controller布局子控件时调用
 */
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 处理提示信息公共事件

- (void)showNoNetWork
{
    [self tipViewWithIcon:@"网" title:@"网络错误" subTitle:@"当前网络不可用,请检查网络哦"];
}

- (void)showNetWorkFailed
{
    [self tipViewWithIcon:@"网" title:@"网络错误" subTitle:@"数据加载失败了,请刷新试试~"];
}

- (void)showNetWorkOutTime
{
    [self tipViewWithIcon:@"网" title:@"网络超时" subTitle:@"亲,你的网络不给力,连接已经超时~"];
}

- (void)showNoData
{
    [self tipViewWithIcon:@"暂无参与" title:@"暂时没有任何数据" subTitle:@"刷新一下试试吧"];
}

- (void)showNoPublish
{
    [self tipViewWithIcon:@"暂无发布" title:@"暂时没有任何发布" subTitle:@"赶紧去添加发布吧"];
}

- (void)showNoSubscribe
{
    [self tipViewWithIcon:@"暂无关注" title:@"暂时没有任何关注" subTitle:@"赶紧去关注吧"];
}

- (void)showNoJoin
{
    [self tipViewWithIcon:@"暂无参与" title:@"暂时没有任何参与" subTitle:@"赶紧去参与吧"];
}

/**
 *  设置提示信息
 *
 *  @param title    标题
 *  @param subTitle 子标题
 */
- (UIView *)tipViewWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle
{
    UIImageView *imageView = (UIImageView *)[self.tipView viewWithTag:1];
    imageView.image = [UIImage imageNamed:icon];
    
    UILabel *tipLabel = (UILabel *)[self.tipView viewWithTag:2];
    tipLabel.text = title;
    
    UILabel *subTipLabel = (UILabel *)[self.tipView viewWithTag:3];
    subTipLabel.text = subTitle;
    self.tipView.hidden = NO;
    return self.tipView;
}

- (void)reRefresh
{
    self.tipView.hidden = YES;
    [self reRefreshData];
}

- (void)reRefreshData
{
    // 子类实现方法,重新刷新
}

@end
