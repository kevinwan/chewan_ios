//
//  CPMyInterestViewController.m
//  CarPlay
//
//  Created by chewan on 10/24/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPMyInterestViewController.h"
#import "CPMySwitch.h"
#import "CPSelectView.h"
#import "CPNearParams.h"
#import "AAPullToRefresh.h"
#import "ZYProgressView.h"
#import "CPNoDataTipView.h"
#import "CPTaInfo.h"
#import "CPLoadingView.h"
#import "UICollectionView3DLayout.h"
#import "CPNearCollectionViewCell.h"
#import "CPAlbum.h"
#import "ZYWaterflowLayout.h"
#import "SDImageCache.h"
#import "ChatViewController.h"

@interface CPMyInterestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,ZYWaterflowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, strong) NSMutableArray<CPIntersterModel *> *datas;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) NSInteger ignore;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, strong) CPNoDataTipView *noDataView;
@property (nonatomic, weak)   AAPullToRefresh *headerView;
@property (nonatomic, weak)   AAPullToRefresh *footerView;
@end

static NSString *ID = @"myIntersterCell";
@implementation CPMyInterestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"感兴趣的";
    
    if (CPNoNetWork) {
        
        [ZYProgressView showMessage:@"网络连接失败,请检查网络"];
        return;
    }
    
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//      self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [ZYLoadingView showLoadingView];
    [self loadDataWithHeader:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ZYLoadingView dismissLoadingView];
}

- (void)setUpRefresh
{
    if (self.isHasRefreshHeader) {
        return;
    }
    ZYWeakSelf
    self.headerView = [_tableView addPullToRefreshPosition:AAPullToRefreshPositionTop actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        ZYMainOperation(^{
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, -44) animated:YES];
        });
        self.ignore = 0;
        [self loadDataWithHeader:v];
    }];
    if (self.datas.count <= 1) {
        return;
    }
    // bottom
    self.footerView = [_tableView addPullToRefreshPosition:AAPullToRefreshPositionBottom actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        ZYMainOperation(^{
            
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, self.tableView.contentSizeHeight - self.tableView.height + 44) animated:YES];
        });
        
        if (self.datas.count % CPPageNum == 0) {
            self.ignore += CPPageNum;
            [self loadDataWithHeader:v];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [v stopIndicatorAnimation];
            });
        }
    }];
    self.footerView.isNoAnimation = YES;
    self.isHasRefreshHeader = YES;
}

/**
 *  加载网络数据
 */
- (void)loadDataWithHeader:(AAPullToRefresh *)refresh
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = CPToken;
    params[@"ignore"] = @(self.ignore);
    NSString *url = [NSString stringWithFormat:@"user/%@/interest/list",CPUserId];
    [ZYNetWorkTool getWithUrl:url params:params success:^(id responseObject) {
        
        [refresh stopIndicatorAnimation];
        DLog(@"%@ ---- ",responseObject);
        if (CPSuccess) {
            if (self.ignore == 0) {
                [self.datas removeAllObjects];
            }
            
            NSArray *arr = [CPIntersterModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSLog(@"gggg%zd",arr.count);
            [self.datas addObjectsFromArray:arr];
            
            [self setUpRefresh];
            if (self.datas.count == 0) {
                self.noDataView.netWorkFailtype = NO;
                self.noDataView.hidden = NO;
            }else{
                self.noDataView.hidden = YES;
            }
            [self.tableView reloadData];
        }else{
            
            [self setUpRefresh];
            [self showInfo:CPErrorMsg];
        }
        
        [self dismissLoadingView];
    } failure:^(NSError *error) {
        
        [self setUpRefresh];
        DLog(@"%@---",error);
        self.ignore -= CPPageNum;
        [refresh stopIndicatorAnimation];
        [self showError:@"加载失败"];
        self.noDataView.netWorkFailtype = NO;
        [ZYLoadingView dismissLoadingView];
    }];
}

#pragma mark - UICollectionViewDelegate &dataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPNearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.contentV.indexPath = indexPath;
    cell.contentV.intersterModel = self.datas[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)waterflowLayout:(ZYWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas[indexPath.row].type == 1) {
        return self.offset + 350;
    }
    return self.offset + 370;
}

