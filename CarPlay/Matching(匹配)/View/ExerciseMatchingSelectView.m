//
//  ExerciseMatchingSelectView.m
//  CarPlay
//
//  Created by 公平价 on 15/10/21.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "ExerciseMatchingSelectView.h"

@interface ExerciseMatchingSelectView ()

@end

@implementation ExerciseMatchingSelectView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whetherShuttle=@"0";
    [self.selectView.layer setMasksToBounds:YES];
    [self.selectView.layer setCornerRadius:10.0];
    [self.selectPlace.layer setMasksToBounds:YES];
    [self.selectPlace.layer setCornerRadius:10.0];
    self.selectPlace.layer.borderColor=[[Tools getColor:@"dddddd"]CGColor];
    self.selectPlace.layer.borderWidth= 1.0f;
    [self.matchingBtn.layer setMasksToBounds:YES];
    [self.matchingBtn.layer setCornerRadius:20.0];
    [self.selectPlace setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.selectPlace.imageView.size.width, 0, self.selectPlace.imageView.size.width)];
    [self.selectPlace setImageEdgeInsets:UIEdgeInsetsMake(0, self.selectPlace.titleLabel.bounds.size.width, 0, -self.selectPlace.titleLabel.bounds.size.width)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shuttle:(id)sender {
    if ([self.whetherShuttle isEqualToString:@"0"]) {
        [self.shuttleBtn setImage:[UIImage imageNamed:@"点击效果"] forState:UIControlStateNormal];
        self.whetherShuttle=@"1";
        [ZYUserDefaults setBool:YES forKey:Transfer];
    }else{
        [self.shuttleBtn setImage:[UIImage imageNamed:@"初始效果"] forState:UIControlStateNormal];
        self.whetherShuttle=@"0";
        [ZYUserDefaults setBool:NO forKey:Transfer];
    }
}
//选择地址
- (IBAction)selectPlaceClick:(id)sender {
    
}
//
- (IBAction)matchingBtnClick:(id)sender {
    NSDictionary *estabPoint=[[NSDictionary alloc]initWithObjectsAndKeys:@([Tools getLongitude]),@"longitude",@([Tools getLatitude]),@"latitude", nil];
    
    NSDictionary *establish=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:Province],@"province",[ZYUserDefaults stringForKey:City],@"city",[ZYUserDefaults stringForKey:District],@"district",[ZYUserDefaults stringForKey:Street],@"street", nil];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:LastType],@"type",@([ZYUserDefaults boolForKey:Transfer]),@"transfer",establish,@"establish",estabPoint,@"estabPoint",estabPoint,@"destPoint",establish,@"destination",@"AA制",@"pay", nil];
    NSString *path=[[NSString alloc]initWithFormat:@"activity/register?userId=%@&token=%@",[Tools getUserId],[Tools getToken]];
    [ZYNetWorkTool postJsonWithUrl:path params:params success:^(id responseObject) {
        if (CPSuccess) {
            NSLog(@"%@",responseObject);
            [[[UIAlertView alloc]initWithTitle:@"测试提示" message:@"发布成功了，手动点击空白出退回先" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    } failed:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}


@end
