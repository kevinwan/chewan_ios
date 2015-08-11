//
//  CPEditUsernameViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/16.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPEditUsernameViewController.h"
#import "CPMySubscribeModel.h"

@interface CPEditUsernameViewController ()

@end

@implementation CPEditUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarWithText:@"保存"];
    NSString *fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"phone"]];
    
    if ([NSKeyedUnarchiver unarchiveObjectWithFile:fileName]) {
        CPOrganizer *organizer = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        self.nicknameLable.text = organizer.nickname;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)rightBarClick:(id)sender {
    NSString *fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"phone"]];
    if (![self.nicknameLable.text isEqualToString:@""]) {
        if ([NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(fileName)]) {
            CPOrganizer *organizer=[NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(fileName)];
            organizer.nickname=self.nicknameLable.text;
            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
        }else{
            CPOrganizer *organizer=[[CPOrganizer alloc]init];
            organizer.nickname=self.nicknameLable.text;
            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
