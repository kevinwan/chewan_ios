//
//  CPTakeALookResultController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPTakeALookResultController.h"
#import "CPNearCollectionViewCell.h"
#import "CPTaInfo.h"
#import "CPAlbum.h"
#import "SDImageCache.h"

@interface CPTakeALookResultController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, assign) CGFloat offset;
@end

static NSString *ID = @"cell";
@implementation CPTakeALookResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.view removeFromSuperview];
    [self.navigationController removeFromParentViewController];
}

- (UICollectionView *)tableView
{
    if (_tableView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ZYScreenWidth - 20, 390+self.offset) collectionViewLayout:layout];
        _tableView.centerX = self.view.middleX;
        _tableView.centerY = self.view.middleY;
        _tableView.alwaysBounceVertical = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView setContentInsetTop:(ZYScreenHeight-383-self.offset)/2];
        CGSize itemSzie= CGSizeMake(ZYScreenWidth - 20, 390 + self.offset);
        layout.itemSize = itemSzie;
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        self.view.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.7];
        [_tableView registerClass:[CPNearCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _tableView.panGestureRecognizer.delaysTouchesBegan = _tableView.delaysContentTouches;
        
    }
    return _tableView;
}

#pragma mark - UICollectionViewDelegate &dataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPNearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.contentV.indexPath = indexPath;
    cell.contentV.model = _activity;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if ([notifyName isEqualToString:CameraBtnClickKey]) {
        [self cameraPresent];
    }else if([notifyName isEqualToString:PhotoBtnClickKey]){
        [self photoPresent];
    }else if([notifyName isEqualToString:DateBtnClickKey]){
        [self dateClickWithInfo:userInfo];
    }else if([notifyName isEqualToString:LoveBtnClickKey]){
        [self loveBtnClickWithInfo:(CPActivityModel *)userInfo];
    }else if ([notifyName isEqualToString:IconViewClickKey]){
        CPGoLogin(@"查看TA的详情");
        CPTaInfo *taVc = [UIStoryboard storyboardWithName:@"TaInfo" bundle:nil].instantiateInitialViewController;
        taVc.userId = _activity.organizer.userId;
        taVc.activityId = _activity.activityId;
        [self.navigationController pushViewController:taVc animated:YES];
    }
}

/**
 *  处理关注点击
 *
 *  @param model model description
 */
- (void)loveBtnClickWithInfo:(CPActivityModel *)model
{
//    ZYAsyncThead(^{
//        
//        NSMutableArray *indexPaths = [NSMutableArray array];
//        
//        for (int i = 0;i < self.datas.count; i++) {
//            CPActivityModel *obj = self.datas[i];
//            if ([obj.organizer.userId isEqualToString:model.organizer.userId] && ![obj.activityId isEqualToString:model.activityId]) {
//                obj.organizer.subscribeFlag = model.organizer.subscribeFlag;
//                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
//            }
//            
//        }
//        ZYMainOperation(^{
//            [self.tableView reloadItemsAtIndexPaths:indexPaths];
//        });
//        
//    });
}

/**
 *  弹出相机
 */
- (void)cameraPresent
{
    CPGoLogin(@"上传照片");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showError:@"相机不可用"];
        return;
    }
    UIImagePickerController *pic = [UIImagePickerController new];
    pic.allowsEditing = YES;
    pic.sourceType = UIImagePickerControllerSourceTypeCamera;
    [pic.rac_imageSelectedSignal subscribeNext:^(NSDictionary *dict) {
        [self addPhoto:@[dict[UIImagePickerControllerEditedImage]]];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }completed:^{
        
//        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    [self presentViewController:pic animated:YES completion:NULL];
}

/**
 *  相册弹出
 */
- (void)photoPresent
{
    CPGoLogin(@"上传照片");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self showError:@"相册不可用"];
        return;
    }
    UIImagePickerController *pic = [UIImagePickerController new];
    pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [pic.rac_imageSelectedSignal subscribeNext:^(NSDictionary *dict) {
        [self addPhoto:@[dict[UIImagePickerControllerOriginalImage]]];
        [self dismissViewControllerAnimated:YES completion:NULL];
    } completed:^{
//        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    [self presentViewController:pic animated:YES completion:NULL];
    
}

//上传图片
- (void)addPhoto:(NSArray *)arr
{
    // 多图上传
    NSString *path=[[NSString alloc]initWithFormat:@"user/%@/album/upload?token=%@",[Tools getUserId],[Tools getToken]];
    [self showLoading];
    __block NSUInteger count = 0;
    NSMutableArray *albums = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        ZYHttpFile *imageFile = [ZYHttpFile fileWithName:@"attach" data:UIImageJPEGRepresentation(arr[i], 0.4) mimeType:@"image/jpeg" filename:@"a1.jpg"];
        [ZYNetWorkTool postFileWithUrl:path params:nil files:@[imageFile] success:^(id responseObject) {
            if (CPSuccess) {
                
                count++;
                
                CPAlbum *album = [CPAlbum objectWithKeyValues:responseObject[@"data"]];
                [albums addObject:album];
                if (count == arr.count) {
                    [self disMiss];
                    [self postPhotoCount:arr.count];
                    NSString *filePath = [NSString stringWithFormat:@"%@.info",CPUserId];
                    CPUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath.documentPath];
                    
                    [albums insertObjects:user.album atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, user.album.count)]];
                    user.album = [albums copy];
                    [NSKeyedArchiver archiveRootObject:user toFile:filePath.documentPath];
                    if ([ZYUserDefaults boolForKey:CPHasAlbum] == NO && user.album.count >= 2) {
                        [[SDImageCache sharedImageCache] clearMemory];
                        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                            [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                            [self.tableView reloadData];
                        }];
                    }
                }
            }else{
                [self showInfo:CPErrorMsg];
            }
            
            
        } failure:^(NSError *error) {
            [self showError:@"照片上传失败"];
        }];
    }
    
}

//发送上传的照片的个数
-(void)postPhotoCount:(NSInteger)count
{
    NSString *path=[NSString stringWithFormat:@"user/%@/photoCount?token=%@",CPUserId,CPToken];
    [ZYNetWorkTool postJsonWithUrl:path params:[NSDictionary dictionaryWithObjectsAndKeys:@(count),@"count", nil] success:^(id responseObject) {
        if (CPFailure) {
            [self showInfo:responseObject[@"errmsg"]];
        }
    } failed:^(NSError *error) {
        [self showInfo:@"请检查您的手机网络"];
    }];
}


/**
 *  处理约她的逻辑
 *
 *  @param userInfo user
 */
- (void)dateClickWithInfo:(id)userInfo
{
    CPGoLogin(@"邀TA");
    NSIndexPath *indexPath = userInfo;
    NSString *url = [NSString stringWithFormat:@"activity/%@/join",_activity.activityId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"destPoint"] = @{@"longitude" : @(CPLongitude),
                             @"latitude" : @(CPLatitude)};
    params[@"transfer"] = @(_activity.transfer);
    params[@"type"] = _activity.type;
    params[@"pay"] = _activity.pay;
    params[@"destination"] = _activity.destination;
    params[UserId] = CPUserId;
    params[Token] = CPToken;
    [self showLoading];
    [CPNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            [self showInfo:@"邀请已发出"];
            _activity.applyFlag = 1;
            [self.tableView reloadData];
        }else if ([CPErrorMsg contains:@"申请中"]){
            [self showInfo:@"正在申请中"];
        }
    } failed:^(NSError *error) {
        [self showInfo:@"邀请失败"];
    }];
    
}


@end
