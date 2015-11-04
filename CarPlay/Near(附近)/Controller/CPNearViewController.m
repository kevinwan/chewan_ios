//
//  CPNearViewController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPNearViewController.h"
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
#import "CPMyInterestViewController.h"
#import "NSObject+Copying.h"
#import "SDImageCache.h"

@interface CPNearViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, strong) NSMutableArray<CPActivityModel *> *datas;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) CPNearParams *params;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, assign) BOOL isLoginSuccess;
@property (nonatomic, strong) CPNoDataTipView *noDataView;
@property (nonatomic, weak)   AAPullToRefresh *headerView;
@property (nonatomic, weak)   AAPullToRefresh *footerView;
@end

static NSString *ID = @"cell";
@implementation CPNearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (CPNoNetWork) {
        
        [ZYProgressView showMessage:@"网络连接失败,请检查网络"];
        return;
    }
    
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"筛选" target:self action:@selector(filter)];
    [self.view addSubview:self.tableView];
    [self tipView];
    ZYWeakSelf
    [[ZYNotificationCenter rac_addObserverForName:NOTIFICATION_LOGINSUCCESS object:nil] subscribeNext:^(NSNotification *notify) {
        ZYStrongSelf
        BOOL loginSuccess = [notify.userInfo[NOTIFICATION_LOGINSUCCESS] boolValue];
        self.isLoginSuccess = loginSuccess;
        if (loginSuccess) {
            [self loadDataWithHeader:nil];
        }else{
            [self loadDataWithHeader:nil];
        }
    }];
    
    [[ZYNotificationCenter rac_addObserverForName:NOTIFICATION_HASLOGIN object:nil] subscribeNext:^(id x) {
        ZYStrongSelf
        [self.tableView reloadData];
    }];
    [[ZYNotificationCenter rac_addObserverForName:@"DID_LOG_OUT_SUCCESS" object:nil] subscribeNext:^(id x) {
        ZYStrongSelf
        self.params = nil;
        [self.datas removeAllObjects];
        [self loadDataWithHeader:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (self.datas.count == 0) {
//        [ZYLoadingView showLoadingView];
//    }
    if (CPUnLogin) {
        if (self.datas.count == 0) {
            [ZYLoadingView showLoadingView];
            [self loadDataWithHeader:nil];
        }
    }else{
        if (self.isLoginSuccess) {
            if (self.datas.count == 0) {
                [ZYLoadingView showLoadingView];
                [self loadDataWithHeader:nil];
            }
        }
    }
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
            
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, -44 - self.tableView.contentInsetTop) animated:YES];
        });
        
        self.params.ignore = 0;
        [self loadDataWithHeader:v];
    }];
    
    if (self.datas.count <= 1) {
        return;
    }
    
    // bottom
    self.footerView = [_tableView addPullToRefreshPosition:AAPullToRefreshPositionBottom actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        ZYMainOperation(^{
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, self.tableView.contentSizeHeight - self.tableView.height + 44 + self.tableView.contentInsetTop) animated:YES];
        });
            
        if (self.datas.count % CPPageNum == 0) {
            self.params.ignore += CPPageNum;
            [self loadDataWithHeader:v];
        }else{
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [v stopIndicatorAnimation];
            });
        }
    }];
    self.isHasRefreshHeader = YES;
}

/**
 *  加载网络数据
 */
