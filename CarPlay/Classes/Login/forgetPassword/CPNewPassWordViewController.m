//
//  CPNewPassWordViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPNewPassWordViewController.h"

@interface CPNewPassWordViewController ()

@end

@implementation CPNewPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextBtn.layer.cornerRadius=3.0;
    self.nextBtn.layer.masksToBounds=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)nextBtnClick:(id)sender {
    if ([Tools isValidatePwd:self.password.text] && [Tools isValidatePwd:self.confirmPassword.text]) {
        if ([self.password.text isEqualToString:self.confirmPassword.text]) {
            [self showLoading];
            NSDictionary *paras=[[NSDictionary alloc]initWithObjectsAndKeys:_pwd,@"code",_phone,@"phone",[Tools md5EncryptWithString:self.password.text],@"password",nil];
            [ZYNetWorkTool postJsonWithUrl:@"v1/user/password" params:paras success:^(id responseObject) {
                NSLog(@"%@",responseObject);
                
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
                if ([state isEqualToString:@"0"]) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    if ([data objectForKey:@"token"]) {
                        [Tools setValueForKey:[data objectForKey:@"token"] key:@"token"];
                    }
                    
                    if ([data objectForKey:@"userId"]) {
                        [Tools setValueForKey:[data objectForKey:@"userId"] key:@"userId"];
                            EMError *error = nil;
                            NSString *EMuser=[Tools md5EncryptWithString:[data objectForKey:@"userId"]];
                            NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:EMuser password:[Tools md5EncryptWithString:self.password.text] error:&error];
                            if (!error && loginInfo) {
                                [Tools setValueForKey:@(YES) key:NOTIFICATION_HASLOGIN];
                                [Tools setValueForKey:_phone key:@"phone"];
                                [Tools setValueForKey:[Tools md5EncryptWithString:self.password.text] key:@"password"];
                                [self disMiss];
                                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
                            }else{
                                [self showError:error.description];
                                [self disMiss];
                            }
                    }
                    
                    [Tools setValueForKey:_phone key:@"phone"];
                    [Tools setValueForKey:[Tools md5EncryptWithString:self.password.text] key:@"password"];
                    [self disMiss];
                }else{
                    NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    [self disMiss];
                }
                
            } failed:^(NSError *error) {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }];
        }else{
            if ([self.confirmPassword.text length] == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入确认密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的两次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }else{
        if([self.password.text length]==0 || [self.confirmPassword.text length]==0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码，由6-15位数字或者字母组成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码由6-15位数字或者字母组成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
@end
