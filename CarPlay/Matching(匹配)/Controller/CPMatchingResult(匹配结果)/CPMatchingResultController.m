//
//  CPMatchingResultController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/26.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMatchingResultController.h"
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
#import "CPWheelView.h"
#import<CoreText/CoreText.h>

@interface CPMatchingResultController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>{
    UILabel *countdownLabel;
    UILabel *countLabel;
    NSMutableAttributedString *countText;
    NSTimer *timer;
    NSTimer *startUp;
    int startUpFrom;
    int timeout;
    int totalCount;
}
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, strong) NSMutableArray<CPActivityModel *> *datas;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) CPNearParams *params;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, weak)   AAPullToRefresh *headerView;
@property (nonatomic, weak)   AAPullToRefresh *footerView;
@property (nonatomic, strong)   UIView *loadingView;
@end
static NSString *ID = @"cell";

@implementation CPMatchingResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    countdownLabel=[UILabel new];
    countLabel=[UILabel new];
    
    if (CPNoNetWork) {
        [ZYProgressView showMessage:@"网络连接失败,请检查网络"];
        return;
    }
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.loadingView];
    timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    startUp = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(startUp) userInfo:nil repeats:YES];
    [ZYNotificationCenter addObserver:self selector:@selector(start) name:NOTIFICATION_STARTMATCHING object:nil];
}

-(void)start{
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:[ZYUserDefaults stringForKey:LastType],@"majorType",CPUserId,UserId,CPToken,Token,@(CPLongitude),@"longitude",@(CPLatitude),@"latitude",@(300),@"limit",nil];
    
    [ZYNetWorkTool getWithUrl:@"activity/count" params:param success:^(id responseObject) {
        if (CPSuccess) {
            totalCount = [responseObject[@"data"][@"count"] intValue];
            [startUp setFireDate:[NSDate distantPast]];
            [timer setFireDate:[NSDate distantPast]];
            timeout=60;
            totalCount=0;
            startUpFrom=0;
            startUpFrom=0;
            [self.loadingView setHidden:NO];
        }
    } failure:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setHidden:YES];
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
        self.params.ignore = 0;
        [self loadDataWithHeader:v];
    }];
    // bottom
    self.footerView = [_tableView addPullToRefreshPosition:AAPullToRefreshPositionBottom actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        ZYMainOperation(^{
            
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, self.tableView.contentSizeHeight - self.tableView.height + 44) animated:YES];
        });
        
        if (self.datas.count >= CPPageNum) {
            self.params.ignore += CPPageNum;
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
    if ([ZYUserDefaults stringForKey:LastType]) {
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:[ZYUserDefaults stringForKey:LastType],@"majorType",CPUserId,UserId,CPToken,Token,@(CPLongitude),@"longitude",@(CPLatitude),@"latitude",nil];
        
        [ZYNetWorkTool getWithUrl:@"activity/list" params:param success:^(id responseObject) {
            
            [self setUpRefresh];
            [refresh stopIndicatorAnimation];
            if (CPSuccess) {
//                [self.tableView setHidden:NO];
                if (self.params.ignore == 0) {
                    [self.datas removeAllObjects];
                }
                NSArray *arr = [CPActivityModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [self.datas addObjectsFromArray:arr];
                [self.tableView reloadData];
                if (self.tableView.contentOffset.y > 60 && refresh != self.footerView) {
                    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffsetX, 0) animated:YES];
                }
            }
            
            [ZYUserDefaults setObject:nil forKey:LastType];
            [[CPLoadingView sharedInstance] dismissLoadingView];
        } failure:^(NSError *error) {
            [self setUpRefresh];
            self.params.ignore -= CPPageNum;
            [refresh stopIndicatorAnimation];
            [self showError:@"加载失败"];
            [ZYLoadingView dismissLoadingView];
        }];
    }
}

#pragma mark - UICollectionViewDelegate &dataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPNearCollectionViewCell *cell = (CPNearCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
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
    //    if (self.headerView.state == AAPullToRefreshStateLoading || self.footerView.state == AAPullToRefreshStateLoading) {
    //        return;
    //    }
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

