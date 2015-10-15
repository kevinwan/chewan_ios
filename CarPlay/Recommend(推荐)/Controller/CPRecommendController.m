//
//  CPRecommendController.m
//  CarPlay
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//  推荐活动

#import "CPRecommendController.h"
#import "CPRecommendCell.h"
#import "PagedFlowView.h"
#import "CPActivityDetailViewController.h"
#import "CPRecommendModel.h"
#import "AAPullToRefresh.h"

@interface CPRecommendController ()<PagedFlowViewDelegate, PagedFlowViewDataSource>
@property (nonatomic, strong) PagedFlowView *collectionView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) ZYRefreshView *refreshView;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, assign) NSUInteger ignore;
@end

@implementation CPRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self loadDataWithHeader:nil];
    [self.view addSubview:self.refreshView];
}

- (void)setUpRefresh
{
    if (self.isHasRefreshHeader) {
        return;
    }
    // 设置刷新控件
    ZYWeakSelf
    AAPullToRefresh *tv = [_collectionView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionLeft actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        [self.collectionView.scrollView setContentOffset:CGPointMake(-44, 0) animated:YES];
        self.ignore = 0;
        [self loadDataWithHeader:v];
    }];
    tv.imageIcon = [UIImage imageNamed:@"车轮"];
    tv.borderColor = [UIColor whiteColor];
    
    // bottom
    AAPullToRefresh *bv = [_collectionView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        [self.collectionView.scrollView setContentOffset:CGPointMake(_collectionView.scrollView.contentSize.width + 44 - _collectionView.scrollView.width, 0) animated:YES];
        
        if (self.datas.count >= CPPageNum) {
            self.ignore += CPPageNum;
            [self loadDataWithHeader:v];
        }else{
            [v stopIndicatorAnimation];
        }
    }];

    bv.imageIcon = [UIImage imageNamed:@"车轮"];
    bv.borderColor = [UIColor whiteColor];
    
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
//    params[@"province"] = [ZYUserDefaults stringForKey:Province];
//    params[@"city"] = [ZYUserDefaults stringForKey:City];
//    params[@"district"] = [ZYUserDefaults stringForKey:District];
    params[@"province"] = @"江苏省";
    params[@"city"] = @"南京市";
//    params[@"district"] = [ZYUserDefaults stringForKey:District];
    [ZYNetWorkTool getWithUrl:@"official/activity/list" params:params success:^(id responseObject) {
        self.refreshView.hidden = YES;
        [self setUpRefresh];
        [refreshView stopIndicatorAnimation];
        DLog(@"office %@",responseObject);
        if (CPSuccess) {
            
            
            if (self.ignore == 0){
                [self.datas removeAllObjects];
            }
            NSArray *arr = [CPRecommendModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datas addObjectsFromArray:arr];
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        [self showInfo:@"加载失败"];
        self.refreshView.hidden = YES;
        [self setUpRefresh];
        [refreshView stopIndicatorAnimation];
    }];
}

#pragma mark - 事件交互
- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if ([notifyName isEqualToString:RecommentAddressClickKey]) {
        NSLog(@"国家体育馆");
    }
}

#pragma mark - flowViewDelegate & flowViewDataSource
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return self.datas.count;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    CPRecommendCell *cell = (CPRecommendCell *)[flowView dequeueReusableCell];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPRecommendCell" owner:nil options:nil].lastObject;
        cell.model = self.datas[index];
    }
    return cell;
}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index
{
    CPActivityDetailViewController *activityDetailVc = [CPActivityDetailViewController new];
    [self.navigationController pushViewController:activityDetailVc animated:YES];
}

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    if (iPhone4) {
        return CGSizeMake(ZYScreenWidth - 36,345 );
    }
    
    return CGSizeMake(ZYScreenWidth - 36,ZYScreenWidth + 100);
}

#pragma mark - lazy
- (PagedFlowView *)collectionView
{
    if (_collectionView == nil) {
        
        CGFloat offset = (ZYScreenWidth - 320);
        _collectionView = [[PagedFlowView alloc] initWithFrame:({
            CGFloat x = 18;
            
            CGFloat y = 84;
            if (iPhone4) {
                y = 44;
            }
            CGFloat w = ZYScreenWidth - 36;
            CGFloat h = offset + 420;
            CGRectMake(x, y, w, h);
            })];
        _collectionView.centerY = (ZYScreenHeight - 49 - 64) * 0.5 + 64;
        _collectionView.centerX = ZYScreenWidth * 0.5;
        _collectionView.orientation = PagedFlowViewOrientationHorizontal;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.minimumPageScale = 0.928;
        self.view.backgroundColor = [Tools getColor:@"efefef"];
        
       
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

- (ZYRefreshView *)refreshView
{
    if (_refreshView == nil) {
        _refreshView = [[ZYRefreshView alloc] init];
        [self.view addSubview:_refreshView];
        _refreshView.center = self.view.center;
    }
    return _refreshView;
}

@end
