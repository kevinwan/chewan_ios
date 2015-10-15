//
//  CPTaInfo.m
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPTaInfo.h"
#import "CPUser.h"
#import "CPAlbum.h"
#import "UIImage+Blur.h"

@interface CPTaInfo ()<UIAlertViewDelegate>
{
    CPUser *user;
}
@end

@implementation CPTaInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    user=[[CPUser alloc]init];
    [self.navigationItem setTitle:@"TA的详情"];
    [self.attentionBtn.layer setMasksToBounds:YES];
    [self.attentionBtn.layer setCornerRadius:17.0];
    [self.uploadBtn.layer setMasksToBounds:YES];
    [self.uploadBtn.layer setCornerRadius:17.0];
    [self.headImg.layer setMasksToBounds:YES];
    [self.headImg.layer setCornerRadius:50.0];
    [self.headStatus.layer setMasksToBounds:YES];
    [self.headStatus.layer setCornerRadius:11.0];
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
                    user = [CPUser objectWithKeyValues:responseObject[@"data"]];
                   [self reloadData];
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

-(void)reloadData{
    [self.headImgBg sd_setImageWithURL:[[NSURL alloc]initWithString:user.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headImgBg.image=[image blurredImageWithRadius:20];
    }];
    [self.headImg sd_setImageWithURL:[[NSURL alloc]initWithString:user.avatar]];
    self.headStatus.text=user.photoAuthStatus;
    [self.nickname setTitle:user.nickname forState:UIControlStateNormal];
    if ([user.gender isEqualToString:@"女"]) {
        [self.sexAndAge setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
    }else{
        [self.sexAndAge setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    }
    [self.sexAndAge setTitle:[[NSString alloc]initWithFormat:@"%lu",(unsigned long)user.age] forState:UIControlStateNormal];
    if ([user.role isEqualToString:@"普通用户"]) {
        
    }
    [self reloadAlbumsScrollView];
}

-(void)reloadAlbumsScrollView{
    for (int i=0; i<[user.album count]; i++) {
        UIImageView *album=[[UIImageView alloc]initWithFrame:CGRectMake(10+75*i, 15, 70, 70)];
        CPAlbum *albumModel=(CPAlbum *)user.album[i];
        [album sd_setImageWithURL:[[NSURL alloc]initWithString:albumModel.url] placeholderImage:[UIImage imageNamed:@"logo"]];
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoBrowser)];
        album.userInteractionEnabled = YES;
        [album addGestureRecognizer:singleTap1];
        [album.layer setMasksToBounds:YES];
        [album.layer setCornerRadius:3.0];
        [album setContentMode:UIViewContentModeScaleAspectFill];
        [self.albumsScrollView addSubview:album];
    }
    self.albumsScrollView.contentSize=CGSizeMake(85+75*[user.album count], 100.0);
}

//图片大图浏览
-(void)photoBrowser{
    NSLog(@"photoBrowser");
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
