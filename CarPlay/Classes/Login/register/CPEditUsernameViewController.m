//
//  CPEditUsernameViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/16.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPEditUsernameViewController.h"

@interface CPEditUsernameViewController ()

@end

@implementation CPEditUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarWithText:@"保存"];
    if ([Tools getValueFromKey:@"nickname"]) {
        self.nicknameLable.text=[Tools getValueFromKey:@"nickname"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)rightBarClick:(id)sender {
    if (![self.nicknameLable.text isEqualToString:@""]) {
        [Tools setValueForKey:self.nicknameLable.text key:@"nickname"];
        NSLog(@"%@",[Tools getValueFromKey:@"nickname"]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
