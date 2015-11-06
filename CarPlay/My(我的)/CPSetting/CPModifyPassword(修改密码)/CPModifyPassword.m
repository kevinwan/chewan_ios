//
//  CPModifyPassword.m
//  CarPlay
//
//  Created by 公平价 on 15/11/6.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPModifyPassword.h"

@interface CPModifyPassword ()

@end

@implementation CPModifyPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"修改密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)confim:(id)sender {
    if (_oldPassword.text && ![_oldPassword.text isEqualToString:@""]) {
        if (_password.text && ![_password.text isEqualToString:@""]) {
            if ([Tools isValidatePassword:_password.text]) {
                if (_confimPassword.text && ![_confimPassword.text isEqualToString:@""]) {
                    if ([_confimPassword.text isEqualToString:_password.text]) {
                        [self showLoading];
                        NSString *path=[NSString stringWithFormat:@"user/%@/password?token=%@",CPUserId,CPToken];
                        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Tools md5EncryptWithString:_oldPassword.text],@"old",[Tools md5EncryptWithString:_password.text],@"new", nil];
                        [ZYNetWorkTool postJsonWithUrl:path params:params success:^(id responseObject) {
                            if (CPSuccess) {
                                [self showInfo:@"密码修改成功"];
                                [self.navigationController popViewControllerAnimated:YES];
                                [ZYUserDefaults setObject:responseObject[@"data"][@"password"] forKey:@"password"];
                            }else{
                                [[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errmsg"]  delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
                            }
                            [self disMiss];
                        } failed:^(NSError *error) {
                             [self disMiss];
                              [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络"  delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
                        }];
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先输入您的确认密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码为6-15位字母和数组的组合" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
    }else{
         [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先输入您的旧密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
}
@end
