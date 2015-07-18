//
//  CPForgetPasswordViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/10.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPForgetPasswordViewController.h"
#import "CPNewPassWordViewController.h"

@interface CPForgetPasswordViewController ()

@end

@implementation CPForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getIdentifyingCodeBtn.layer.cornerRadius=15.0;
    self.getIdentifyingCodeBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=3.0;
    self.nextBtn.layer.masksToBounds=YES;
//    NSLog(@"%@",self.navigationItem);
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent=NO;
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (IBAction)getIdentifyingCodeBtnClick:(id)sender {
    if ([Tools isValidateMobile:self.phoneLable.text]) {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor clearColor];
        hud.labelText=@"加载中…";
        hud.dimBackground=NO;
        //
        NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:self.phoneLable.text,@"phone",nil];
        [ZYNetWorkTool getWithUrl:[[NSString alloc]initWithFormat:@"/v1/phone/%@/verification",self.phoneLable.text] params:para success:^(id responseObject) {
            [hud hide:YES];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
            if (![state isEqualToString:@"0"]) {
                NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                [hud hide:YES];
            }
        } failure:^(NSError *error) {
            [hud hide:YES];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            [hud hide:YES];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)nextBtnClick:(id)sender {
    CPNewPassWordViewController *CPNewPassWordVC=[[CPNewPassWordViewController alloc]init];
    CPNewPassWordVC.title=@"找回密码";
    [self.navigationController pushViewController:CPNewPassWordVC animated:YES];
}
@end
