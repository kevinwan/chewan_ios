//
//  CPRecommendController.m
//  CarPlay
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//  推荐活动

#import "CPRecommendController.h"
#import "CPActivityDetailViewController.h"
#import "CPRecommendModel.h"
#import "AAPullToRefresh.h"
#import "UICollectionView3DLayout.h"
#import "CPRecommentViewCell.h"
#import "CPNoDataTipView.h"

@interface CPRecommendController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CPNoDataTipView *noDataView;
@property (nonatomic, strong) NSMutableArray<CPRecommendModel *> *datas;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, assign) NSUInteger ignore;
@end
static NSString *ID = @"RecommentCell";
@implementation CPRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.datas.count == 0) {
        [ZYLoadingView showLoadingView];
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
    // 设置刷新控件
    ZYWeakSelf
    [_collectionView addPullToRefreshPosition:AAPullToRefreshPositionLeft actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        ZYMainOperation(^{
            
            [self.collectionView setContentOffset:CGPointMake(-44, 0) animated:YES];
        });
        self.ignore = 0;
        
        [self loadDataWithHeader:v];
    }];
    // bottom
    [_collectionView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        
        ZYMainOperation(^{
           [self.collectionView setContentOffset:CGPointMake(_collectionView.contentSize.width + 44 - _collectionView.width, 0) animated:YES];
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
    
    self.isHasRefreshHeader = YES;
}


/**
 *  加载网络数据
 */
- (void)loadDataWithHeader:(AAPullToRefresh *)refreshView
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[UserId] = CPUserId;
    params[Token] = CPToken;
//        params[@"province"] = @"北京";
//        params[@"city"] = @"北京";
    //    params[@"district"] = [ZYUserDefaults stringForKey:District];
    
    NSString *province = [[ZYUserDefaults stringForKey:Province] stringByReplacingOccurrencesOfString:@"省" withString:@""];
    province = [province stringByReplacingOccurrencesOfString:@"市" withString:@""];
    NSString *city = [[ZYUserDefaults stringForKey:City] stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if (province.trimLength) {
        params[@"province"] = province;
    }
    if (city.trimLength) {
        params[@"city"] = city;
    }
    params[@"ignore"] = @(self.ignore);
    [ZYNetWorkTool getWithUrl:@"official/activity/list" params:params success:^(id responseObject) {
        [ZYLoadingView dismissLoadingView];
        [self setUpRefresh];
        [refreshView stopIndicatorAnimation];
        DLog(@"office %@",responseObject);
        if (CPSuccess) {
            
            if (self.ignore == 0){
                [self.datas removeAllObjects];
            }
            NSArray *arr = [CPRecommendModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datas addObjectsFromArray:arr];
            if (self.datas.count == 0) {
                self.noDataView.netWorkFailtype = NO;
                self.noDataView.hidden = NO;
            }else{
                self.noDataView.hidden = YES;
                
                [self.collectionView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [self showInfo:@"加载失败"];
        [self setUpRefresh];
        [ZYLoadingView dismissLoadingView];
        self.ignore -=CPPageNum;
        self.noDataView.hidden = NO;
        [refreshView stopIndicatorAnimation];
        
    }];
}

#pragma mark - 事件交互
- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if ([notifyName isEqualToString:RecommentAddressClickKey]) {
        NSLog(@"国家体育馆");
    }else if ([notifyName isEqualToString:@"ImageClickKey"]){
        NSIndexPath *indexPath = userInfo;
        CPActivityDetailViewController *activityVc = [UIStoryboard storyboardWithName:@"CPActivityDetailViewController" bundle:nil].instantiateInitialViewController;
        activityVc.officialActivityId = self.datas[indexPath.item].officialActivityId;
        [self.navigationController pushViewController:activityVc animated:YES];
    }
}

#pragma mark - flowViewDelegate & flowViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = self.datas[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPActivityDetailViewController *activityVc = [UIStoryboard storyboardWithName:@"CPActivityDetailViewController" bundle:nil].instantiateInitialViewController;
    activityVc.officialActivityId = self.datas[indexPath.item].officialActivityId;
    [self.navigationController pushViewController:activityVc animated:YES];
}

/**
 *  分页效果
 *
 *  @param scrollView scrollView
 *  @param decelerate 减速方法
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    UICollectionView3DLayout *layout=(UICollectionView3DLayout*)self.collectionView.collectionViewLayout;
    [layout EndAnchorMove];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    UICollectionView3DLayout *layout=(UICollectionView3DLayout*)self.collectionView.collectionViewLayout;
    [layout EndAnchorMove];
    
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        UICollectionView3DLayout *layout = [UICollectionView3DLayout new];
        layout.LayoutDirection = UICollectionLayoutScrollDirectionHorizontal;
        CGSize itemSize;
        if (iPhone4) {
            itemSize = CGSizeMake(ZYScreenWidth - 36,345);
        }else{
            
            itemSize = CGSizeMake(ZYScreenWidth - 36,ZYScreenWidth + 93);
        }
        
        layout.itemSize = itemSize;
        layout.itemScale = 0.94;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ZYScreenWidth, itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom) collectionViewLayout:layout];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.backgroundColor = [Tools getColor:@"efefef"];
        _collectionView.centerY = (ZYScreenHeight - 64- 49) * 0.5 + 64;
        _collectionView.centerX = ZYScreenWidth * 0.5;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        self.view.backgroundColor = [Tools getColor:@"efefef"];
        [_collectionView registerClass:[CPRecommentViewCell class] forCellWithReuseIdentifier:ID];
        _collectionView.panGestureRecognizer.delaysTouchesBegan = _collectionView.delaysContentTouches;
    }
    return _collectionView;
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
        _noDataView = [CPNoDataTipView noDataTipViewWithTitle:@"暂时没有活动了"];
        [self.view addSubview:_noDataView];
        _noDataView.frame = self.view.bounds;
    }
    return _noDataView;
}


@end
