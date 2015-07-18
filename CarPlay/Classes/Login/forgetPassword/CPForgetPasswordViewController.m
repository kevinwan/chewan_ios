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
    if (self.phoneLable.text && ![self.phoneLable.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.phoneLable.text]) {
            [self startTime];
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
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入您的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (IBAction)nextBtnClick:(id)sender {
    CPNewPassWordViewController *CPNewPassWordVC=[[CPNewPassWordViewController alloc]init];
    CPNewPassWordVC.title=@"找回密码";
    [self.navigationController pushViewController:CPNewPassWordVC animated:YES];
}

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
                [self.getIdentifyingCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getIdentifyingCodeBtn.userInteractionEnabled = YES;
                [self.getIdentifyingCodeBtn setBackgroundColor:[Tools getColor:@"fd6d53"]];
                [self.getIdentifyingCodeBtn setTitleColor:[Tools getColor:@"ffffff"] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getIdentifyingCodeBtn setTitle:[NSString stringWithFormat:@"%@S",strTime] forState:UIControlStateNormal];
                self.getIdentifyingCodeBtn.userInteractionEnabled = NO;
                [self.getIdentifyingCodeBtn setBackgroundColor:[Tools getColor:@"f1f1f1"]];
                [self.getIdentifyingCodeBtn setTitleColor:[Tools getColor:@"566c78"] forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}
@end
