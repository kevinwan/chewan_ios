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
#import "SDImageCache.h"
#import "UMSocial.h"
#import "CPUser.h"
#import "CPBindingPhone.h"

@interface CPLoginViewController ()

@end

@implementation CPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.loginBtn.layer setCornerRadius:20.0];
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn.layer setCornerRadius:20.0];
    self.switchPassword.arrange = CustomSwitchArrangeONLeftOFFRight;
    self.switchPassword.onImage = [UIImage imageNamed:@"SwitchOn"];
    self.switchPassword.offImage = [UIImage imageNamed:@"SwitchOff"];
    self.switchPassword.status = CustomSwitchStatusOff;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    if (ZYScreenHeight == 480) {
        self.headDistance.constant=20.0;
    }
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
    
    if (self.accountField.text && ![self.accountField.text isEqualToString:@""]) {
        if ([Tools isValidateMobile:self.accountField.text]) {
            if (self.passwordField.text && ![self.passwordField.text isEqualToString:@""]) {
                NSDictionary *paras=[[NSDictionary alloc]initWithObjectsAndKeys:self.accountField.text,@"phone",[Tools md5EncryptWithString:self.passwordField.text],@"password",nil];
                [self showLoading];
                [[SDImageCache sharedImageCache] clearMemory];
                [[SDImageCache sharedImageCache] cleanDisk];
                [ZYNetWorkTool postJsonWithUrl:@"user/login" params:paras success:^(id responseObject) {
                    if (CPSuccess) {
                        
                        //登陆环信
                        NSLog(@"环信账号是:%@,密码是:%@",[Tools md5EncryptWithString:responseObject[@"data"][@"userId"]],[Tools md5EncryptWithString:self.passwordField.text]);

                        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[Tools md5EncryptWithString:responseObject[@"data"][@"userId"]] password:[Tools md5EncryptWithString:self.passwordField.text] completion:^(NSDictionary *loginInfo, EMError *error) {
                            if (!error) {
                                //存储个人信息
                               CPUser * user = [CPUser objectWithKeyValues:responseObject[@"data"]];
                                NSString *path=[[NSString alloc]initWithFormat:@"%@.info",responseObject[@"data"][@"userId"]];
                                [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
                                [ZYUserDefaults setObject:responseObject[@"data"][@"nickname"] forKey:kUserNickName];
                                [ZYUserDefaults setObject:responseObject[@"data"][@"avatar"] forKey:kUserHeadUrl];
                                [ZYUserDefaults setObject:responseObject[@"data"][@"age"] forKey:kUserAge];
                                [ZYUserDefaults setObject:responseObject[@"data"][@"gender"] forKey:KUserSex];
                                // 设置自动登录
                                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                                [[EaseMob sharedInstance].chatManager loadDataFromDatabase];

                                if (responseObject[@"data"][@"userId"]) {
                                    [ZYUserDefaults setObject:responseObject[@"data"][@"userId"] forKey:UserId];
                                }
                                if (responseObject[@"data"][@"token"]) {
                                    [ZYUserDefaults setObject:responseObject[@"data"][@"token"] forKey:Token];
                                }
                                [ZYUserDefaults setObject:self.accountField.text forKey:@"phone"];
                                [ZYUserDefaults setObject:[Tools md5EncryptWithString:self.passwordField.text] forKey:@"password"];
                                [ZYNotificationCenter postNotificationName:NOTIFICATION_HASLOGIN object:nil];
                                [self.navigationController popToRootViewControllerAnimated:NO];
                                if (user.album.count > 0) {
                                    [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                                }else{
                                    [ZYUserDefaults setBool:NO forKey:CPHasAlbum];
                                }
                            }else{
                                  [[[UIAlertView alloc]initWithTitle:@"提示" message:error.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                            }
                            [self disMiss];
                        } onQueue:nil];

                    }else{
                        [self disMiss];
                        NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                } failed:^(NSError *error) {
                    [self disMiss];
                    [self showInfo:@"请检查您的手机网络!"];
                    
                }];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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
- (IBAction)thirdpartyLogin:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                    //            SQLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"uid"] = snsAccount.usid;
                    dict[@"nickname"] = snsAccount.userName;
                    dict[@"avatar"] = snsAccount.iconURL;
                    dict[@"channel"] = @"wechat";
                    NSString *sign = [NSString stringWithFormat:@"%@wechatcom.gongpingjia.carplay",snsAccount.usid];
                    dict[@"password"] = [Tools md5EncryptWithString:sign];
                    [self loginWithDict:dict];
                }
            });
            break;
        }
            
        case 2:{
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    
                    NSLog(@"username is %@, uid is %@, token is %@ url is %@ openId is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,snsAccount.openId);
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"uid"] = snsAccount.usid;
                    dict[@"nickname"] = snsAccount.userName;
                    dict[@"avatar"] = snsAccount.iconURL;
                    dict[@"channel"] = @"qq";
                    NSString *sign = [NSString stringWithFormat:@"%@qqcom.gongpingjia.carplay",snsAccount.usid];
                    dict[@"password"] = [Tools md5EncryptWithString:sign];
                    [self loginWithDict:dict];
                    
                }});
            
            break;
        }
            
        case 3:
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    
                    //            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"uid"] = snsAccount.usid;
                    dict[@"nickname"] = snsAccount.userName;
                    dict[@"avatar"] = snsAccount.iconURL;
                    dict[@"channel"] = @"sinaWeibo";
                    NSString *sign = [NSString stringWithFormat:@"%@sinaWeibocom.gongpingjia.carplay",snsAccount.usid];
                    dict[@"password"] = [Tools md5EncryptWithString:sign];
                    [self loginWithDict:dict];
                    
                }});
            break;
        }
    }
}

