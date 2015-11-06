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
    [self.navigationController setTitle:@"修改密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)confim:(id)sender {
    if (_oldPassword.text && ![_oldPassword.text isEqualToString:@""]) {
        if (_password.text && ![_password.text isEqualToString:@""]) {
            if ([Tools isValidatePassword:_password.text]) {
                
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
