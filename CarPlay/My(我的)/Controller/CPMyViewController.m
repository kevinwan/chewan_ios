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
//#import <UIButton+WebCache.h>
#import "CPMyCareController.h"
#import "UzysAssetsPickerController.h"
#import "CPAlbum.h"
#import "CPSettingController.h"
#import "CPCarOwnersCertificationController.h"
#import "CPAvatarAuthenticationController.h"
#import "CPEditInfoViewController.h"
#import "CPMyDateViewController.h"
#import "CPCollectionViewCell1.h"
#import "CPAlbum.h"
#import "SDPhotoBrowser.h"
#import "PhotoBroswerVC.h"

@interface CPMyViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UzysAssetsPickerControllerDelegate, UIAlertViewDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SDPhotoBrowserDelegate>
{
    CPUser *user;
    SDPhotoBrowser *browser;
    NSMutableArray *allAlbumsUrl;
}
@end

@implementation CPMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user=[[CPUser alloc]init];
    browser = [[SDPhotoBrowser alloc] init];
    allAlbumsUrl=[[NSMutableArray alloc]init];
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
    
    [self.albumsCollectionView registerNib:[UINib nibWithNibName:@"CPCollectionViewCell1" bundle:nil] forCellWithReuseIdentifier:@"cell1"];
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    UIBezierPath bezierPathWithArcCenter:<#(CGPoint)#> radius:<#(CGFloat)#> startAngle:<#(CGFloat)#> endAngle:<#(CGFloat)#> clockwise:<#(BOOL)#>
    
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
    [self.headImageBg.layer addSublayer:solidLine];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(improveInfo)];
    [self.headImage addGestureRecognizer:tapGes];
    
    for (id view in self.toolbar.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        if ([user.licenseAuthStatus isEqualToString:@"未认证"] || [user.licenseAuthStatus isEqualToString:@"认证未通过"]) {
            CPCarOwnersCertificationController *CPCarOwnersCertification = [UIStoryboard storyboardWithName:@"CPCarOwnersCertification" bundle:nil].instantiateInitialViewController;
            [self.navigationController pushViewController:CPCarOwnersCertification animated:YES];
        }
    }else {
        if ([user.photoAuthStatus isEqualToString:@"未认证"] || [user.photoAuthStatus isEqualToString:@"认证未通过"]) {
            CPAvatarAuthenticationController *CPAvatarAuthenticationController = [UIStoryboard storyboardWithName:@"CPAvatarAuthenticationController" bundle:nil].instantiateInitialViewController;
            [self.navigationController pushViewController:CPAvatarAuthenticationController animated:YES];
        }
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
//            if ([responseObject[@"data"][@"car"] isEqualToString:@""]) {
//                user.car=[CPCar new];
//            }
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
    
    [self.headImageBg zySetImageWithUrl:user.avatar placeholderImage:nil completion:^(UIImage *image) {
                self.headImageBg.image=[image blurredImageWithRadius:20];
    }];
    [self.headImage zySetImageWithUrl:user.avatar placeholderImage:nil];
    [self.nickname setTitle:user.nickname forState:UIControlStateNormal];
    if ([user.gender isEqualToString:@"女"]) {
        [self.sex setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
    }else{
        [self.sex setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    }
    [self.sex setTitle:[[NSString alloc]initWithFormat:@"%lu",(unsigned long)user.age] forState:UIControlStateNormal];
    [self.albumsCollectionView reloadData];
    if (user.photoAuthStatus && ![user.photoAuthStatus isEqualToString:@""]) {
        self.photoAuthStatus.text=user.photoAuthStatus;
    }
    
    if (user.licenseAuthStatus && ![user.licenseAuthStatus isEqualToString:@""]) {
        self.licenseAuthStatus.text=user.licenseAuthStatus;
    }
    if ([user.photoAuthStatus isEqualToString:@"认证通过"] || [user.photoAuthStatus isEqualToString:@"认证中"]) {
        [self.arrowView setHidden:YES];
        self.rightJuli.constant=-8.0;
    }
    
    if ([user.licenseAuthStatus isEqualToString:@"认证通过"] || [user.licenseAuthStatus isEqualToString:@"认证中"]) {
        [self.arrowView1 setHidden:YES];
        self.rightJuli1.constant=-8.0;
    }
    
    if (user.completion<100) {
       self.completionLabel.text=[NSString stringWithFormat:@"资料完成度%lu%%,越高越吸引人",(unsigned long)user.completion];
    }else{
        self.completionLabel.text=@"非常棒,显示资料完成100%";
    }
    self.status.text=user.photoAuthStatus;
    if ([user.photoAuthStatus isEqualToString:@"认证通过"]) {
        [self.status setBackgroundColor:[Tools getColor:@"fdbc4f"]];
        self.status.text=@"已认证";
    }
    [allAlbumsUrl removeAllObjects];
    for (CPAlbum *album in user.album) {
        [allAlbumsUrl addObject:album.url];
    }
    
}

//完善
- (IBAction)improveBtnClick:(id)sender {
    CPEditInfoViewController *editInfo=[UIStoryboard storyboardWithName:@"CPEditInfoViewController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:editInfo animated:YES];
}

//编辑资料
-(void)improveInfo{
    CPEditInfoViewController *editInfo=[UIStoryboard storyboardWithName:@"CPEditInfoViewController" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:editInfo animated:YES];
}

//我的活动
- (IBAction)myActivitiesBtnClick:(id)sender {
    [self.navigationController pushViewController:[CPMyDateViewController new] animated:YES];
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
        __block NSUInteger compleCount = 0;
    
        for (int i = 0; i < arr.count; i++) {
            NSData *data = UIImageJPEGRepresentation(arr[i], 0.4);
            NSData *data1 = UIImagePNGRepresentation(arr[i]);
            ZYHttpFile *imageFile = [ZYHttpFile fileWithName:@"attach" data:data mimeType:@"image/jpeg" filename:@"a1.jpg"];
            [self showLoading];
            [ZYNetWorkTool postFileWithUrl:path params:nil files:@[imageFile] success:^(id responseObject) {
                if (CPSuccess) {
                    compleCount++;
                    albumModel.key=responseObject[@"data"][@"photoKey"];
                    albumModel.url=responseObject[@"data"][@"photoUrl"];
                    [albums insertObject:albumModel atIndex:0];
                    user.album=albums;
                    if (compleCount == arr.count) {
                        if ([ZYUserDefaults boolForKey:CPHasAlbum] == NO) {
                            [[SDImageCache sharedImageCache] clearMemory];
                            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                                [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                            }];
                        }else{
                            
                            [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                        }
                    }
                    
                    if (i == arr.count-1) {
                        [self getData];
                    }
                    
//                    [self.albumsCollectionView reloadData];
                }else{
                    [self showError:responseObject[@"errmsg"]];
                }
            } failure:^(NSError *error) {
                [self showError:@"照片上传失败"];
            }];
        }
    [self disMiss];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [user.album count]+1;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell1";
     CPCollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row==0) {
        [cell.imageView setImage:[UIImage imageNamed:@"相机"]];
    }else{
        CPAlbum *ablum=(CPAlbum *)user.album[indexPath.row-1];
        [cell.imageView zySetImageWithUrl:[NSString stringWithFormat:@"%@%@",ablum.url,@"?imageView2/1/w/200"] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self addPhoto];
    }else{
        [PhotoBroswerVC show:self userId:CPUserId type:PhotoBroswerVCTypePush index:indexPath.row-1 photoModelBlock:^NSArray *{
//            NSArray *networkImages=[[NSArray alloc]initWithArray:allAlbumsUrl];
            
            NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:user.album.count];
            for (NSUInteger i = 0; i< user.album.count; i++) {
                
                PhotoModel *pbModel=[[PhotoModel alloc] init];
                pbModel.mid = i + 1;
                pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
                pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
                pbModel.album = user.album[i];
                
                UIImageView *imagevC=[[UIImageView alloc]init];
                [imagevC setContentMode:UIViewContentModeScaleAspectFill];
                [imagevC zySetImageWithUrl:[NSString stringWithFormat:@"%@%@",[user.album[i] url],@"?imageView2/1/w/800"] placeholderImage:[UIImage imageNamed:@"logo"]];
                
                pbModel.sourceImageView = imagevC;
                
                [modelsM addObject:pbModel];
            }
            
            return modelsM;
        }];

        
        
//        
//        CPTestPhotoViewController *test=[CPTestPhotoViewController new];
//        [self.navigationController pushViewController:test animated:YES];
        
    }
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"logo"];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    CPAlbum *album=user.album[index];
    NSString *urlStr = album.url;
    return [NSURL URLWithString:urlStr];
}

@end
