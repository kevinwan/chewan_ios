//
//  CPForgetPasswordViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/25.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPForgetPasswordViewController.h"

@interface CPForgetPasswordViewController ()

@end

@implementation CPForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title=@"忘记密码";
    [self.verificationCodeBtn.layer setMasksToBounds:YES];
    [self.verificationCodeBtn.layer setCornerRadius:15.0];
    [self.finishBtn.layer setMasksToBounds:YES];
    [self.finishBtn.layer setCornerRadius:20.0];
}

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden=NO;
}

//-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden=YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma 找回密码获取验证码
- (IBAction)verificationCodeBtnClick:(id)sender {
    if (self.phoneField.text && ![self.phoneField.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.phoneField.text]) {
            NSString *path=[[NSString alloc]initWithFormat:@"phone/%@/verification",self.phoneField.text];
            NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"type", nil];
            [ZYNetWorkTool getWithUrl:path params:params success:^(id responseObject) {
                if (CPSuccess) {
                    [self startTime];
                }else{
                    NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            } failure:^(NSError *error) {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                
            }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma 修改密码
- (IBAction)finishBtnClick:(id)sender {
    if (self.phoneField.text && ![self.phoneField.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.phoneField.text]) {
            if (self.verificationCodeField.text && ![self.verificationCodeField.text isEqualToString:@""]) {
                if (self.verificationCodeField.text.length == 4) {
                    if (self.passwordField.text && ![self.passwordField.text isEqualToString:@""]) {
                        if ([Tools isValidatePassword:self.passwordField.text]) {
                            NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:self.phoneField.text,@"phone",self.verificationCodeField.text,@"code",[Tools md5EncryptWithString:self.passwordField.text],@"password", nil];
                            [ZYNetWorkTool postJsonWithUrl:@"user/password" params:params success:^(id responseObject) {
                                if (CPSuccess) {
                                    //登陆环信
                                    NSLog(@"环信账号是:%@,密码是:%@",[Tools md5EncryptWithString:responseObject[@"data"][@"userId"]],[Tools md5EncryptWithString:self.passwordField.text]);
                                    
                                    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[Tools md5EncryptWithString:responseObject[@"data"][@"userId"]] password:[Tools md5EncryptWithString:self.passwordField.text] completion:^(NSDictionary *loginInfo, EMError *error) {
                                        if (!error) {
                                            // 设置自动登录
                                            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                            
                                            if (responseObject[@"data"][@"userId"]) {
                                                [ZYUserDefaults setObject:responseObject[@"data"][@"userId"] forKey:UserId];
                                            }
                                            if (responseObject[@"data"][@"token"]) {
                                                [ZYUserDefaults setObject:responseObject[@"data"][@"token"] forKey:Token];
                                            }
                                            [ZYUserDefaults setObject:responseObject[@"data"][@"phone"] forKey:@"phone"];
                                            [ZYUserDefaults setObject:[Tools md5EncryptWithString:self.passwordField.text] forKey:@"password"];
                                            
                                            [ZYNotificationCenter postNotificationName:NOTIFICATION_HASLOGIN object:nil];
                                        }
                                    } onQueue:nil];
                                    
                                }else{
                                    NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                                    [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                                }
                            } failed:^(NSError *error) {
                                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                                
                            }];
                        }else{
                            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码为6-15位字母和数组的组合" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                        }
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码为四位数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//获取验证码按钮倒计时
-(void)startTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.verificationCodeBtn.userInteractionEnabled = YES;
                [self.verificationCodeBtn setBackgroundColor:GreenColor];
                [self.verificationCodeBtn setTitleColor:[Tools getColor:@"ffffff"] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2dS", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.verificationCodeBtn setTitle:strTime forState:UIControlStateNormal];
                self.verificationCodeBtn.userInteractionEnabled = NO;
                [self.verificationCodeBtn setBackgroundColor:[Tools getColor:@"e5e5e5"]];
                [self.verificationCodeBtn setTitleColor:[Tools getColor:@"ffffff"] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
@end
