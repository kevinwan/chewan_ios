//
//  LoginViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)forgetPassword:(id)sender;
- (IBAction)registerBtnClick:(id)sender;
- (IBAction)WeChatLoginClick:(id)sender;
- (IBAction)QQLoginClick:(id)sender;
- (IBAction)sinaWeiboLoginClick:(id)sender;

@end
