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
    if ([Tools isValidatePwd:self.password.text]) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor clearColor];
        hud.labelText=@"加载中…";
        hud.dimBackground=NO;
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
                }
                
                [Tools setValueForKey:_phone key:@"phone"];
                [Tools setValueForKey:[Tools md5EncryptWithString:self.password.text] key:@"password"];
                [hud hide:YES];
            }else{
                NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                [hud hide:YES];
            }
            
            
        } failed:^(NSError *error) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }];
        
    }else{
        if([self.password.text length]==0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入密码，由6-15位数字或者字母组成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码由6-15位数字或者字母组成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
@end
