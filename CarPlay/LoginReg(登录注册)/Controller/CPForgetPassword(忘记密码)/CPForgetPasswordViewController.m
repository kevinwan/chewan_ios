//
//  CPForgetPasswordViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/25.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPForgetPasswordViewController.h"

@interface CPForgetPasswordViewController ()

@end

@implementation CPForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title=@"忘记密码";
    [self.verificationCodeBtn.layer setMasksToBounds:YES];
    [self.verificationCodeBtn.layer setCornerRadius:15.0];
    [self.finishBtn.layer setMasksToBounds:YES];
    [self.finishBtn.layer setCornerRadius:20.0];
}

-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden=NO;
}

//-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden=YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verificationCodeBtnClick:(id)sender {
}
@end
