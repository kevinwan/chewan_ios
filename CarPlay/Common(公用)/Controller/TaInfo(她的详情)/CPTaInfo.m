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
#import "UzysAssetsPickerController.h"
#import "CPHisDateViewController.h"
#import "PhotoBroswerVC.h"
#import "CPCollectionViewCell1.h"
#import "MessageReadManager.h"

@interface CPTaInfo ()<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UzysAssetsPickerControllerDelegate>
{
    CPUser *user;
    CPUser *currentUser;
    NSMutableArray *allAlbumsUrl;
    NSArray *reportTypes;
}
@property (strong, nonatomic) MessageReadManager *messageReadManager;
@end

@implementation CPTaInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    user=[[CPUser alloc]init];
    currentUser=[[CPUser alloc]init];
    allAlbumsUrl=[[NSMutableArray alloc]init];
    [self.navigationItem setTitle:@"TA的详情"];
    [self.attentionBtn.layer setMasksToBounds:YES];
    [self.attentionBtn.layer setCornerRadius:17.0];
    [self.uploadBtn.layer setMasksToBounds:YES];
    [self.uploadBtn.layer setCornerRadius:17.0];
    [self.headImg.layer setMasksToBounds:YES];
    [self.headImg.layer setCornerRadius:50.0];
    [self.headStatus.layer setMasksToBounds:YES];
    [self.headStatus.layer setCornerRadius:11.0];
   
    [self.albumsCollectionView registerNib:[UINib nibWithNibName:@"CPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.albumsCollectionView registerNib:[UINib nibWithNibName:@"CPCollectionViewCell1" bundle:nil] forCellWithReuseIdentifier:@"cell1"];
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
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(ZYScreenWidth/2-60,  21.0, 120.0, 120.0));
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(ZYScreenWidth/2-55,  25.0, 110.0, 110.0));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.headImgBg.layer addSublayer:solidLine];
    
    UITapGestureRecognizer *tapGes = [UITapGestureRecognizer new];
    [tapGes.rac_gestureSignal subscribeNext:^(id x) {
        UIImage *image = self.headImg.image;
        if (image) {
            NSArray *array=[[NSArray alloc]initWithObjects:image, nil];
            [self.messageReadManager showBrowserWithImages:array];
        }
    }];
    
    [self.headImg addGestureRecognizer:tapGes];
    
    if (_activityId) {
         [self setRightNavigationBarItemWithTitle:@"举报" Image:nil highImage:nil target:self action:@selector(report)];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    NSString *path=[NSString stringWithFormat:@"%@.info",CPUserId];
    currentUser=[NSKeyedUnarchiver unarchiveObjectWithFile:path.documentPath];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//获取TA的详情数据
-(void)getData{
    if ([ZYUserDefaults boolForKey:CPHasAlbum]) {
        [self.noImgView setHidden:YES];
    }else{
        [self.noImgView setHidden:NO];
    }
    
    if (_userId) {
        if(CPIsLogin){
            NSString *path=[[NSString alloc]initWithFormat:@"user/%@/info?viewUser=%@&token=%@",_userId,[Tools getUserId],[Tools getToken]];
            [self showLoading];
            [ZYNetWorkTool getWithUrl:path params:nil success:^(id responseObject) {
                if (CPSuccess) {
                    user = [CPUser objectWithKeyValues:responseObject[@"data"]];
                   [self reloadData];
                }else{
                    NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
                [self disMiss];
            } failure:^(NSError *error) {
                [self disMiss];
               [self showInfo:@"请检查您的手机网络!"];
            }];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登陆，是否登陆？" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"去登陆", nil] show];
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"没传UserId过来要什么自行车" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

-(void)reloadData{
    [self.headImg zySetImageWithUrl:user.avatar placeholderImage:nil completion:^(UIImage *image) {
        self.headImgBg.image=[image blurredImageWithRadius:20];
    }];
    [self.headImg zySetImageWithUrl:user.avatar placeholderImage:nil];
    self.headStatus.text=user.photoAuthStatus;
    if ([user.photoAuthStatus isEqualToString:@"认证通过"]) {
        [self.headStatus setBackgroundColor:[Tools getColor:@"fdbc4f"]];
        self.headStatus.text=@"已认证";
    }
    [self.nickname setTitle:user.nickname forState:UIControlStateNormal];
    
    CGSize labelsize = [user.nickname sizeWithFont:[UIFont systemFontOfSize:15]];
    self.nickname.width=labelsize.width+2;
    
    if ([user.gender isEqualToString:@"女"]) {
        [self.sexAndAge setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
    }else{
        [self.sexAndAge setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    }
    [self.sexAndAge setTitle:[[NSString alloc]initWithFormat:@"%lu",(unsigned long)user.age] forState:UIControlStateNormal];
    if ([user.role isEqualToString:@"普通用户"]) {
        
    }
    
    [self.carLogoImg zySetImageWithUrl:user.car.logo placeholderImage:nil];
    [self.carName setText:user.car.brand];
    if (user.car.brand) {
        CGSize labelsize = [user.car.brand sizeWithFont:ZYFont12];
        self.carNameWidth.constant=labelsize.width+2;
        self.carLogoCenter.constant=-19-(labelsize.width-38)/2;
    }
    
    [self.albumsCollectionView reloadData];
    
    if (user.subscribeFlag) {
        [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.attentionBtn setBackgroundColor:[Tools getColor:@"dddddd"]];
    }
    [allAlbumsUrl removeAllObjects];
    for (CPAlbum *album in user.album) {
        [allAlbumsUrl addObject:album.url];
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
                if (!user.subscribeFlag) {
                    user.subscribeFlag=YES;
                    [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                    [self.attentionBtn setBackgroundColor:[Tools getColor:@"dddddd"]];
//                    [self.attentionBtn setEnabled:NO];
                }else{
                    user.subscribeFlag=NO;
                    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
                    [self.attentionBtn setBackgroundColor:[Tools getColor:@"fe5969"]];
                }
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        }
    } failed:^(NSError *error) {
        [self disMiss];
        [self showInfo:@"请检查您的手机网络!"];
    }];
}
- (IBAction)uploadBtnClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    actionSheet.tag=1;
    [actionSheet showInView:self.view];
}

-(void)report{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情低俗", @"广告骚扰",@"政治敏感",@"诈骗",@"违法",nil];
    actionSheet.tag=2;
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {
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
                picker.maximumNumberOfSelectionPhoto = 30-[currentUser.album count];
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }else if (actionSheet.tag==2)
    {
        NSString *reportType = reportTypes[buttonIndex];
        if (buttonIndex == 5) {
            return;
        }else{
            NSString *path=[NSString stringWithFormat:@"/user/%@/report?userId=%@&token=%@&activityId=%@",_reportUserId,CPUserId,CPToken,_userId];
            [ZYNetWorkTool postJsonWithUrl:path params:@[reportType,@"type"] success:^(id responseObject) {
                if (CPSuccess) {
                    [self showInfo:@"举报成功"];
                }else{
                    [self showInfo:responseObject[@"errmsg"]];
                }
            } failed:^(NSError *error) {
                [self showInfo:@"请检查您的手机网络"];
            }];
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
    NSString *path=[[NSString alloc]initWithFormat:@"user/%@/album/upload?token=%@",CPUserId,CPToken];
    NSMutableArray *albums=[[NSMutableArray alloc] initWithArray:currentUser.album];
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
                if (i==arr.count-1) {
                    [self getData];
                }
            }else{
                [self showError:responseObject[@"errmsg"]];
            }
        } failure:^(NSError *error) {
            [self showError:@"照片上传失败"];
        }];
    }
    [self disMiss];
}



- (IBAction)taActivityClick:(id)sender {
    CPHisDateViewController *taInfoVC=[CPHisDateViewController new];
    taInfoVC.targetUser=user;
    [self.navigationController pushViewController:taInfoVC animated:YES];
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
    if ([ZYUserDefaults boolForKey:CPHasAlbum]) {
        static NSString *cellIdentifier = @"cell1";
        CPCollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        CPAlbum *ablum=(CPAlbum *)user.album[indexPath.row];
        [cell.imageView zySetImageWithUrl:[NSString stringWithFormat:@"%@?imageView2/1/w/200",ablum.url] placeholderImage:[UIImage imageNamed:@"logo"]];
        return cell;
    }else{
        static NSString *cellIdentifier = @"cell";
        CPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        CPAlbum *ablum=(CPAlbum *)user.album[indexPath.row];
        [cell.imageView zy_setBlurImageWithUrl:[NSString stringWithFormat:@"%@?imageView2/1/w/200",ablum.url]];
        return cell;
    }
}
//图片大图浏览
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    __weak typeof(self) weakSelf=self;
    [PhotoBroswerVC show:self userId:user.userId type:PhotoBroswerVCTypePush index:indexPath.row photoModelBlock:^NSArray *{
        //            NSArray *networkImages=[[NSArray alloc]initWithArray:allAlbumsUrl];
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:user.album.count];
        for (NSUInteger i = 0; i< user.album.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.album = user.album[i];
            
            UIImageView *imagevC=[[UIImageView alloc]init];
            [imagevC setContentMode:UIViewContentModeScaleAspectFill];
            [imagevC zySetImageWithUrl:[NSString stringWithFormat:@"%@?imageView2/1/w/800",[user.album[i] url]] placeholderImage:[UIImage imageNamed:@"logo"]];
            pbModel.sourceImageView = imagevC;
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

-(NSArray *)reportTypes{
    if (reportTypes == nil) {
        reportTypes = [NSArray arrayWithObjects:@"色情低俗",@"广告骚扰",@"政治敏感",@"诈骗",@"违法", nil];
    }
    return reportTypes;
}
@end
