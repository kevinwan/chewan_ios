//
//  LoginViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "LoginViewController.h"
#import "CPForgetPasswordViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBtn.layer.cornerRadius=3.0;
    self.loginBtn.layer.masksToBounds=YES;
}

-(void)viewWillAppear:(BOOL)animated{
//     设置navigationBar透明的背景颜色，达到透明的效果BIGIN
     self.navigationController.navigationBarHidden=YES;
//    NSArray *list=self.navigationController.navigationBar.subviews;
//    for (id obj in list) {
//        if([obj isKindOfClass:[UIImageView class]]){
//            UIImageView *imageView=(UIImageView *)obj;
//            imageView.hidden=YES;
//        }
//    }
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, -20, 320, 64)];
//    imageView.image=[UIImage imageNamed:@"TransparentBg.png"];
//    [self.navigationController.navigationBar addSubview:imageView];
//    [self.navigationController.navigationBar sendSubviewToBack:imageView];
//    
//    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=YES;
//       设置navigationBar透明的背景颜色，达到透明的效果END
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loginBtnClick:(id)sender {
    if ([Tools isValidateMobile:self.userPhone.text]) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor clearColor];
        hud.labelText=@"加载中…";
        hud.dimBackground=NO;
        NSString *password=[Tools md5EncryptWithString:self.password.text];
        [[CPNetworkVO sharedInstance] loginWithusername:self.userPhone.text pwd:password sucess:^(id result){
            [hud hide:YES];
            NSDictionary *data=[result objectForKey:@"data"];
            if ([data objectForKey:@"token"]) {
                [Tools setValueForKey:[data objectForKey:@"token"] key:@"token"];
            }
            
            if ([data objectForKey:@"userId"]) {
                [Tools setValueForKey:[data objectForKey:@"userId"] key:@"userId"];
            }
        }fail:^(NSError *error){
            
            [hud hide:YES];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
    }
}

- (IBAction)forgetPassword:(id)sender {
    CPForgetPasswordViewController *CPForgetPasswordVC=[[CPForgetPasswordViewController alloc]init];
    CPForgetPasswordVC.title=@"找回密码";
    [self.navigationController pushViewController:CPForgetPasswordVC animated:YES];
}

- (IBAction)registerBtnClick:(id)sender {
    
}
@end
