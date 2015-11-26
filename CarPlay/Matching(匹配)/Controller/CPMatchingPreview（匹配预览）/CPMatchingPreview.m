//
//  CPMatchingPreview.m
//  CarPlay
//
//  Created by 公平价 on 15/11/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMatchingPreview.h"
#import "CPNearCollectionViewCell.h"
#import "CPTaInfo.h"
#import "ZHPickView.h"
#import "CPTabBarController.h"
#import "CusomeActionSheet.h"
#import "UMSocial.h"
#import "PhotoBroswerVC.h"
#import "CPUser.h"

@interface CPMatchingPreview ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,ZHPickViewDelegate,customActionsheetDelegete>
{
    BOOL unshare;
    CPUser *user;
    NSString *path;
}
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) NSString *coverId;
//分享view
@property (nonatomic,strong)UIView *shareView;
@property (nonatomic,strong)CusomeActionSheet *shareActionview;

@end

static NSString *ID = @"cell";

@implementation CPMatchingPreview

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    [self.view addSubview:self.tableView];
    [self.navigationItem setTitle:@"匹配活动预览"];
    [self setRightNavigationBarItemWithTitle:nil Image:@"share" highImage:@"share" target:self action:@selector(shareClick)];
    path=[NSString stringWithFormat:@"%@.info",CPUserId].documentPath;
    user=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    _activity.isMatchingPreview = YES;
    [self chackDate];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionView *)tableView
{
    if (_tableView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 62, ZYScreenWidth - 20, ZYScreenHeight-62) collectionViewLayout:layout];
        _tableView.centerX = self.view.middleX;
//        _tableView.centerY = self.view.middleY;
        _tableView.alwaysBounceVertical = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CGSize itemSzie= CGSizeMake(ZYScreenWidth - 20, 390 + self.offset);
        layout.itemSize = itemSzie;
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        self.view.backgroundColor =  [Tools getColor:@"f7f7f7"];
        [_tableView registerClass:[CPNearCollectionViewCell class] forCellWithReuseIdentifier:ID];
        UILabel *explainStr=[[UILabel alloc]initWithFrame:CGRectMake(0, -60, ZYScreenWidth, 60)];
        explainStr.numberOfLines=0;
        explainStr.text=@"你的“意向”将以下面的形式展示给他人 \n不上传真人头像被邀请率很低哟~";
        [explainStr setFont:ZYFont14];
        [explainStr setTextColor:[Tools getColor:@"666666"]];
        [explainStr setTextAlignment:NSTextAlignmentCenter];
        [_tableView addSubview:explainStr];
        [_tableView setContentInset:UIEdgeInsetsMake(60, 0, 0, 0)];
    }
    return _tableView;
}


#pragma mark - UICollectionViewDelegate &dataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPNearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.contentV.indexPath = indexPath;
    cell.contentV.model = _activity;
    cell.contentV.intersterModel.distance=0.0;
    cell.contentV.continueMatching.hidden = NO;
    cell.contentV.changeImg.hidden = NO;
    cell.contentV.dateAnim.hidden = YES;
    cell.contentV.dateButton.hidden = YES;
    [[cell.contentV.changeImg rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self changeImg];
    }];
    
    [[cell.contentV.continueMatching rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        unshare = YES;
        [self shareClick];
    }];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    
}

-(void)changeImg{
    if ( user.album.count >0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"已上传照片", nil];
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];
    }
}

//匹配并分享
-(void)shareClick{
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:LastType].type,@"majorType",@([ZYUserDefaults boolForKey:Transfer]),@"transfer",_activity.destination,@"establish",_activity.destabPoint,@"estabPoint",_activity.destabPoint,@"destPoint",_activity.destination,@"destination",_activity.type,@"type",_coverId,@"cover",_activity.pay,@"pay", nil];
    NSString *path=[[NSString alloc]initWithFormat:@"activity/register?userId=%@&token=%@",[Tools getUserId],[Tools getToken]];
    [ZYNetWorkTool postJsonWithUrl:path params:params success:^(id responseObject) {
        if (CPSuccess) {
            _activity.activityId=responseObject[@"data"];
            if (!unshare) {
                /**
                 *
                 
                 *此处写分享
                 */
                [self share];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
                CPTabBarController *tab = (CPTabBarController *)self.view.window.rootViewController;
                [ZYNotificationCenter postNotificationName:NOTIFICATION_STARTMATCHING object:nil];
                [tab setSelectedIndex:4];
            }
        }else{
            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    } failed:^(NSError *error) {
        [self showInfo:@"请检查您的手机网络!"];
    }];
}

