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
//
     NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:self.userPhone.text,@"phone",nil];
    [ZYNetWorkTool getWithUrl:[[NSString alloc]initWithFormat:@"v1/phone/%@/verification",self.userPhone.text] params:para success:^(id responseObject) {
        [hud hide:YES];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
        if (![state isEqualToString:@"0"]) {
            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];

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
    [self.navigationController pushViewController:CPRegisterStep2VC animated:YES];
    
//    if (agreeTheServiceTerms) {
//        if ([Tools isValidateMobile:self.userPhone.text]) {
//            if ([Tools isValidatePwd:self.password.text]) {
//                if ([self.identifyingCodeTextField.text length]==4) {
//                    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                    hud.color = [UIColor clearColor];
//                    hud.labelText=@"加载中…";
//                    hud.dimBackground=NO;
//                    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:self.identifyingCodeTextField.text,@"code",nil];
//                    [ZYNetWorkTool postJsonWithUrl:[[NSString alloc]initWithFormat:@"v1/phone/%@/verification",self.userPhone.text] params:para success:^(id responseObject) {
//                        [hud hide:YES];
//                        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//                        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
//                        if (![state isEqualToString:@"0"]) {
//                            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
//                            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//                        }else{
//                            CPRegisterStep2ViewController *CPRegisterStep2VC=[[CPRegisterStep2ViewController alloc]init];
//                            CPRegisterStep2VC.title=@"注册";
//                            [Tools setValueForKey:self.userPhone.text key:@"phone"];
//                             NSString *password=[Tools md5EncryptWithString:self.password.text];
//                            [Tools setValueForKey:password key:@"password"];
//                            [Tools setValueForKey:self.identifyingCodeTextField.text key:@"code"];
//                            [self.navigationController pushViewController:CPRegisterStep2VC animated:YES];
//                        }
//                    } failed:^(NSError *error) {
//                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
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
