//
//  CPNearViewController.m
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyDateViewController.h"
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

@interface CPMyDateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, strong) NSMutableArray<CPActivityModel *> *datas;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) CPNearParams *params;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, strong) CPNoDataTipView *noDataView;
@property (nonatomic, weak)   AAPullToRefresh *headerView;
@property (nonatomic, weak)   AAPullToRefresh *footerView;
@end

static NSString *ID = @"cell";
@implementation CPMyDateViewController

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
    [ZYLoadingView showLoadingView];
    if (CPUnLogin) {
        [self loadDataWithHeader:nil];
    }else{
        [[ZYNotificationCenter rac_addObserverForName:NOTIFICATION_LOGINSUCCESS object:nil] subscribeNext:^(NSNotification *notify) {
            
            BOOL loginSuccess = [notify.userInfo[NOTIFICATION_LOGINSUCCESS] boolValue];
            if (loginSuccess) {
                [self loadDataWithHeader:nil];
            }
        }];
    }
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
        self.params.ignore = 0;
        [self loadDataWithHeader:v];
    }];
    self.headerView.imageIcon = [UIImage imageNamed:@"车轮"];
    self.headerView.borderColor = [UIColor whiteColor];
    
    // bottom
    self.footerView = [_tableView addPullToRefreshPosition:AAPullToRefreshPositionBottom actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        ZYMainThread(^{
            
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, self.tableView.contentSizeHeight - self.tableView.height + 44) animated:YES];
        });
        
        if (self.datas.count >= CPPageNum) {
            self.params.ignore += CPPageNum;
            [self loadDataWithHeader:v];
        }else{
            [v stopIndicatorAnimation];
        }
    }];
    self.footerView.imageIcon = [UIImage imageNamed:@"车轮"];
    self.footerView.borderColor = [UIColor whiteColor];
    self.isHasRefreshHeader = YES;
}

/**
 *  加载网络数据
 */
- (void)loadDataWithHeader:(AAPullToRefresh *)refresh
{
    
    [ZYNetWorkTool getWithUrl:@"activity/list" params:self.params.keyValues success:^(id responseObject) {
        
        [[CPLoadingView sharedInstance] dismissLoadingView];
        [self setUpRefresh];
        [refresh stopIndicatorAnimation];
        DLog(@"%@ ---- ",responseObject);
        if (CPSuccess) {
            if (self.params.ignore == 0) {
                [self.datas removeAllObjects];
            }
            
            NSArray *arr = [CPActivityModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSLog(@"gggg%zd",arr.count);
            [self.datas addObjectsFromArray:arr];
            
            if (self.datas.count == 0) {
                self.noDataView.netWorkFailtype = NO;
                self.noDataView.hidden = NO;
            }else{
                self.noDataView.hidden = YES;
            }
            [self.tableView reloadData];
            if (self.tableView.contentOffset.y > 60 && refresh != self.footerView) {
                [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, 0) animated:YES];
            }
        }
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
    cell.indexPath = indexPath;
    cell.model = self.datas[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
////    if (self.headerView.state == AAPullToRefreshStateLoading || self.footerView.state == AAPullToRefreshStateLoading) {
////        return;
////    }
//    UICollectionView3DLayout *layout=(UICollectionView3DLayout*)self.tableView.collectionViewLayout;
//
//    [layout EndAnchorMove];
//}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
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
    }else if([notifyName isEqualToString:InvitedBtnClickKey]){
        
    }else if([notifyName isEqualToString:IgnoreBtnClickKey]){
        
    }else if([notifyName isEqualToString:LoveBtnClickKey]){
        [self loveBtnClickWithInfo:(CPActivityModel *)userInfo];
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
                    
                    NSString *filePath = [NSString stringWithFormat:@"%@.info",CPUserId];
                    CPUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath.documentPath];
                    
                    [albums insertObjects:user.album atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, user.album.count)]];
                    user.album = [albums copy];
                    [NSKeyedArchiver archiveRootObject:user toFile:filePath.documentPath];
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

/**
 *  处理约她的逻辑
 *
 *  @param userInfo user
 */
- (void)dateClickWithInfo:(id)userInfo
{
    CPGoLogin(@"邀TA");
    //    {
    //        “type”:”$type”,
    //        “pay”:”$pay”,
    //        “destPoint”:
    //        {
    //            “longitude”:”$longitude”,
    //            “latitude”:”$latitude”
    //        },
    //        “destination”:
    //        {
    //            “province”:”$province”,
    //            “city”:”$city”,
    //            “district”:”$district”,
    //            “street”:”$street”
    //        },
    //        “transfer”:”$transfer”
    //    }
    NSIndexPath *indexPath = userInfo;
    CPActivityModel *model = self.datas[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"activity/%@/join",model.activityId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[UserId] = CPUserId;
    params[Token] = CPToken;
    DLog(@"邀请%@",params);
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
        
        self.params.type = selectModel.type;
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

- (UIView *)tipView
{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = ZYColor(0, 0, 0, 0.7);
        [self.view addSubview:_tipView];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@64);
            make.width.equalTo(self.view);
            make.height.equalTo(@35);
        }];
        
        UILabel *textL = [UILabel labelWithText:@"有空,其他人可以邀请你参加活动" textColor:[UIColor whiteColor] fontSize:14];
        [_tipView addSubview:textL];
        [textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(_tipView);
        }];
        
        CPMySwitch *freeTimeBtn = [CPMySwitch new];
        [freeTimeBtn setOnImage:[UIImage imageNamed:@"btn_youkong"]];
        [freeTimeBtn setOffImage:[UIImage imageNamed:@"btn_meikong"]];
        freeTimeBtn.on = [ZYUserDefaults boolForKey:FreeTimeKey];
        [_tipView addSubview:freeTimeBtn];
        NSString *url = [NSString stringWithFormat:@"user/%@/info?token=%@",CPUserId,CPToken];
        [[freeTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(CPMySwitch *btn) {
            CPGoLogin(@"修改状态");
            btn.on = !btn.on;
            [ZYUserDefaults setBool:btn.on forKey:FreeTimeKey];
            if (btn.on) {
                textL.text = @"有空,其他人可以邀请你参加活动";
                [ZYNetWorkTool postJsonWithUrl:url params:@{@"idle" : @(YES)} success:^(id responseObject) {
                    
                } failed:^(NSError *error) {
                    
                }];
            }else{
                textL.text = @"没空,你将接受不到任何活动邀请";
                [ZYNetWorkTool postJsonWithUrl:url params:@{@"idle" : @(NO)} success:^(id responseObject) {
                    
                } failed:^(NSError *error) {
                    
                }];
            }
        }];
        [freeTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipView);
            make.right.equalTo(@-10);
        }];
        [RACObserve(self.tableView, contentOffset) subscribeNext:^(id x) {
            CGPoint p = [x CGPointValue];
            if (p.y <= 0 && p.y >= -10) {
                if (_tipView.alpha == 0) {
                    [UIView animateWithDuration:0.2 animations:^{
                        _tipView.alpha = 1;
                    }];
                }
            }else if (p.y > self.tableView.height - 383 - self.offset){
                if (_tipView.alpha == 1) {
                    [UIView animateWithDuration:0.2 animations:^{
                        _tipView.alpha = 0;
                    }];
                }
            }else if (p.y < -10){
                _tipView.alpha = 0;
            }
        }];
        
    }
    return _tipView;
}

- (CPNearParams *)params
{
    if (_params == nil) {
        //        latitude=39.97762675234624&limit=10&longitude=116.3317536236968
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
    _noDataView.frame = self.tableView.bounds;
}
    return _noDataView;
}

@end
