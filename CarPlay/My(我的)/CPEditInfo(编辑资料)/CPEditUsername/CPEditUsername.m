//
//  CPEditUsername.m
//  CarPlay
//
//  Created by 公平价 on 15/10/20.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPEditUsername.h"

@interface CPEditUsername ()

@end

@implementation CPEditUsername

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"修改昵称"];
    [self setRightNavigationBarItemWithTitle:@"保存" Image:nil highImage:nil target:self action:@selector(rightClick)];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.nickname.text=_user.nickname;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)rightClick{
    NSString *urlPath=[NSString stringWithFormat:@"user/%@/info?token=%@",[Tools getUserId],[Tools getToken]];
    NSString *path=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId]];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:_nickname.text,@"nickname", nil];
    [self showLoading];
    [ZYNetWorkTool postJsonWithUrl:urlPath params:params success:^(id responseObject) {
        [ZYUserDefaults setObject:_nickname.text forKey:kUserNickName];
        [self disMiss];
        _user.nickname=_nickname.text;
        [NSKeyedArchiver archiveRootObject:_user toFile:path.documentPath];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError *error) {
        [self disMiss];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存资料失败，请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

@end