- (void)loadDataWithHeader:(AAPullToRefresh *)refresh
{

    [ZYNetWorkTool getWithUrl:@"activity/list" params:self.params.keyValues success:^(id responseObject) {
        
        [refresh stopIndicatorAnimation];
        if (CPSuccess) {
            DLog(@"%@",responseObject);
            if (self.params.ignore == 0) {
                [self.datas removeAllObjects];
            }
                
            NSArray *arr = [CPActivityModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datas addObjectsFromArray:arr];
            
            [self setUpRefresh];
            if (self.datas.count == 0) {
                self.noDataView.netWorkFailtype = NO;
                self.noDataView.hidden = NO;
            }else{
                self.noDataView.hidden = YES;
            }
            [self.tableView reloadData];
//            if (self.tableView.contentOffset.y > 60 && refresh != self.footerView) {
//                [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, 0) animated:YES];
//            }
        }else{
            
            [self setUpRefresh];
            [self showInfo:CPErrorMsg];
        }
        
        [[CPLoadingView sharedInstance] dismissLoadingView];
    } failure:^(NSError *error) {
        
        [self setUpRefresh];
        DLog(@"%@---",error);
        self.params.ignore -= CPPageNum;
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
    cell.contentV.model = self.datas[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (iPhone4) {
        return;
    }
    UICollectionView3DLayout *layout=(UICollectionView3DLayout*)self.tableView.collectionViewLayout;

    [layout EndAnchorMove];
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
        CPActivityModel *model = self.datas[[userInfo row]];
        [self loveBtnClickWithInfo:model];
    }else if ([notifyName isEqualToString:IconViewClickKey]){
        CPGoLogin(@"查看TA的详情");
        CPTaInfo *taVc = [UIStoryboard storyboardWithName:@"TaInfo" bundle:nil].instantiateInitialViewController;
        NSIndexPath *indexPath = userInfo;
        taVc.userId = self.datas[indexPath.row].organizer.userId;
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
    ZYAsyncThead(^{
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (int i = 0;i < self.datas.count; i++) {
            CPActivityModel *obj = self.datas[i];
            if ([obj.organizer.userId isEqualToString:model.organizer.userId] && ![obj.activityId isEqualToString:model.activityId]) {
                obj.organizer.subscribeFlag = model.organizer.subscribeFlag;
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            }
            
        }
        ZYMainOperation(^{
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
                    if ([ZYUserDefaults boolForKey:CPHasAlbum] == NO) {
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
    CPActivityModel *model = self.datas[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"activity/%@/join",model.activityId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"destPoint"] = @{@"longitude" : @(CPLongitude),
                             @"latitude" : @(CPLatitude)};
    params[@"transfer"] = @(model.transfer);
    params[@"type"] = model.type;
    params[@"pay"] = model.pay;
    params[@"destination"] = model.destination;
    params[UserId] = CPUserId;
    params[Token] = CPToken;
    [self showLoading];
    [CPNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            [self showInfo:@"邀请已发出"];
            model.applyFlag = 1;
            [self.tableView reloadItemsAtIndexPaths:@[indexPath]];
        }else if ([CPErrorMsg contains:@"申请中"]){
            [self showInfo:@"正在申请中"];
        }
    } failed:^(NSError *error) {
        [self showInfo:@"邀请失败"];
    }];
    
}

/**
 *  筛选按钮点击
 */
- (void)filter
{
    [CPSelectView showWithParams:^(CPSelectModel *selectModel) {
        
        self.params.majorType = selectModel.type;
        self.params.pay = selectModel.pay;
        self.params.gender = selectModel.sex;
        self.params.transfer = selectModel.transfer;
        self.params.ignore = 0;
        [self loadDataWithHeader:nil];
    }];
}

#pragma mark - 加载子控件

- (UICollectionView *)tableView
{
    if (_tableView == nil) {
        UICollectionView3DLayout *layout = [UICollectionView3DLayout new];
        _tableView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _tableView.alwaysBounceVertical = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CGSize itemSzie= CGSizeMake(ZYScreenWidth - 20, 390 + self.offset);
        layout.itemSize = itemSzie;
        if (iPhone4) {
            [_tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
        }
        layout.itemScale = 1.0;
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

- (UIView *)tipView
{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = ZYColor(0, 0, 0, 0.7);
        [self.view addSubview:_tipView];
        _tipView.width = self.view.width;
        _tipView.height = 35;
        _tipView.y = 64;
        _tipView.x = 0;
      
        UILabel *textL = [UILabel labelWithText:@"无聊中～小伙伴可以邀你～" textColor:[UIColor whiteColor] fontSize:14];
        [_tipView addSubview:textL];
        [textL sizeToFit];
        textL.x = 10;
        textL.centerY = _tipView.middleY;
        
        CPMySwitch *freeTimeBtn = [CPMySwitch new];
        [freeTimeBtn setOnImage:[UIImage imageNamed:@"btn_youkong"]];
        [freeTimeBtn setOffImage:[UIImage imageNamed:@"btn_meikong"]];
        freeTimeBtn.on = [ZYUserDefaults boolForKey:FreeTimeKey];
        [freeTimeBtn sizeToFit];
        [_tipView addSubview:freeTimeBtn];
        ZYWeakSelf
        [[freeTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(CPMySwitch *btn) {
            ZYStrongSelf
            CPGoLogin(@"修改状态");
            
            NSString *url = [NSString stringWithFormat:@"user/%@/info?token=%@",CPUserId,CPToken];
            [ZYUserDefaults setBool:btn.on forKey:FreeTimeKey];
            btn.on = !btn.on;
            if (btn.on) {
                textL.text = @"无聊中～小伙伴可以邀你～";
                [ZYNetWorkTool postJsonWithUrl:url params:@{@"idle" : @(YES)} success:^(id responseObject) {
                    if (CPSuccess){
                        [self showInfo:@"有空"];
                    }else{
                        btn.on = NO;
                        [self showInfo:CPErrorMsg];
                    }
                } failed:^(NSError *error) {
                    btn.on = NO;
                }];
            }else{
                textL.text = @"忙碌中～小伙伴不可邀你～";
                [ZYNetWorkTool postJsonWithUrl:url params:@{@"idle" : @(NO)} success:^(id responseObject) {
                    if (CPSuccess){
                        [self showInfo:@"没空"];
                    }else{
                        btn.on = YES;
                        [self showInfo:CPErrorMsg];
                    }
                } failed:^(NSError *error) {
                    btn.on = YES;
                }];
            }
        }];
        freeTimeBtn.centerY = _tipView.middleY;
        freeTimeBtn.x = _tipView.width - freeTimeBtn.width - 10;
        CGFloat originY = 64;
        
        [RACObserve(self.tableView, contentOffset) subscribeNext:^(id x) {
            CGPoint p = [x CGPointValue];
            if (p.y <= 0 && p.y >= -10) {
                if (_tipView.alpha == 0) {
                    [UIView animateWithDuration:0.5 animations:^{
                        _tipView.alpha = 1;
                        _tipView.y = originY;
                    }];
                }
            }else if (p.y > self.tableView.height - 383 - self.offset){
                if (_tipView.alpha == 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    _tipView.alpha = 0;
                    _tipView.y = originY - _tipView.height;
                }];
                }
            }else if (p.y < -10 && !iPhone4){
                _tipView.alpha = 0;
            }
        }];

    }
    return _tipView;
}

- (CPNearParams *)params
{
    if (_params == nil) {
        _params = [[CPNearParams alloc] init];
        _params.longitude = 116.3317536236968;
        _params.latitude = 39.97762675234624;
        
//        _params.longitude = ZYLongitude;
//        _params.latitude = ZYLatitude;
        _params.ignore = 0;
        _params.limit = 10;
    }
    return _params;
}

- (CPNoDataTipView *)noDataView
{    if (_noDataView == nil) {
        _noDataView = [CPNoDataTipView noDataTipViewWithTitle:@"已经没有活动了,请放宽条件再试试"];
        [self.view addSubview:_noDataView];
        _noDataView.frame = self.view.bounds;
    }
    return _noDataView;
}

@end
