//
//  CPMyViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/25.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyViewController.h"
#import "CPLoginViewController.h"
#import "CPMyInfoController.h"
#import "CPNavigationController.h"
#import "UIImage+Blur.h"
#import "UIButton+SD.h"
#import <UIButton+WebCache.h>
#import "CPMyCareController.h"
#import "CPBrandModelViewController.h"

@interface CPMyViewController ()
{
    CPUser *user;
}
@end

@implementation CPMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user=[[CPUser alloc]init];
    [self setRightNavigationBarItemWithTitle:nil Image:@"设置" highImage:@"设置" target:self action:@selector(rightClick)];
    [self.improveBtn.layer setMasksToBounds:YES];
    [self.improveBtn.layer setCornerRadius:17.0];
    [self.status.layer setMasksToBounds:YES];
    [self.status.layer setCornerRadius:11.0];
    [self.headImage.layer setMasksToBounds:YES];
    [self.headImage.layer setCornerRadius:50.0];
    [self.tableView setBackgroundColor:[Tools getColor:@"efefef"]];
//    取消下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 1.0f ;
    solidLine.strokeColor = [Tools getColor:@"ffffff"].CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    solidLine.opacity=0.2;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(100.0f,  22.0f, 120.0f, 120.0f));
     CGPathAddEllipseInRect(solidPath, nil, CGRectMake(105.0f,  27.0f, 110.0f, 110.0f));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.headImageBg.layer addSublayer:solidLine];
    UIButton *addPhotoBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 15, 70, 70)];
    [addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [addPhotoBtn setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [self.albumsScrollView addSubview:addPhotoBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CPBrandModelViewController *CPBrandModelVC=[[CPBrandModelViewController alloc]init];
//    CPBrandModelVC.fromMy=_fromMy;
    CPBrandModelVC.title=@"车型选择";
//    CPBrandModelVC.fileName=_fileName;
    [self.navigationController pushViewController:CPBrandModelVC animated:YES];
}
#pragma privateMethod
-(void)rightClick{
    CPLoginViewController *login = [UIStoryboard storyboardWithName:@"CPLoginViewController" bundle:nil].instantiateInitialViewController;
//    [self.navigationController pushViewController:login animated:YES];
    CPNavigationController *nav=[[CPNavigationController alloc]initWithRootViewController:login];
    self.view.window.rootViewController = nav;
    [self.view.window makeKeyAndVisible];
//    self.view.window
//    CPMyInfoController *myInfoVC = [UIStoryboard storyboardWithName:@"CPMyInfoController" bundle:nil].instantiateInitialViewController;
//    [self.navigationController pushViewController:myInfoVC animated:YES];
}

//加载数据
-(void)getData{
    NSString *path=[[NSString alloc]initWithFormat:@"user/%@/info?viewUser=%@&token=%@",[Tools getUserId],[Tools getUserId],[Tools getToken]];
    [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
        if (CPSuccess) {
            user = [CPUser objectWithKeyValues:responseObject[@"data"]];
            NSString *path=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId].documentPath];
            [NSKeyedArchiver archiveRootObject:user toFile:path];
            [self reloadData];
        }else{
            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    } failure:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

-(void)reloadData{
//    [self.headImageBg sd_setImageWithURL:[[NSURL alloc]initWithString:user.avatar]];
    [self.headImageBg sd_setImageWithURL:[[NSURL alloc]initWithString:user.avatar] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headImageBg.image=[image blurredImageWithRadius:20];
    }];
    [self.headImage sd_setImageWithURL:[[NSURL alloc]initWithString:user.avatar]];
    [self.nickname setTitle:user.nickname forState:UIControlStateNormal];
    if ([user.gender isEqualToString:@"女"]) {
        [self.sex setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
    }else{
        [self.sex setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    }
    [self.sex setTitle:[[NSString alloc]initWithFormat:@"%lu",(unsigned long)user.age] forState:UIControlStateNormal];
    
    self.albumsScrollView.contentSize=CGSizeMake(0, 0);
    self.albumsScrollView.pagingEnabled=NO;
    
    for (int i=0; i<[user.albums count]; i++) {
        UIButton *albumBtn=[[UIButton alloc]initWithFrame:CGRectMake(85+75*i, 15, 70, 70)];
        [albumBtn sd_setImageWithURL:[[NSURL alloc]initWithString:user.albums[i]] forState:UIControlStateNormal];
        [albumBtn addTarget:self action:@selector(photoBrowser) forControlEvents:UIControlEventTouchUpInside];
        [albumBtn.layer setMasksToBounds:YES];
        [albumBtn.layer setCornerRadius:3.0];
        [self.albumsScrollView addSubview:albumBtn];
    }
    self.albumsScrollView.contentSize=CGSizeMake(85+75*[user.albums count], 100.0);
}

//完善
- (IBAction)improveBtnClick:(id)sender {
    
}

//我的活动
- (IBAction)myActivitiesBtnClick:(id)sender {
    
}

//我的关注
- (IBAction)myAttentionBtnClick:(id)sender {
    CPMyCareController *myCareVC = [UIStoryboard storyboardWithName:@"CPMyCareController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:myCareVC animated:YES];
}

//添加照片
-(void)addPhoto{
    NSLog(@"addPhoto");
}

//图片大图浏览
-(void)photoBrowser{
    NSLog(@"photoBrowser");
}
@end
