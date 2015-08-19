//
//  LoginViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/8.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "LoginViewController.h"
#import "CPForgetPasswordViewController.h"
#import "registerViewController.h"
#import "CPMySubscribeModel.h"
#import "UMSocial.h"
#import "CPRegisterStep2ViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBtn.layer.cornerRadius=3.0;
    self.loginBtn.layer.masksToBounds=YES;
    self.navigationItem.title=@"登录";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.navigationItem.leftBarButtonItem = self.leftItem;
}

-(void)viewWillAppear:(BOOL)animated{
//     设置navigationBar透明的背景颜色，达到透明的效果BIGIN
    self.navigationController.navigationBar.translucent=NO;
//       设置navigationBar透明的背景颜色，达到透明的效果END
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIBarButtonItem *)rightItem
{
    if (_rightItem == nil) {
        _rightItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"注册" target:self action:@selector(registerBtnClick:)];
    }
    return _rightItem;
}

-(UIBarButtonItem *)leftItem
{
    if (_leftItem == nil) {
        _leftItem = [UIBarButtonItem itemWithNorImage:@"返回" higImage:nil title:nil target:self action:@selector(changeRootController:)];
    }
    return _leftItem;
}

- (IBAction)loginBtnClick:(id)sender {
    if (self.userPhone.text && ![self.userPhone.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.userPhone.text]) {
            [self showLoading];
            NSString *password=[Tools md5EncryptWithString:self.password.text];
            NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:self.userPhone.text,@"phone",password,@"password", nil];
            
            [ZYNetWorkTool postJsonWithUrl:@"v1/user/login" params:para success:^(id responseObject) {
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
                if ([state isEqualToString:@"0"]) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    if ([data objectForKey:@"token"]) {
                        [Tools setValueForKey:[data objectForKey:@"token"] key:@"token"];
                    }
                    
                    if ([data objectForKey:@"userId"]) {
                        [Tools setValueForKey:[data objectForKey:@"userId"] key:@"userId"];
                        EMError *error = nil;
                        NSString *EMuser=[Tools md5EncryptWithString:[data objectForKey:@"userId"]];
                        NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:EMuser password:password error:&error];
                        if (!error && loginInfo) {
                            [Tools setValueForKey:@(YES) key:NOTIFICATION_HASLOGIN];
                            [Tools setValueForKey:self.userPhone.text key:@"phone"];
                            [Tools setValueForKey:password key:@"password"];
                            
                            CPOrganizer *organizer= [CPOrganizer objectWithKeyValues:data];
                            NSString *fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"userId"]];
                            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
                            [self disMiss];
                            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                            [Tools setValueForKey:@(NO) key:@"LoginFrom3Party"];
                            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
                        }else{
                            [self showError:error.description];
                            [self disMiss];
                        }
                    }
                }else{
                    NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    [self disMiss];
                }
            }failed:^(NSError *error){
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                [self disMiss];
            }];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入您的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)forgetPassword:(id)sender {
    CPForgetPasswordViewController *CPForgetPasswordVC=[[CPForgetPasswordViewController alloc]init];
    CPForgetPasswordVC.title=@"找回密码";
    [self.navigationController pushViewController:CPForgetPasswordVC animated:YES];
}

- (void)registerBtnClick:(id)sender {
    registerViewController *registerVC=[[registerViewController alloc]init];
    registerVC.title=@"注册";
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)WeChatLoginClick:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
//            SQLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"uid"] = snsAccount.usid;
            dict[@"username"] = snsAccount.userName;
            dict[@"url"] = snsAccount.iconURL;
            dict[@"channel"] = @"wechat";
            NSString *sign = [NSString stringWithFormat:@"%@wechatcom.gongpingjia.carplay",snsAccount.usid];
            dict[@"sign"] = [Tools md5EncryptWithString:sign];
            [self loginWithDict:dict];
            
        }
    });

}

- (IBAction)QQLoginClick:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
//            NSLog(@"username is %@, uid is %@, token is %@ url is %@ openId is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,snsAccount.openId);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"uid"] = snsAccount.usid;
            dict[@"username"] = snsAccount.userName;
            dict[@"url"] = snsAccount.iconURL;
            dict[@"channel"] = @"wechat";
            NSString *sign = [NSString stringWithFormat:@"%@wechatcom.gongpingjia.carplay",snsAccount.usid];
            dict[@"sign"] = [Tools md5EncryptWithString:sign];
            [self loginWithDict:dict];
            
        }});

}

- (IBAction)sinaWeiboLoginClick:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
//            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"uid"] = snsAccount.usid;
            dict[@"username"] = snsAccount.userName;
            dict[@"url"] = snsAccount.iconURL;
            dict[@"channel"] = @"wechat";
            NSString *sign = [NSString stringWithFormat:@"%@wechatcom.gongpingjia.carplay",snsAccount.usid];
            dict[@"sign"] = [Tools md5EncryptWithString:sign];
            [self loginWithDict:dict];
            
        }});
    
}
//三方登录
- (void)loginWithDict:(NSDictionary *)dict {
    NSString *urlStr = @"v1/sns/login";
    [ZYNetWorkTool postJsonWithUrl:urlStr params:dict success:^(id responseObject) {
        SQLog(@"%@",responseObject);
        if ([responseObject operationSuccess]) {
            NSDictionary *data=[responseObject objectForKey:@"data"];
            if ([data objectForKey:@"userId"]) {
                //这里要处理环信登录
                EMError *error = nil;
                NSString *EMuser=[Tools md5EncryptWithString:[data objectForKey:@"userId"]];
                NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:EMuser password:dict[@"sign"] error:&error];
                if (!error && loginInfo) {
                    [Tools setValueForKey:@(YES) key:NOTIFICATION_HASLOGIN];
                    [Tools setValueForKey:[data objectForKey:@"token"] key:@"token"];
                    [Tools setValueForKey:[data objectForKey:@"userId"] key:@"userId"];
                    
                    CPOrganizer *organizer= [CPOrganizer objectWithKeyValues:data];
                    NSString *fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"userId"]];
                    [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                    
                    [Tools setValueForKey:dict key:THIRDPARTYLOGINACCOUNT];
                    [Tools setValueForKey:@(YES) key:@"LoginFrom3Party"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
                }else{
                    [self showError:error.description];
                }
            } else {
                CPRegisterStep2ViewController *vc = [[CPRegisterStep2ViewController alloc]init];
                vc.title=@"注册";
                vc.snsUid = data[@"snsUid"];
                vc.snsChannel = data[@"snsChannel"];
                vc.snsUserName = data[@"snsUserName"];
                vc.photoUrl = data[@"photoUrl"];
                vc.photoId = data[@"photoId"];
                
                CPOrganizer *organizer= [CPOrganizer objectWithKeyValues:data];
                organizer.headImgId = data[@"photoId"];
                organizer.headImgUrl = data[@"photoUrl"];
                organizer.gender = @"男";
                organizer.nickname = data[@"snsUserName"];
                NSString *fileName=[[NSString alloc]initWithFormat:@"%@.data",data[@"snsUid"]];
                [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
                
                
                [Tools setValueForKey:dict key:THIRDPARTYLOGINACCOUNT];
                [Tools setValueForKey:@(YES) key:@"LoginFrom3Party"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } else {
            [self.view alert:responseObject];
        }
    } failed:^(NSError *error) {
        [self.view alertError:error];
    }];
}
-(void)changeRootController:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ROOTCONTROLLERCHANGETOTAB object:nil];
}
@end