-(void)loginWithDict:(NSDictionary *)dict{
    [self showLoading];
    [ZYNetWorkTool postJsonWithUrl:@"sns/login" params:dict success:^(id responseObject) {
        if (CPSuccess) {
            if (responseObject[@"data"][@"userId"]) {
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[Tools md5EncryptWithString:responseObject[@"data"][@"userId"]] password:responseObject[@"data"][@"password"] completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error) {
                        //存储个人信息
                        CPUser * user = [CPUser objectWithKeyValues:responseObject[@"data"]];
                        NSString *path=[[NSString alloc]initWithFormat:@"%@.info",responseObject[@"data"][@"userId"]];
                        [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
                        [ZYUserDefaults setObject:responseObject[@"data"][@"nickname"] forKey:kUserNickName];
                        [ZYUserDefaults setObject:responseObject[@"data"][@"avatar"] forKey:kUserHeadUrl];
                        [ZYUserDefaults setObject:responseObject[@"data"][@"age"] forKey:kUserAge];
                        [ZYUserDefaults setObject:responseObject[@"data"][@"gender"] forKey:KUserSex];
                        // 设置自动登录
                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                        [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                        
                        if (responseObject[@"data"][@"userId"]) {
                            [ZYUserDefaults setObject:responseObject[@"data"][@"userId"] forKey:UserId];
                        }
                        if (responseObject[@"data"][@"token"]) {
                            [ZYUserDefaults setObject:responseObject[@"data"][@"token"] forKey:Token];
                        }
                        [ZYUserDefaults setObject:self.accountField.text forKey:@"phone"];
                        [ZYUserDefaults setObject:[Tools md5EncryptWithString:self.passwordField.text] forKey:@"password"];
                        [ZYNotificationCenter postNotificationName:NOTIFICATION_HASLOGIN object:nil];
                        [self.navigationController popToRootViewControllerAnimated:NO];
                        if (user.album.count > 0) {
                            [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                        }else{
                            [ZYUserDefaults setBool:NO forKey:CPHasAlbum];
                        }
                    }
                    [self disMiss];
                } onQueue:nil];
            }else{
                [self disMiss];
                CPBindingPhone *bindingPhone = [UIStoryboard storyboardWithName:@"CPBindingPhone" bundle:nil].instantiateInitialViewController;
                CPUser *user=[CPUser objectWithKeyValues:dict];
                user.avatarId=responseObject[@"data"][@"avatar"];
                user.snsPassword=user.password;
                bindingPhone.user=user;
                CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:bindingPhone];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
        }else{
            [self disMiss];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
        
    } failed:^(NSError *error) {
        [self showInfo:@"请检查您的手机网络!"];
    }];
}

#pragma mark - customSwitch delegate
-(void)customSwitchSetStatus:(CustomSwitchStatus)status
{
    switch (status) {
        case CustomSwitchStatusOn:
            self.passwordField.secureTextEntry=NO;
            break;
        case CustomSwitchStatusOff:
            self.passwordField.secureTextEntry=YES;
            break;
        default:
            break;
    }
}
- (IBAction)close:(id)sender {
    [ZYNotificationCenter postNotificationName:NOTIFICATION_LOGINOUT object:nil];
}
@end