#pragma actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 0){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            DLog(@"相机不可用");
            return;
        }
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 2){
        [PhotoBroswerVC show:self userId:user.userId type:PhotoBroswerVCTypePush index:100 photoModelBlock:^NSArray *{
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
    }else
        return;
}

#pragma PickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editedImage=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *data=UIImageJPEGRepresentation(editedImage, 0.4);
        [self upLoadImageWithBase64Encodeing:data];
    }];
}

//上传图片
-(void)upLoadImageWithBase64Encodeing:(NSData *)encodedImageData{
        ZYHttpFile *file=[[ZYHttpFile alloc]init];
        file.name=@"attach";
        file.data=encodedImageData;
        file.filename=@"avatar.jpg";
        file.mimeType=@"image/jpeg";
        NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
        NSString *urlPath=[NSString stringWithFormat:@"user/%@/album/upload?token=%@",[Tools getUserId],[Tools getToken]];
        [self showLoading];
        [ZYNetWorkTool postFileWithUrl:urlPath params:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type", nil] files:files success:^(id responseObject){
            if (CPSuccess) {
                _activity.organizer.cover=responseObject[@"data"][@"photoUrl"];
                _coverId=responseObject[@"data"][@"photoId"];
                [_tableView reloadData];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
            [self disMiss];
        }failure:^(NSError *erro){
            [self showInfo:@"请检查您的手机网络!"];
            [self disMiss];
        }];
}


-(void)chackDate{
    if ([ZYUserDefaults stringForKey:@"coverPhotoUrl"] && [ZYUserDefaults stringForKey:@"coverPhotoId"]) {
        _activity.organizer.cover = [ZYUserDefaults stringForKey:@"coverPhotoUrl"];
        _coverId = [ZYUserDefaults stringForKey:@"coverPhotoId"];
        [self.tableView reloadData];
    }
}
#pragma mark 分享相关方法

#pragma 分享
-(void)share{
    if (self.shareView == nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _shareView = [[UIView alloc]initWithFrame:window.frame];
        _shareView.backgroundColor = [UIColor blackColor];
        _shareView.alpha = 0.4;
        
        _shareActionview= [[CusomeActionSheet alloc]initWithFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, 152)];
        _shareActionview.delegate = self;
        
        [window addSubview:_shareView];
        [window addSubview:_shareActionview];
        //        [window bringSubviewToFront:_shareView];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _shareActionview.y = KDeviceHeight-152;
        } completion:^(BOOL finished) {
            nil;
        }];
        
        
    }
}
//去掉分享界面
- (void)shareViewDismiss
{
    [self.shareView removeFromSuperview];
    [self.shareActionview removeFromSuperview];
    self.shareActionview = nil;
    self.shareView = nil;
}
#pragma mark 分享的代理方法
- (void)btnClicked:(UIButton *)button
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString *shareStr = [NSString stringWithFormat:@"http://www.chewanapp.com/appdetail.html?id=%@",_activity.activityId];
    NSString *titleStr = [NSString stringWithFormat:@"我想找人一起%@",_activity.type];
    
    UMSocialUrlResource *resouce;
    if (_activity.organizer.cover.length >0) {
        resouce = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_activity.organizer.cover];
    }else{
        resouce = nil;
    }
    
    
    switch (button.tag) {
        case 1:
            //分享朋友圈
        { //这里有可能没有图片，所以要判断下
           
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareStr;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleStr;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:titleStr image:nil location:nil urlResource:resouce presentedController:self completion:^(UMSocialResponseEntity *response){
                [self shareViewDismiss];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
        }
            break;
        case 2:
            //分享微信好友
        {
          
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareStr;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"";
            NSString *shareContent  = [NSString stringWithFormat:@"%@\n%@",titleStr,[_activity.destination objectForKey:@"street"]];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareContent image:nil location:nil urlResource:resouce presentedController:self completion:^(UMSocialResponseEntity *response){
                [self shareViewDismiss];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
        }
            break;
        case 3:
            //取消
        {
            [self shareViewDismiss];
        }
            break;
            
        default:
            break;
    }
}
@end
