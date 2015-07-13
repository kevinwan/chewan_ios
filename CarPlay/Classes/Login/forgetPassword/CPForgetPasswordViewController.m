//
//  CPForgetPasswordViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/10.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPForgetPasswordViewController.h"

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
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
