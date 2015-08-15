//
//  CPCarAuthoFailedController.m
//  CarPlay
//
//  Created by chewan on 15/8/12.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//  认证失败的页面

#import "CPCarAuthoFailedController.h"
#import "CarOwnersCertificationViewController.h"

@interface CPCarAuthoFailedController ()

@end

@implementation CPCarAuthoFailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
}

- (void)setUpSubViews
{
    self.navigationItem.title = @"车主认证通知";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"认证失败"]];
    icon.y = 104;
    icon.centerX = self.view.centerXInSelf;
    [self.view addSubview:icon];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"认证未能通过!";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [Tools getColor:@"fd6d53"];
    [titleLabel sizeToFit];
    titleLabel.centerX = self.view.centerXInSelf;
    titleLabel.y = icon.bottom + 20;
    [self.view addSubview:titleLabel];
    
    UILabel *isAllowLabel = [[UILabel alloc] init];
    
    isAllowLabel.textColor = [Tools getColor:@"434a54"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"您申请的"];
    NSString *carNameStr = [self.model.carModel stringByAppendingString:@"车主"];
    NSAttributedString *carName = [[NSAttributedString alloc] initWithString:carNameStr attributes:@{NSForegroundColorAttributeName : [Tools getColor:@"48d1d5"]}];
    
    [str appendAttributedString:carName];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"身份认证未通过审核"]];

    isAllowLabel.attributedText = str;
    isAllowLabel.font = [UIFont systemFontOfSize:14];
    [isAllowLabel sizeToFit];
    isAllowLabel.centerX = self.view.centerXInSelf;
    isAllowLabel.y = titleLabel.bottom + 15;
    [self.view addSubview:isAllowLabel];
    
    UILabel *msgLabel = [[UILabel alloc] init];
       msgLabel.text = self.model.remarks;
    msgLabel.font = [UIFont systemFontOfSize:10];
    msgLabel.textColor = [Tools getColor:@"aab2bd"];
    [msgLabel sizeToFit];
    msgLabel.centerX = self.view.centerXInSelf;
    msgLabel.y = isAllowLabel.bottom + 15;
    [self.view addSubview:msgLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"重新认证" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = [Tools getColor:@"48d1d5"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.width = self.view.width - 20;
    button.height = 40;
    button.x = 10;
    button.y = msgLabel.bottom + 50;
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

/**
 *  重新进行车主认证
 */
- (void)buttonClick
{
    CarOwnersCertificationViewController *CarOwnersCertificationVC=[[CarOwnersCertificationViewController alloc]init];
    CarOwnersCertificationVC.fromMy=@"0";
    CarOwnersCertificationVC.title=@"车主认证";
    [self.navigationController pushViewController:CarOwnersCertificationVC animated:YES];
}

@end
