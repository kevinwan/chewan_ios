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
#import "CPCollectionViewCell.h"
#import "CPMyDateViewController.h"

@interface CPTaInfo ()<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
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
//    self.noImgView.alpha=0.35;
    [self.noImgView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.35]];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"blurBg"]];
    [self.noImgView setBackgroundColor:bgColor];
    [self.albumsCollectionView registerNib:[UINib nibWithNibName:@"CPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    for (id view in self.toolbar.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 1.0f ;
    solidLine.strokeColor = [Tools getColor:@"ffffff"].CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    solidLine.opacity=0.2;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(ZYScreenWidth/2-60,  22.0, 120.0, 120.0));
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(ZYScreenWidth/2-55,  26.0, 110.0, 110.0));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.headImgBg.layer addSublayer:solidLine];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"没传UserId过来要什么自行车" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

-(void)reloadData{
    [self.headImgBg sd_setImageWithURL:[[NSURL alloc]initWithString:user.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.headImgBg.image=[image blurredImageWithRadius:20];
    }];
    [self.headImg sd_setImageWithURL:[[NSURL alloc]initWithString:user.avatar]];
    self.headStatus.text=user.photoAuthStatus;
    if ([user.photoAuthStatus isEqualToString:@"认证通过"]) {
        [self.headStatus setBackgroundColor:[Tools getColor:@"fdbc4f"]];
        self.headStatus.text=@"已认证";
    }
    [self.nickname setTitle:user.nickname forState:UIControlStateNormal];
    if ([user.gender isEqualToString:@"女"]) {
        [self.sexAndAge setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
    }else{
        [self.sexAndAge setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    }
    [self.sexAndAge setTitle:[[NSString alloc]initWithFormat:@"%lu",(unsigned long)user.age] forState:UIControlStateNormal];
    if ([user.role isEqualToString:@"普通用户"]) {
        
    }
    
    [self.carLogoImg sd_setImageWithURL:[NSURL URLWithString:user.car.logo]];
    [self.albumsCollectionView reloadData];
    
    if (user.subscribeFlag) {
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attentionBtn setBackgroundColor:[Tools getColor:@"dddddd"]];
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
    NSString *url = [NSString stringWithFormat:@"user/%@/listen?token=%@",CPUserId, CPToken];
    if (user.subscribeFlag) {
        url = [NSString stringWithFormat:@"user/%@/unlisten?token=%@",CPUserId, CPToken];
    }
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:user.userId,@"targetUserId",nil];
    [self showLoading];
    [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        [self disMiss];
        if (CPSuccess) {
            if (user) {
                if (user.subscribeFlag) {
                    [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
                    [self.attentionBtn setBackgroundColor:[Tools getColor:@"dddddd"]];
                }else{
                    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [self.attentionBtn setBackgroundColor:[Tools getColor:@"fe5969"]];
                }
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
    } failed:^(NSError *error) {
        [self disMiss];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }];
}
- (IBAction)taActivityClick:(id)sender {
    [self.navigationController pushViewController:[CPMyDateViewController new] animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [user.album count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    CPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        CPAlbum *ablum=(CPAlbum *)user.album[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:ablum.url]];
    return cell;
}
//图片大图浏览
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