#pragma mark - 事件交互

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    NSLog(@"%@ %@ ",notifyName, userInfo);
    if ([notifyName isEqualToString:CameraBtnClickKey]) {
        [self cameraPresent];
    }else if([notifyName isEqualToString:PhotoBtnClickKey]){
        [self photoPresent];
    }else if([notifyName isEqualToString:DateBtnClickKey]){
        [self dateClickWithInfo:userInfo];
    }else if([notifyName isEqualToString:LoveBtnClickKey]){
        [self loveBtnClickWithInfo:(CPIntersterModel *)userInfo];
    }else if ([notifyName isEqualToString:IconViewClickKey]){
        CPGoLogin(@"查看TA的详情");
        CPTaInfo *taVc = [UIStoryboard storyboardWithName:@"TaInfo" bundle:nil].instantiateInitialViewController;
        NSIndexPath *indexPath = userInfo;
        taVc.userId = self.datas[indexPath.row].user.userId;
        taVc.activityId = self.datas[indexPath.row].activityId;
        [self.navigationController pushViewController:taVc animated:YES];
    }else if([notifyName isEqualToString:InvitedButtonClickKey]){
        NSIndexPath *indexPath = userInfo;
        CPIntersterModel *model = self.datas[indexPath.row];
        
        if (model.activityStatus == 1){
            //
        }else if (model.activityStatus == 2){
            //消息
            //            NSString *userID = model.applyUserId;
            //            if (![userID isEqualToString:CPUserId]) {
            //                userID = model.invitedUserId;
            //            }
//            NSString *userID=model.userid;
            
            ChatViewController *xiaoniuChatVc = [[ChatViewController alloc]initWithChatter:[Tools md5EncryptWithString:model.user.userId] conversationType:eConversationTypeChat];
            xiaoniuChatVc.title = model.user.nickname;
            [self.navigationController pushViewController:xiaoniuChatVc animated:YES];
        }
        
    }else if([notifyName isEqualToString:IgnoreButtonClickKey]){
        NSIndexPath *indexPath = userInfo;
        CPIntersterModel *model = self.datas[indexPath.row];
            //电话
//            NSString *userID=[model.applyUserId isEqualToString:CPUserId]?model.invitedUserId:model.applyUserId;
        if (model.activityStatus == 2) {
            
            [ZYUserDefaults setObject:model.user.avatar forKey:kReceiverHeadUrl];
            [ZYUserDefaults setObject: model.user.nickname forKey:kReceiverNickName];
            NSLog(@"电话头像URL = %@",model.user.avatar);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":[Tools md5EncryptWithString:model.user.userId], @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
        }
        
    }
}

/**
 *  处理关注点击
 *
 *  @param model model description
 */
- (void)loveBtnClickWithInfo:(CPIntersterModel *)model
{
    ZYAsyncThead(^{
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (int i = 0;i < self.datas.count; i++) {
            CPIntersterModel *obj = self.datas[i];
            if ([obj.user.userId isEqualToString:model.user.userId] && ![obj.activityId isEqualToString:model.activityId]) {
                obj.user.subscribeFlag = model.user.subscribeFlag;
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            }
            
        }
        ZYMainOperation(^{
            [self.tableView reloadData];
        });
        
    });
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
        
        [self dismissViewControllerAnimated:YES completion:NULL];
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
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
    [self presentViewController:pic animated:YES completion:NULL];
    
}

- (void)addPhoto:(NSArray *)arr
{
    
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
                    
                    NSString *filePath = [NSString stringWithFormat:@"%@.info",CPUserId];
                    CPUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath.documentPath];
                    
                    [albums insertObjects:user.album atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, user.album.count)]];
                    user.album = [albums copy];
                    [NSKeyedArchiver archiveRootObject:user toFile:filePath.documentPath];
                    if ([ZYUserDefaults boolForKey:CPHasAlbum] == NO && albums.count >= 2) {
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

/**
 *  处理约她的逻辑
 *
 *  @param userInfo user
 */
- (void)dateClickWithInfo:(id)userInfo
{
    CPGoLogin(@"邀TA");
    NSIndexPath *indexPath = userInfo;
    CPIntersterModel *model = self.datas[indexPath.row];
    if (model.type == 1) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"activity/%@/join?userId=%@&token=%@",model.relatedId, CPUserId, CPToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"destPoint"] = @{@"longitude" : @(CPLongitude),
                             @"latitude" : @(CPLatitude)};
    params[@"transfer"] = @(model.activityTransfer);
    params[@"type"] = model.activityType;
    params[@"pay"] = model.activityPay;
    params[@"destination"] = model.activityDestination;
    [self showLoading];
    [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            [self showInfo:@"邀请已发出"];
            model.activityStatus = 1;
            [self.tableView reloadData];
        }else{
            [self showInfo:CPErrorMsg];
        }
    } failed:^(NSError *error) {
        [self showInfo:@"邀请失败"];
    }];
    
}


#pragma mark - 加载子控件

- (UICollectionView *)tableView
{
    if (_tableView == nil) {
        ZYWaterflowLayout *layout = [ZYWaterflowLayout new];
        layout.delegate = self;
        _tableView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _tableView.alwaysBounceVertical = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        layout.rowMargin = 20;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.columnsCount = 1;
//        CGSize itemSzie= CGSizeMake(ZYScreenWidth - 20, 383 + self.offset);
//        layout.itemSize = itemSzie;
        //        layout.scrollDirection = UICollectionLayoutScrollDirectionVertical;
//        layout.itemScale = 0.96;
//        layout.LayoutDirection=UICollectionLayoutScrollDirectionVertical;
        self.view.backgroundColor = [Tools getColor:@"efefef"];
        [_tableView registerClass:[CPNearCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _tableView.panGestureRecognizer.delaysTouchesBegan = _tableView.delaysContentTouches;
        
    }
    return _tableView;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (CPNoDataTipView *)noDataView
{    if (_noDataView == nil) {
    _noDataView = [CPNoDataTipView noDataTipViewWithTitle:@"已经没有活动了,请放宽条件再试试"];
    [self.view addSubview:_noDataView];
    _noDataView.frame = self.tableView.bounds;
}
    return _noDataView;
}

@end
