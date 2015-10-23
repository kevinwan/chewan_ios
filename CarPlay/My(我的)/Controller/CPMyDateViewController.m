//
//  CPNearViewController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyDateViewController.h"
#import "AAPullToRefresh.h"
#import "ZYProgressView.h"
#import "CPNoDataTipView.h"
#import "CPTaInfo.h"
#import "CPLoadingView.h"
#import "UICollectionView3DLayout.h"
#import "CPNearCollectionViewCell.h"
#import "CPAlbum.h"
#import "ChatViewController.h"
#import "CPMyDateModel.h"

@interface CPMyDateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, strong) NSMutableArray<CPMyDateModel *> *datas;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, strong) CPNoDataTipView *noDataView;
@property (nonatomic, weak)   AAPullToRefresh *headerView;
@property (nonatomic, weak)   AAPullToRefresh *footerView;
@property (nonatomic, assign) CGFloat ignore;
@end

static NSString *ID = @"DateCell";
@implementation CPMyDateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的活动";
    self.view.backgroundColor = [UIColor whiteColor];

    if (CPNoNetWork) {
        
        [ZYProgressView showMessage:@"网络连接失败,请检查网络"];
        return;
    }
    
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [ZYLoadingView showLoadingView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.datas.count == 0) {
        [self loadDataWithHeader:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ZYLoadingView dismissLoadingView];
}

- (void)dealloc
{
    NSLog(@"%@从内存中销毁了😭",[self class]);
}

- (void)setUpRefresh
{
    if (self.isHasRefreshHeader) {
        return;
    }
    ZYWeakSelf
    self.headerView = [_tableView addPullToRefreshPosition:AAPullToRefreshPositionTop actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        ZYMainThread(^{
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, -44) animated:YES];
        });
        self.ignore = 0;
        [self loadDataWithHeader:v];
    }];
    
    // bottom
    self.footerView = [_tableView addPullToRefreshPosition:AAPullToRefreshPositionBottom actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        ZYMainThread(^{
            
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, self.tableView.contentSizeHeight - self.tableView.height + 44) animated:YES];
        });
        
        if (self.datas.count >= CPPageNum) {
            self.ignore += CPPageNum;
            [self loadDataWithHeader:v];
        }else{
            [v stopIndicatorAnimation];
        }
    }];
    self.isHasRefreshHeader = YES;
}

/**
 *  加载网络数据
 */
