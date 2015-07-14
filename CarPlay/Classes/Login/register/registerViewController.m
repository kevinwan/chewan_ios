//
//  registerViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "registerViewController.h"
#import "CarOwnersCertificationViewController.h"
#import "serviceTermsViewController.h"
#import "CPRegisterStep2ViewController.h"

@interface registerViewController ()
{
    BOOL agreeTheServiceTerms;
}

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getIdentifyingCode.layer.cornerRadius=15.0;
    self.getIdentifyingCode.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=3.0;
    self.nextBtn.layer.masksToBounds=YES;
    agreeTheServiceTerms=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getIdentifyingCodeClick:(id)sender {
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    hud.labelText=@"加载中…";
    hud.dimBackground=NO;
    [[CPNetworkVO sharedInstance] getIdentifyingCodeWithPhone:self.userPhone.text sucess:^(id result){
        [hud hide:YES];
        NSLog(@"%@",result);
//        NSDictionary *data=[result objectForKey:@"data"];
//        if ([data objectForKey:@"token"]) {
//            [Tools setValueForKey:[data objectForKey:@"token"] key:@"token"];
//        }
//        
//        if ([data objectForKey:@"userId"]) {
//            [Tools setValueForKey:[data objectForKey:@"userId"] key:@"userId"];
//        }
    }fail:^(NSError *error){
        
        [hud hide:YES];
    }];

}

- (IBAction)checkBtnClick:(id)sender {
    if (agreeTheServiceTerms) {
        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [self.nextBtn setEnabled:NO];
        agreeTheServiceTerms=NO;
    }else{
        [self.checkBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        [self.nextBtn setEnabled:YES];
        agreeTheServiceTerms=YES;
    }
}

- (IBAction)serviceTermsBtnClick:(id)sender {
    serviceTermsViewController *serviceTermsVC=[[serviceTermsViewController alloc]init];
    serviceTermsVC.title=@"服务条款";
    [self.navigationController pushViewController:serviceTermsVC animated:YES];
}

- (IBAction)nextBtnClick:(id)sender {
    CPRegisterStep2ViewController *CPRegisterStep2VC=[[CPRegisterStep2ViewController alloc]init];
    CPRegisterStep2VC.title=@"注册";
    [self.navigationController pushViewController:CPRegisterStep2VC animated:YES];
    
    
//    if (agreeTheServiceTerms) {
//        if ([Tools isValidateMobile:self.userPhone.text]) {
//            if ([Tools isValidatePwd:self.password.text]) {
//                if ([self.identifyingCodeTextField.text length]==4) {
//                    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.color = [UIColor clearColor];
//                    hud.labelText=@"加载中…";
//                    hud.dimBackground=NO;
//                    [[CPNetworkVO sharedInstance] checkIdentifyingCodeWithPhone:self.userPhone.text code:self.identifyingCodeTextField.text sucess:^(id result){
//                        [hud hide:YES];
//                        CPRegisterStep2ViewController *CPRegisterStep2VC=[[CPRegisterStep2ViewController alloc]init];
//                        CPRegisterStep2VC.title=@"注册";
//                        [self.navigationController pushViewController:CPRegisterStep2VC animated:YES];
//                    }fail:^(NSError *error){
//                        [hud hide:YES];
//                    }];
//                }else{
//                    if ([self.identifyingCodeTextField.text length]==0) {
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    }else{
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"验证码为4位数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    }
//                }
//            }else{
//                if([self.password.text length]==0){
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入由6-15位数字或者字母组成的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                }else{
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码由6-15位数字或者字母组成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//            }
//        }else{
//            if ([self.userPhone.text length]==0) {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }
//        
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未通同意服务条款" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        }
}

@end
