//
//  CPEditUsernameViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/16.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPEditUsernameViewController.h"
#import "CPMySubscribeModel.h"

@interface CPEditUsernameViewController ()<UITextFieldDelegate>
{
    CPOrganizer *organizer;
    NSString *fileName;
}
@end

@implementation CPEditUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    [self setRightBarWithText:@"保存"];
    [_nicknameLable addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated{
    
    fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"phone"]];
    if (_thirdPartyAccount) {
        fileName=[[NSString alloc]initWithFormat:@"%@.data",_thirdPartyAccount[@"uid"]];
    }
    if (!_organizer && [NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(fileName)]) {
         organizer= [NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(fileName)];
        
    }else if (_organizer){
        organizer= _organizer;
    }
    self.nicknameLable.text = organizer.nickname;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)rightBarClick:(id)sender {
    if (![self.nicknameLable.text isEqualToString:@""]) {
        if ([NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(fileName)]) {
            CPOrganizer *organizer1=[NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(fileName)];
            organizer1.nickname=self.nicknameLable.text;
            [NSKeyedArchiver archiveRootObject:organizer1 toFile:CPDocmentPath(fileName)];
            if (_organizer) {
                NSDictionary *para=[[NSDictionary alloc]initWithObjectsAndKeys:self.nicknameLable.text,@"nickname", nil];
                [self updataUserInfo:para];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            CPOrganizer *organizer=[[CPOrganizer alloc]init];
            organizer.nickname=self.nicknameLable.text;
            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [Tools setValueForKey:self.nicknameLable.text key:@"nickName"];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)updataUserInfo:(NSDictionary *)paras{
    NSString *path=[[NSString alloc]initWithFormat:@"v1/user/%@/info?token=%@",[Tools getValueFromKey:@"userId"],[Tools getValueFromKey:@"token"]];
    [self showLoadingWithInfo:@"加载中…"];
    [ZYNetWorkTool postJsonWithUrl:path params:paras success:^(id responseObject) {
        [self disMiss];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
        if ([state isEqualToString:@"0"]) {
            if ([paras objectForKey:@"nickname"]) {
                [Tools setValueForKey:[paras objectForKey:@"nickname"] key:@"nickName"];
            }
            
            organizer.nickname = self.nicknameLable.text;
           NSString *fileName1=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"userId"]];

            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName1)];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    } failed:^(NSError *error) {
        [self disMiss];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _nicknameLable) {
        if (textField.text.length > 7) {
            textField.text = [textField.text substringToIndex:7];
        }
    }
}

@end
