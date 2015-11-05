//
//  CPTakeALookViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/8.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPTakeALookViewController.h"
#import "CPActivityModel.h"
#import "CPNearCollectionViewCell.h"
#import "CPTakeALookResultController.h"
#import "CPNavigationController.h"

@interface CPTakeALookViewController ()
{
    NSTimer *takeALookViewTimer;
    NSUInteger takeALookAnimationIndex;
    NSArray *activities;
}
@end

@implementation CPTakeALookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    activities=[[NSArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (int i=1; i<11; i++) {
        CPNPSButton *btn=[self.view viewWithTag:i];
        btn.transform=CGAffineTransformMakeScale(0.0, 0.0);
    }
    [self getData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)personBtnClick:(CPNPSButton *)sender {
    CPTakeALookResultController *takeALookResult=[CPTakeALookResultController new];
    takeALookResult.activity=activities[sender.tag-1];
    CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:takeALookResult];
    
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
}

- (IBAction)close:(id)sender {
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

-(void)getData{
    NSString *path=[NSString stringWithFormat:@"activity/randomLook?userId=%@&token=%@&limit=%@&longitude=%@&latitude=%@",CPUserId,CPToken,@"10",[NSString stringWithFormat:@"%f",CPLongitude],[NSString stringWithFormat:@"%f",CPLatitude]];
    if (!CPIsLogin) {
        path=[NSString stringWithFormat:@"activity/randomLook?limit=%@&longitude=%@&latitude=%@",@"10",[NSString stringWithFormat:@"%f",CPLongitude],[NSString stringWithFormat:@"%f",CPLatitude]];
    }
    [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
        if (CPSuccess) {
            activities = [[NSArray alloc]initWithArray:[CPActivityModel objectArrayWithKeyValuesArray:responseObject[@"data"]]];
            for (int i=1; i<11; i++) {
                CPNPSButton *btn = [self.view viewWithTag:i];
                CPActivityModel *activity = activities[i-1];
                [btn zySetImageWithUrl:activity.organizer.avatar placeholderImage:[UIImage imageNamed:@"Logo"] completion:^(UIImage *image) {
                    btn.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
                    btn.imageView.layer.borderWidth=1;
                    [btn.imageView setCornerRadius:(btn.height - 20) * 0.5];
                    btn.imageEdgeInsets = UIEdgeInsetsMake(0,10,20,10);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
                    btn.tintColor=[UIColor redColor];
                    btn.label.text = [NSString stringWithFormat:@"我想%@",activity.type];
                    [btn setImage:image forState:UIControlStateNormal];
                    btn.layer.masksToBounds = NO;
                } forState:UIControlStateNormal];
            }
            [self doAnmi];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
        }
    } failure:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }];
}

-(void)doAnmi{
    takeALookAnimationIndex=1;
    
    takeALookViewTimer =  [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(takeALookAnimation) userInfo:nil repeats:YES];
    [takeALookViewTimer setFireDate:[NSDate distantPast]];
}

//随便看看页面动画
-(void)takeALookAnimation{
    CPNPSButton *btn=[self.view viewWithTag:takeALookAnimationIndex];
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        takeALookAnimationIndex++;
        if (takeALookAnimationIndex>10) {
            takeALookAnimationIndex=1;
            [takeALookViewTimer setFireDate:[NSDate distantFuture]];
        }
    }];
}
@end
