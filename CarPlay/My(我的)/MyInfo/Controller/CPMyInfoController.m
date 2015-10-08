//
//  CPMyInfoController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/28.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoController.h"

@interface CPMyInfoController ()

@end

@implementation CPMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"个人信息";
    [self setRightNavigationBarItemWithTitle:nil Image:@"设置" highImage:@"设置" target:self action:@selector(finishBtnClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)finishBtnClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
