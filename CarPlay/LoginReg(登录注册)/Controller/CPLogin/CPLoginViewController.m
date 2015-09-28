//
//  CPLoginViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPLoginViewController.h"
#import "CPRegViewController.h"
#import "CPForgetPasswordViewController.h"
#import "CPNavigationController.h"

@interface CPLoginViewController ()

@end

@implementation CPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.loginBtn.layer setCornerRadius:20.0];
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn.layer setCornerRadius:20.0];
    [self.forgetPasswordBtn setTitleColor:[Tools getColor:@"999999"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 登录
- (IBAction)loginBtnClick:(id)sender {
    
}

#pragma mark - 注册
- (IBAction)registerBtnClick:(id)sender {
    CPRegViewController *registerVC = [UIStoryboard storyboardWithName:@"CPRegViewController" bundle:nil].instantiateInitialViewController;
    CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:registerVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 忘记密码
- (IBAction)forgetPasswordBtnClick:(id)sender {
    CPForgetPasswordViewController *forgetPasswordVC = [UIStoryboard storyboardWithName:@"CPForgetPassword" bundle:nil].instantiateInitialViewController;
    forgetPasswordVC.navigationItem.title=@"忘记密码";
    forgetPasswordVC.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}

#pragma mark - 第三方登录
- (IBAction)thirdpartyLogin:(id)sender {
    
}
@end
