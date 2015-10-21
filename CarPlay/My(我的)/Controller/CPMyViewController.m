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
#import "UzysAssetsPickerController.h"
#import "CPAlbum.h"
#import "CPSettingController.h"
#import "CPCarOwnersCertificationController.h"
#import "CPAvatarAuthenticationController.h"
#import "CPEditInfoViewController.h"

@interface CPMyViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UzysAssetsPickerControllerDelegate, UIAlertViewDelegate,UINavigationControllerDelegate>
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
    [self.headImage setContentMode:UIViewContentModeScaleAspectFill];
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
    if (indexPath.row == 1) {
       CPCarOwnersCertificationController *CPCarOwnersCertification = [UIStoryboard storyboardWithName:@"CPCarOwnersCertification" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:CPCarOwnersCertification animated:YES];
    }else {
        CPAvatarAuthenticationController *CPAvatarAuthenticationController = [UIStoryboard storyboardWithName:@"CPAvatarAuthenticationController" bundle:nil].instantiateInitialViewController;
        [self.navigationController pushViewController:CPAvatarAuthenticationController animated:YES];
    }
}
#pragma privateMethod
-(void)rightClick{
     CPSettingController *CPSettingTableVC = [UIStoryboard storyboardWithName:@"CPSetting" bundle:nil].instantiateInitialViewController;
    CPSettingTableVC.title=@"设置";
    [self.navigationController pushViewController:CPSettingTableVC animated:YES];
}

//加载数据
-(void)getData{
    NSString *path=[[NSString alloc]initWithFormat:@"user/%@/info?viewUser=%@&token=%@",[Tools getUserId],[Tools getUserId],[Tools getToken]];
    [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
        if (CPSuccess) {
            user = [CPUser objectWithKeyValues:responseObject[@"data"]];
            NSString *path=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId]];
            [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
            [self reloadData];
            if (user.album.count > 0) {
                [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
            }else{
                [ZYUserDefaults setBool:NO forKey:CPHasAlbum];
            }
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
    [self reloadAlbumsScrollView];
}

-(void)reloadAlbumsScrollView{
    for (int i=0; i<[user.album count]; i++) {
        UIImageView *album=[[UIImageView alloc]initWithFrame:CGRectMake(85+75*i, 15, 70, 70)];
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

//完善
- (IBAction)improveBtnClick:(id)sender {
    CPEditInfoViewController *editInfo=[UIStoryboard storyboardWithName:@"CPEditInfoViewController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:editInfo animated:YES];
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

//图片大图浏览
-(void)photoBrowser{
    NSLog(@"photoBrowser");
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.delegate = self;
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pick animated:YES completion:nil];
        }else{
          [[[UIAlertView alloc]initWithTitle:@"提示" message:@"相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.maximumNumberOfSelectionPhoto = 30-[user.album count];
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}
/**
 *  照片选择完毕
 *
 *  @param picker picker description
 *  @param info   info description
 */

#pragma mark - <UZYImagePickerController>

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *arr = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *representation = obj;
        
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        [arr addObject:img];
    }];
    [self addPhoto:arr];
//    [SVProgressHUD showWithStatus:@"加载中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    [self showAlert];
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"您最多只能上传30张图片"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  系统的拍照完毕方法
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self addPhoto:@[portraitImg]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DLog(@"系统的....");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  添加图片
 */
- (void)addPhoto:(NSArray *)arr
{
        NSString *path=[[NSString alloc]initWithFormat:@"user/%@/album/upload?token=%@",[Tools getUserId],[Tools getToken]];
        NSMutableArray *albums=[[NSMutableArray alloc] initWithArray:user.album];
        CPAlbum *albumModel=[[CPAlbum alloc]init];
    [self showLoading];
        for (int i = 0; i < arr.count; i++) {
            ZYHttpFile *imageFile = [ZYHttpFile fileWithName:@"attach" data:UIImageJPEGRepresentation(arr[i], 0.4) mimeType:@"image/jpeg" filename:@"a1.jpg"];
            [self showLoading];
            [ZYNetWorkTool postFileWithUrl:path params:nil files:@[imageFile] success:^(id responseObject) {
                if (CPSuccess) {
                    albumModel.key=responseObject[@"data"][@"photoKey"];
                    albumModel.url=responseObject[@"data"][@"photoUrl"];
                    [albums insertObject:albumModel atIndex:0];
                    user.album=albums;
                    [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                    [self reloadAlbumsScrollView];
                }else{
                    [self showError:responseObject[@"errmsg"]];
                }
            } failure:^(NSError *error) {
                [self showError:@"照片上传失败"];
            }];
        }
    [self disMiss];
}

@end
