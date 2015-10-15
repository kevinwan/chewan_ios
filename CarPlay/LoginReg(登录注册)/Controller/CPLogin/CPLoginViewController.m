//
//  CPLoginViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPLoginViewController.h"
#import "CPRegViewController.h"
#import "CPForgetPasswordViewController.h"
#import "CPNavigationController.h"

@interface CPLoginViewController ()

@end

@implementation CPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.loginBtn.layer setCornerRadius:20.0];
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn.layer setCornerRadius:20.0];
    self.switchPassword.arrange = CustomSwitchArrangeONLeftOFFRight;
    self.switchPassword.onImage = [UIImage imageNamed:@"SwitchOn"];
    self.switchPassword.offImage = [UIImage imageNamed:@"SwitchOff"];
    self.switchPassword.status = CustomSwitchStatusOff;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    if (ZYScreenHeight == 480) {
        self.headDistance.constant=20.0;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 登录
- (IBAction)loginBtnClick:(id)sender {
    if (self.accountField.text && ![self.accountField.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.accountField.text]) {
            if (self.passwordField.text && ![self.passwordField.text isEqualToString:@""]) {
                NSDictionary *paras=[[NSDictionary alloc]initWithObjectsAndKeys:self.accountField.text,@"phone",[Tools md5EncryptWithString:self.passwordField.text],@"password",nil];
                [self showLoading];
                [ZYNetWorkTool postJsonWithUrl:@"user/login" params:paras success:^(id responseObject) {
                    if (CPSuccess) {
                        if (responseObject[@"data"][@"userId"]) {
                            [ZYUserDefaults setObject:responseObject[@"data"][@"userId"] forKey:UserId];
                        }
                        if (responseObject[@"data"][@"token"]) {
                            [ZYUserDefaults setObject:responseObject[@"data"][@"token"] forKey:Token];
                        }
                        [ZYUserDefaults setObject:self.accountField.text forKey:@"phone"];
                        [ZYUserDefaults setObject:[Tools md5EncryptWithString:self.passwordField.text] forKey:@"password"];
                        
                        [ZYNotificationCenter postNotificationName:NOTIFICATION_HASLOGIN object:nil];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }else{
                        NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                    [self disMiss];
                } failed:^(NSError *error) {
                    [self disMiss];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    
                }];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
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

#pragma mark - 注册
- (IBAction)registerBtnClick:(id)sender {
    CPRegViewController *registerVC = [UIStoryboard storyboardWithName:@"CPRegViewController" bundle:nil].instantiateInitialViewController;
    CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:registerVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 忘记密码
- (IBAction)forgetPasswordBtnClick:(id)sender {
    CPForgetPasswordViewController *forgetPasswordVC = [UIStoryboard storyboardWithName:@"CPForgetPassword" bundle:nil].instantiateInitialViewController;
    forgetPasswordVC.navigationItem.title=@"忘记密码";
    forgetPasswordVC.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}

#pragma mark - 第三方登录
- (IBAction)thirdpartyLogin:(id)sender {
    
}

#pragma mark - customSwitch delegate
-(void)customSwitchSetStatus:(CustomSwitchStatus)status
{
    switch (status) {
        case CustomSwitchStatusOn:
            self.passwordField.secureTextEntry=NO;
            break;
        case CustomSwitchStatusOff:
            self.passwordField.secureTextEntry=YES;
            break;
        default:
            break;
    }
}
@end
