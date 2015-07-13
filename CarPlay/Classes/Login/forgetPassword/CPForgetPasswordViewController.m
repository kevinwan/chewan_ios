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
    self.navigationController.navigationBarHidden=NO;
    self.getIdentifyingCodeBtn.layer.cornerRadius=15.0;
    self.getIdentifyingCodeBtn.layer.masksToBounds=YES;
    self.nextBtn.layer.cornerRadius=3.0;
    self.nextBtn.layer.masksToBounds=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    //     设置navigationBar透明的背景颜色，达到透明的效果BIGIN
    
    NSArray *list=self.navigationController.navigationBar.subviews;
    for (id obj in list) {
        if([obj isKindOfClass:[UIImageView class]]){
            UIImageView *imageView=(UIImageView *)obj;
            imageView.hidden=YES;
        }
    }
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, -20, 320, 64)];
    imageView.image=[UIImage imageNamed:@"TransparentBg.png"];
    [self.navigationController.navigationBar addSubview:imageView];
    [self.navigationController.navigationBar sendSubviewToBack:imageView];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent=NO;
    //       设置navigationBar透明的背景颜色，达到透明的效果END
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getIdentifyingCodeBtnClick:(id)sender {
}
@end
