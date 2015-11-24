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

@interface CPMatchingPreview ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,ZHPickViewDelegate>
{
    BOOL share;
}
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) NSString *coverId;
@end

static NSString *ID = @"cell";

@implementation CPMatchingPreview

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    [self.view addSubview:self.tableView];
    [self.navigationItem setTitle:@"匹配活动预览"];
    [self setRightNavigationBarItemWithTitle:nil Image:@"share" highImage:@"share" target:self action:@selector(shareClick)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",self.navigationController);
    [self.navigationController.navigationBar setHidden:NO];
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
        _tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 62, ZYScreenWidth - 20, 390+self.offset) collectionViewLayout:layout];
        _tableView.centerX = self.view.middleX;
        _tableView.centerY = self.view.middleY;
        _tableView.alwaysBounceVertical = NO;
        _tableView.backgroundColor = [UIColor redColor];
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
        share = YES;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"已上传照片", nil];
        [actionSheet showInView:self.view];
    }];
    
    [[cell.contentV.continueMatching rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        share = NO;
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

//匹配并分享
-(void)shareClick{
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:[ZYUserDefaults stringForKey:LastType].type,@"majorType",@([ZYUserDefaults boolForKey:Transfer]),@"transfer",_activity.destination,@"establish",_activity.destabPoint,@"estabPoint",_activity.destabPoint,@"destPoint",_activity.destination,@"destination",_activity.type,@"type",_coverId,@"cover", nil];
    NSString *path=[[NSString alloc]initWithFormat:@"activity/register?userId=%@&token=%@",[Tools getUserId],[Tools getToken]];
    [ZYNetWorkTool postJsonWithUrl:path params:params success:^(id responseObject) {
        if (CPSuccess) {
            _activity.activityId=responseObject[@"data"];
            if (share) {
                /**
                 *
                 *此处写分享
                 */
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

//上传头像
-(void)upLoadImageWithBase64Encodeing:(NSData *)encodedImageData{
        ZYHttpFile *file=[[ZYHttpFile alloc]init];
        file.name=@"attach";
        file.data=encodedImageData;
        file.filename=@"avatar.jpg";
        file.mimeType=@"image/jpeg";
        NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
        NSString *urlPath=[NSString stringWithFormat:@"user/%@/avatar?token=%@",[Tools getUserId],[Tools getToken]];
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
@end