- (void)didReceiveMemoryWarning
{
    [[SDImageCache sharedImageCache] clearMemory];
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

-(UIView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [UIView new];
        
//        添加‘正在匹配活动’提示
        UILabel *macthLabel=[UILabel new];
        [macthLabel setFrame:CGRectMake(0, 166/538.0*ZYScreenHeight, ZYScreenWidth, 16)];
        [macthLabel setText:@"正在匹配活动"];
        [macthLabel setTextColor:[Tools getColor:@"999999"]];
        [macthLabel setTextAlignment:NSTextAlignmentCenter];
        [macthLabel setBackgroundColor:[UIColor clearColor]];
        [macthLabel setFont:ZYFont16];
        [self.loadingView addSubview:macthLabel];
        
//        添加车轮
        CPWheelView *wheelView=[CPWheelView new];
        [wheelView setCenter:CGPointMake(ZYScreenWidth/2, 264.5/528.0*ZYScreenHeight)];
        [self.loadingView addSubview:wheelView];
        [wheelView startAnimation];
        [self.navigationController setNavigationBarHidden:YES];
        [self.loadingView setBackgroundColor:[Tools getColor:@"efefef"]];
        [self.loadingView setFrame: self.view.bounds];
        
//        添加倒计时
        [countdownLabel setFrame:CGRectMake(0, wheelView.bottom+14.0, ZYScreenWidth, 14)];
        [countdownLabel setText:@"60S"];
        [countdownLabel setTextColor:[Tools getColor:@"cbcbcb"]];
        [countdownLabel setTextAlignment:NSTextAlignmentCenter];
        [countdownLabel setBackgroundColor:[UIColor clearColor]];
        [countdownLabel setFont:ZYFont14];
        [self.loadingView addSubview:countdownLabel];
        
//        添加匹配活动个数提示
       
        [countLabel setFrame:CGRectMake(0,countdownLabel.bottom+40, ZYScreenWidth, 14)];
        countText=[[NSMutableAttributedString alloc]initWithString:@"已匹配到附近 0 个活动"];
        [countLabel setTextColor:[Tools getColor:@"999999"]];
        [countText addAttribute:NSForegroundColorAttributeName value:[Tools getColor:@"333333"] range:NSMakeRange(6, 3)];
        [countLabel setAttributedText:countText];
        [countLabel setTextAlignment:NSTextAlignmentCenter];
        [countLabel setBackgroundColor:[UIColor clearColor]];
        [countLabel setFont:ZYFont14];
        [self.loadingView addSubview:countLabel];
    }
    return _loadingView;
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

//倒计时
-(void)countdown{
    NSString *strTime = [NSString stringWithFormat:@"%.2dS", timeout];
    [countdownLabel setText:strTime];
    if (timeout==0) {
        [timer setFireDate:[NSDate distantFuture]];
        [self loadDataWithHeader:nil];
        [self.loadingView setHidden:YES];
        [self.tableView setHidden:NO];
        [self.navigationController setNavigationBarHidden:NO];
    }
    timeout--;
}

//数字开始涨
-(void)startUp{
    if (startUpFrom > totalCount) {
        [startUp setFireDate:[NSDate distantFuture]];
    }else{
        NSString *numStr=[NSString stringWithFormat:@"已匹配到附近 %d 个活动",startUpFrom];
        
        countText=[[NSMutableAttributedString alloc]initWithString:numStr];
        if (startUpFrom<10) {
            [countText addAttribute:NSForegroundColorAttributeName value:[Tools getColor:@"333333"] range:NSMakeRange(6, 3)];
        }else if (startUpFrom <100){
            [countText addAttribute:NSForegroundColorAttributeName value:[Tools getColor:@"333333"] range:NSMakeRange(6, 4)];
        }else{
            [countText addAttribute:NSForegroundColorAttributeName value:[Tools getColor:@"333333"] range:NSMakeRange(6, 5)];
        }
        [countLabel setAttributedText:countText];
        if (startUpFrom == 300) {
            [startUp setFireDate:[NSDate distantFuture]];
            [timer setFireDate:[NSDate distantFuture]];
            [self loadDataWithHeader:nil];
            [self.loadingView setHidden:YES];
            [self.tableView setHidden:NO];
            [self.navigationController setNavigationBarHidden:NO];
        }
        startUpFrom++;
    }
}

@end
