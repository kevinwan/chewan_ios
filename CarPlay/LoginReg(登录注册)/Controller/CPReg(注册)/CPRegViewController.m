//
//  CPRegViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/25.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPRegViewController.h"
#import "CPMyInfoController.h"

@interface CPRegViewController ()

@end

@implementation CPRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册"];
    [self setLeftNavigationBarItemWithTitle:nil Image:@"Close" highImage:@"Close" target:self action:@selector(dismissPresentVC)];
    [self.getVerificationCodeBtn.layer setMasksToBounds:YES];
    [self.getVerificationCodeBtn.layer setCornerRadius:15.0];
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn.layer setCornerRadius:20.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 关闭注册窗口
-(void)dismissPresentVC{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma 获取验证码
- (IBAction)getVerificationCodeBtnClick:(id)sender {
    
    if (self.phoneField.text && ![self.phoneField.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.phoneField.text]) {
            NSString *path=[[NSString alloc]initWithFormat:@"phone/%@/verification",self.phoneField.text];
            [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
                if (CPSuccess) {
                    self.verificationCodeWeight.constant=53.0f;
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

#pragma 手机号注册
- (IBAction)registerBtnClick:(id)sender {
    if (self.phoneField.text && ![self.phoneField.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.phoneField.text]) {
            if (self.verificationCodeField.text && ![self.verificationCodeField.text isEqualToString:@""]) {
                if (self.verificationCodeField.text.length == 4) {
                    if (self.passwordField.text && ![self.passwordField.text isEqualToString:@""]) {
                        if ([Tools isValidatePassword:self.passwordField.text]) {
                            NSString *path=[[NSString alloc]initWithFormat:@"phone/%@/verification" ,self.phoneField.text];
                            NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:self.verificationCodeField.text,@"code", nil];
                            [ZYNetWorkTool postJsonWithUrl:path params:params success:^(id responseObject) {
                                if (CPSuccess) {
                                    CPMyInfoController *myInfoVC = [UIStoryboard storyboardWithName:@"CPMyInfoController" bundle:nil].instantiateInitialViewController;
                                    myInfoVC.code=self.verificationCodeField.text;
                                    CPUser *user=[[CPUser alloc]init];
                                    user.phone=self.phoneField.text;
                                    myInfoVC.user=user;
                                    myInfoVC.password=[Tools md5EncryptWithString:self.passwordField.text];
                                    [self.navigationController pushViewController:myInfoVC animated:YES];
                                    
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

#pragma 第三方注册
- (IBAction)thirdpartyRegister:(id)sender {
    
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
                self.verificationCodeWeight.constant=90.0f;
                [self.getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getVerificationCodeBtn.userInteractionEnabled = YES;
                [self.getVerificationCodeBtn setBackgroundColor:GreenColor];
                [self.getVerificationCodeBtn setTitleColor:[Tools getColor:@"ffffff"] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2dS", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getVerificationCodeBtn setTitle:strTime forState:UIControlStateNormal];
                self.getVerificationCodeBtn.userInteractionEnabled = NO;
                [self.getVerificationCodeBtn setBackgroundColor:[Tools getColor:@"e5e5e5"]];
                [self.getVerificationCodeBtn setTitleColor:[Tools getColor:@"ffffff"] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
@end
