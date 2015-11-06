//
//  CPBindingPhone.m
//  CarPlay
//
//  Created by 公平价 on 15/11/6.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPBindingPhone.h"
#import "CPMyInfoController.h"

@interface CPBindingPhone ()<UITextFieldDelegate>
{
    int newUser;
}
@end

@implementation CPBindingPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"注册"];
    [self.getVerificationCodeBtn.layer setMasksToBounds:YES];
    [self.getVerificationCodeBtn.layer setCornerRadius:15.0];
    [self.bindingBtn.layer setMasksToBounds:YES];
    [self.bindingBtn.layer setCornerRadius:20.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma 获取验证码
- (IBAction)getVerificationCodeBtnClick:(id)sender {
    if (self.phoneField.text && ![self.phoneField.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.phoneField.text]) {
            NSString *path=[[NSString alloc]initWithFormat:@"phone/%@/verification",self.phoneField.text];
            [ZYNetWorkTool getWithUrl:path params:@{@"type":@(newUser)} success:^(id responseObject) {
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

-(void)bindingBtnClick:(id)sender{
    if (newUser) {
        if (self.phoneField.text && ![self.phoneField.text isEqualToString:@""]) {
            if ([Tools isValidateMobile:self.phoneField.text]) {
                if (self.verificationCodeField.text && ![self.verificationCodeField.text isEqualToString:@""]){
                    if (self.verificationCodeField.text.length == 4) {
                        NSDictionary *params=@{@"uid":_user.uid,@"channel":_user.channel,@"snsPassword":_user.password,@"phone":_phoneField.text,@"code":_verificationCodeField.text};
                        [ZYNetWorkTool postJsonWithUrl:@"user/phone/binding" params:params success:^(id responseObject) {
                            if (CPSuccess) {
                                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[Tools md5EncryptWithString:responseObject[@"data"][@"userId"]] password:[Tools md5EncryptWithString:self.passwordField.text] completion:^(NSDictionary *loginInfo, EMError *error) {
                                    if (!error) {
                                        //存储个人信息
                                        CPUser * user = [CPUser objectWithKeyValues:responseObject[@"data"]];
                                        NSString *path=[[NSString alloc]initWithFormat:@"%@.info",responseObject[@"data"][@"userId"]];
                                        [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
                                        [ZYUserDefaults setObject:responseObject[@"data"][@"nickname"] forKey:kUserNickName];
                                        [ZYUserDefaults setObject:responseObject[@"data"][@"avatar"] forKey:kUserHeadUrl];
                                        [ZYUserDefaults setObject:responseObject[@"data"][@"age"] forKey:kUserAge];
                                        [ZYUserDefaults setObject:responseObject[@"data"][@"gender"] forKey:KUserSex];
                                        // 设置自动登录
                                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                                        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                        
                                        if (responseObject[@"data"][@"userId"]) {
                                            [ZYUserDefaults setObject:responseObject[@"data"][@"userId"] forKey:UserId];
                                        }
                                        if (responseObject[@"data"][@"token"]) {
                                            [ZYUserDefaults setObject:responseObject[@"data"][@"token"] forKey:Token];
                                        }
                                        [ZYUserDefaults setObject:_phoneField.text forKey:@"phone"];
                                        [ZYUserDefaults setObject:[Tools md5EncryptWithString:self.passwordField.text] forKey:@"password"];
                                        [ZYNotificationCenter postNotificationName:NOTIFICATION_HASLOGIN object:nil];
                                        [self.navigationController popToRootViewControllerAnimated:NO];
                                        if (user.album.count > 0) {
                                            [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                                        }else{
                                            [ZYUserDefaults setBool:NO forKey:CPHasAlbum];
                                        }
                                    }
                                    [self disMiss];
                                } onQueue:nil];
                            } else {
                                [[[UIAlertView alloc]initWithTitle:nil message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                            }
                        } failed:^(NSError *error) {
                             [[[UIAlertView alloc]initWithTitle:nil message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                        }];
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
    } else {
        if (self.phoneField.text && ![self.phoneField.text isEqualToString:@""]) {
            if ([Tools isValidateMobile:self.phoneField.text]) {
                if (self.verificationCodeField.text && ![self.verificationCodeField.text isEqualToString:@""]){
                    if (self.verificationCodeField.text.length == 4) {
                        if (self.passwordField.text && ![self.passwordField.text isEqualToString:@""]) {
                            if ([Tools isValidatePassword:self.passwordField.text]) {
                                CPMyInfoController *info=[UIStoryboard storyboardWithName:@"CPMyInfoController" bundle:nil].instantiateInitialViewController;
                                _user.phone=_phoneField.text;
                                _user.code=_verificationCodeField.text;
                                _user.password=_passwordField.text;
                                info.user=_user;
                                [self.navigationController pushViewController:info animated:YES];
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

#pragma UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.phoneField.text && ![self.phoneField.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:textField.text]) {
            NSString *path=[NSString stringWithFormat:@"user/%@/register",textField.text];
            [self showLoading];
            [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
                if (CPSuccess) {
                    if (responseObject[@"data"][@"exist"]) {
                        [UIView animateWithDuration:.2 animations:^{
                            [self.passWordView setHidden:YES];
                            self.bindingBtnTop.constant=24;
                            newUser=1;
                        }];
                    }else{
                        [UIView animateWithDuration:.2 animations:^{
                            [self.passWordView setHidden:NO];
                            self.bindingBtnTop.constant=89;
                            newUser=0;
                        }];
                    }
                    [self.bindingBtn setEnabled:YES];
                } else {
                    [[[UIAlertView alloc]initWithTitle:nil message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                }
                [self disMiss];
            } failure:^(NSError *error) {
                [self disMiss];
                [[[UIAlertView alloc]initWithTitle:nil message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }];
        }else{
            [[[UIAlertView alloc]initWithTitle:nil message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
    }else{
        [self.bindingBtn setEnabled:NO];
    }
}
@end