- (void)loadDataWithHeader:(AAPullToRefresh *)refresh
{
//    user/$userId/appointment/list
    NSString *url = [NSString stringWithFormat:@"user/%@/appointment/list?token=%@",CPUserId, CPToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ignore"] = @(self.ignore);
    [ZYNetWorkTool getWithUrl:url params:params success:^(id responseObject) {
        
        DLog(@"%@ ---- ",responseObject);
        [[CPLoadingView sharedInstance] dismissLoadingView];
        [self setUpRefresh];
        [refresh stopIndicatorAnimation];
        if (CPSuccess) {
            if (self.ignore == 0) {
                [self.datas removeAllObjects];
            }
            
            NSArray *arr = [CPMyDateModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSLog(@"gggg%zd",arr.count);
            [self.datas addObjectsFromArray:arr];
            
            if (self.datas.count == 0) {
                self.noDataView.netWorkFailtype = NO;
                self.noDataView.hidden = NO;
            }else{
                self.noDataView.hidden = YES;
            }
            [self.tableView reloadData];
        }
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
    cell.indexPath = indexPath;
    cell.myDateModel = self.datas[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
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

    }else if([notifyName isEqualToString:InvitedButtonClickKey]){
        NSIndexPath *indexPath = userInfo;
        CPMyDateModel *model = self.datas[indexPath.row];

        if (model.status == 1){
            //
        }else if (model.status == 2){
            //消息
//            NSString *userID = model.applyUserId;
//            if (![userID isEqualToString:CPUserId]) {
//                userID = model.invitedUserId;
//            }
            NSString *userID=[model.applyUserId isEqualToString:CPUserId]?model.invitedUserId:model.applyUserId;
            
            ChatViewController *xiaoniuChatVc = [[ChatViewController alloc]initWithChatter:[Tools md5EncryptWithString:userID] conversationType:eConversationTypeChat];
            xiaoniuChatVc.title = model.applicant.nickname;
            [self.navigationController pushViewController:xiaoniuChatVc animated:YES];
        }
        
    }else if([notifyName isEqualToString:IgnoreButtonClickKey]){
        NSIndexPath *indexPath = userInfo;
        CPMyDateModel *model = self.datas[indexPath.row];
        if (model.status == 1) {
            
            [self.datas removeObjectAtIndex:[userInfo row]];
            [self.tableView deleteItemsAtIndexPaths:@[userInfo]];
        }else if (model.status == 2){
            //电话
            NSString *userID=[model.applyUserId isEqualToString:CPUserId]?model.invitedUserId:model.applyUserId;

            [ZYUserDefaults setValue:model.applicant.avatar forKey:kReceiverHeadUrl];
            [ZYUserDefaults setValue: model.applicant.nickname forKey:kReceiverNickName];
            NSLog(@"电话头像URL = %@",model.applicant.avatar);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":[Tools md5EncryptWithString:userID], @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];

        }
    }else if([notifyName isEqualToString:LoveBtnClickKey]){
        [self loveBtnClickWithInfo:(CPMyDateModel *)userInfo];
    }else if ([notifyName isEqualToString:IconViewClickKey]){
        CPGoLogin(@"查看TA的详情");
        CPTaInfo *taVc = [UIStoryboard storyboardWithName:@"TaInfo" bundle:nil].instantiateInitialViewController;
        CPActivityModel *model = userInfo;
        taVc.userId = model.organizer.userId;
        [self.navigationController pushViewController:taVc animated:YES];
    }
}

/**
 *  处理关注点击
 *
 *  @param model model description
 */
- (void)loveBtnClickWithInfo:(CPMyDateModel *)model
{
    ZYAsyncThead(^{
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (int i = 0;i < self.datas.count; i++) {
            CPMyDateModel *obj = self.datas[i];
            if ([obj.applyUserId isEqualToString:model.applyUserId] && ![obj.activityId isEqualToString:model.activityId]) {
                obj.applicant.subscribeFlag = model.applicant.subscribeFlag;
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            }
            
        }
        ZYMainThread(^{
            [self.tableView reloadItemsAtIndexPaths:indexPaths];
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
                [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                
                count++;
                
                CPAlbum *album = [CPAlbum objectWithKeyValues:responseObject[@"data"]];
                [albums addObject:album];
                if (count == arr.count) {
                    [self disMiss];
                    ZYAsyncThead(^{
                        NSString *filePath = [NSString stringWithFormat:@"%@.info",CPUserId];
                        CPUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath.documentPath];
                        
                        [albums insertObjects:user.album atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, user.album.count)]];
                        user.album = [albums copy];
                        [NSKeyedArchiver archiveRootObject:user toFile:filePath.documentPath];
                    });
                   
                    [self.tableView reloadData];
                }
            }else{
                [self showError:responseObject[@"errmsg"]];
            }
            
        } failure:^(NSError *error) {
            [self showError:@"照片上传失败"];
        }];
    }
    
}

#pragma mark - 加载子控件

- (UICollectionView *)tableView
{
    if (_tableView == nil) {
        UICollectionView3DLayout *layout = [UICollectionView3DLayout new];
        //        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _tableView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _tableView.alwaysBounceVertical = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CGSize itemSzie= CGSizeMake(ZYScreenWidth - 20, 383 + self.offset);
        layout.itemSize = itemSzie;
        //        layout.scrollDirection = UICollectionLayoutScrollDirectionVertical;
        layout.itemScale = 0.96;
        layout.LayoutDirection=UICollectionLayoutScrollDirectionVertical;
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
