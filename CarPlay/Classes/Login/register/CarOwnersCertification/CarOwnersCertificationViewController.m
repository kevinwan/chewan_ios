//
//  CarOwnersCertificationViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CarOwnersCertificationViewController.h"

@interface CarOwnersCertificationViewController ()

@end

@implementation CarOwnersCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView=self.headView;
    self.tableView.tableFooterView=self.footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)nextBtnClick:(id)sender {
}
@end
