//
//  CPTaInfo.m
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPTaInfo.h"

@interface CPTaInfo ()<UIAlertViewDelegate>

@end

@implementation CPTaInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"TA的详情"];
    [self.attentionBtn.layer setMasksToBounds:YES];
    [self.attentionBtn.layer setCornerRadius:17.0];
    [self.uploadBtn.layer setMasksToBounds:YES];
    [self.uploadBtn.layer setCornerRadius:17.0];
    self.noImgView.alpha=0.35;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//获取TA的详情数据
-(void)getData{
    if (_userId) {
        if(CPIsLogin){
            NSString *path=[[NSString alloc]initWithFormat:@"user/%@/info?viewUser=%@&token=%@",_userId,[Tools getUserId],[Tools getToken]];
            [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
                if (CPSuccess) {
                    //                user = [CPUser objectWithKeyValues:responseObject[@"data"]];
                    //                NSString *path=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId]];
                    //                [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
                    //                [self reloadData];
                }else{
                    NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            } failure:^(NSError *error) {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登陆，是否登陆？" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去登陆", nil] show];
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:@"你个傻逼" message:@"没传UserId过来要什么自行车" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

#pragma uialertDetelage
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
         [ZYNotificationCenter postNotification:NOTIFICATION_GOLOGIN];
    }else{
        [self popoverPresentationController];
    }
}

#pragma mark - Table view data source

- (IBAction)attentionBtnClick:(id)sender {
}
- (IBAction)taActivityClick:(id)sender {
}
@end
