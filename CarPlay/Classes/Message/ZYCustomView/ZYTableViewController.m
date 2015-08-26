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
@property (nonatomic, strong) UIImageView *coverView;
@end

@implementation ZYTableViewController

#pragma mark - lazy
/**
 *  创建提示View
 */
- (UIView *)tipView
{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:self.view.bounds];
        _tipView.y = -44;
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    // 加入提示信息的View 开始时默默隐藏
    [self.tableView addSubview:[self tipView]];
}

#pragma mark 截图
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 没有网络的提示
    if (CPNoNetWork && self.isShowNoNetWork){
        [self showNoNetWork];
    }
    
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

#pragma mark - 处理提示信息公共事件

- (void)showNoNetWork
{
    [self tipViewWithIcon:@"网" title:@"网络错误" subTitle:@"当前网络不可用,请检查网络哦" buttonTitle:@"重新加载" isShow:YES];
}

- (void)showNetWorkFailed
{
    [self tipViewWithIcon:@"网" title:@"网络错误" subTitle:@"数据加载失败了,请刷新试试~" buttonTitle:@"重新加载" isShow:YES];
}

- (void)showNetWorkOutTime
{
    [self tipViewWithIcon:@"网" title:@"网络超时" subTitle:@"亲,你的网络不给力,连接已经超时~" buttonTitle:@"重新加载" isShow:YES];
}

- (void)showNoData
{
    [self tipViewWithIcon:@"暂无发布" title:@"" subTitle:@"暂无更多数据,刷新一下试试吧" buttonTitle:@"重新加载" isShow:YES];
}

- (void)showNoPublish
{
    [self tipViewWithIcon:@"暂无发布" title:@"" subTitle:@"还没有发布任何活动,赶紧添加吧" buttonTitle:@"马上去发布" isShow:YES];
}

- (void)showNoSubscribe
{
    [self tipViewWithIcon:@"暂无收藏" title:@"" subTitle:@"还没有添加任何收藏" buttonTitle:nil isShow:NO];
}

- (void)showNoJoin
{
    [self tipViewWithIcon:@"暂无参与" title:@"" subTitle:@"还没有参与任何活动,赶紧去参与吧" buttonTitle:nil isShow:NO];
}

- (void)showNoSubscribePerson
{
    [self tipViewWithIcon:@"暂无关注" title:@"" subTitle:@"您还没有关注任何人" buttonTitle:nil isShow:NO];
}
/**
 *  设置提示信息
 *
 *  @param title    标题
 *  @param subTitle 子标题
 */
- (UIView *)tipViewWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle isShow:(BOOL)show
{
    self.tableView.scrollEnabled = NO;
    UIImageView *imageView = (UIImageView *)[self.tipView viewWithTag:1];
    imageView.image = [UIImage imageNamed:icon];
    
    UILabel *tipLabel = (UILabel *)[self.tipView viewWithTag:2];
    tipLabel.text = title;
    
    
    UILabel *subTipLabel = (UILabel *)[self.tipView viewWithTag:3];
    if (title.length == 0) {
        subTipLabel.y = tipLabel.y;
    }
    subTipLabel.text = subTitle;
    
    UIButton *button = (UIButton *)[self.tipView viewWithTag:4];
    if (title.length == 0) {
        button.y = subTipLabel.bottom + 20;
    }
    if (show) {
        button.hidden = NO;
    }else{
        button.hidden = YES;
    }
    
    if ([subTitle contains:@"发布"]) {
        [button removeTarget:self action:@selector(reRefresh) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(createActivity) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [button removeTarget:self action:@selector(createActivity) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(reRefresh) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (buttonTitle.length) {
        [button setTitle:buttonTitle forState:UIControlStateNormal];
    }
    
    self.tipView.hidden = NO;
    self.tipView.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.tipView.alpha = 1.0;
    }];
    return self.tipView;
}

- (void)reRefresh
{

    self.tableView.scrollEnabled = YES;
    self.tipView.hidden = YES;
    self.tableView.footer.hidden = YES;
    ZYJumpToLoginView
    [self reRefreshData];
}

- (void)reRefreshData
{
    // 子类实现方法,重新刷新
}

- (void)createActivity
{
    self.tableView.scrollEnabled = YES;
    // 子类实现方法,跳转至创建活动界面
}

@end
