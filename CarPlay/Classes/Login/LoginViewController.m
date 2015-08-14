//
//  LoginViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "LoginViewController.h"
#import "CPForgetPasswordViewController.h"
#import "registerViewController.h"
#import "CPMySubscribeModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBtn.layer.cornerRadius=3.0;
    self.loginBtn.layer.masksToBounds=YES;
    [self.userPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)viewWillAppear:(BOOL)animated{
//     设置navigationBar透明的背景颜色，达到透明的效果BIGIN
     self.navigationController.navigationBarHidden=YES;
    self.navigationController.navigationBar.translucent=YES;
//       设置navigationBar透明的背景颜色，达到透明的效果END
   
}

-(void)viewWillDisappear:(BOOL)animated{
    //     设置navigationBar透明的背景颜色，达到透明的效果BIGIN
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent=NO;
    //       设置navigationBar透明的背景颜色，达到透明的效果END
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginBtnClick:(id)sender {
    if (self.userPhone.text && ![self.userPhone.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.userPhone.text]) {
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.color = [UIColor clearColor];
            hud.labelText=@"加载中…";
            hud.dimBackground=NO;
            NSString *password=[Tools md5EncryptWithString:self.password.text];
            NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:self.userPhone.text,@"phone",password,@"password", nil];
            
            [ZYNetWorkTool postJsonWithUrl:@"v1/user/login" params:para success:^(id responseObject) {
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
                        NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:EMuser password:password error:&error];
                        if (!error && loginInfo) {
                            [Tools setValueForKey:@(YES) key:NOTIFICATION_HASLOGIN];
                            [Tools setValueForKey:self.userPhone.text key:@"phone"];
                            [Tools setValueForKey:password key:@"password"];
                            
                            CPOrganizer *organizer= [CPOrganizer objectWithKeyValues:data];
                            NSString *fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"userId"]];
                            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
                            [hud hide:YES];
                            NSLog(@"登陆成功");
                            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
                        }else{
                            [self showError:error.description];
                        }
                    }
                }else{
                    NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    [hud hide:YES];
                }
            }failed:^(NSError *error){
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                [hud hide:YES];
            }];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入您的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)forgetPassword:(id)sender {
    CPForgetPasswordViewController *CPForgetPasswordVC=[[CPForgetPasswordViewController alloc]init];
    CPForgetPasswordVC.title=@"找回密码";
    [self.navigationController pushViewController:CPForgetPasswordVC animated:YES];
}

- (IBAction)registerBtnClick:(id)sender {
    registerViewController *registerVC=[[registerViewController alloc]init];
    registerVC.title=@"注册";
    [self.navigationController pushViewController:registerVC animated:YES];
}
@end
