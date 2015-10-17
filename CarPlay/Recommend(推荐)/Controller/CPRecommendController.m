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
#import "UICollectionView3DLayout.h"
#import "CPRecommentViewCell.h"

@interface CPRecommendController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) ZYRefreshView *refreshView;
@property (nonatomic, assign) BOOL isHasRefreshHeader;
@property (nonatomic, assign) NSUInteger ignore;
@end
static NSString *ID = @"cell";
@implementation CPRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    AAPullToRefresh *tv = [_collectionView addPullToRefreshPosition:AAPullToRefreshPositionLeft actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        [self.collectionView setContentOffset:CGPointMake(-44, 0) animated:YES];
        self.ignore = 0;
        [self loadDataWithHeader:v];
    }];
    tv.imageIcon = [UIImage imageNamed:@"车轮"];
    tv.borderColor = [UIColor whiteColor];
    
    // bottom
    AAPullToRefresh *bv = [_collectionView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
        ZYStrongSelf
        [self.collectionView setContentOffset:CGPointMake(_collectionView.contentSize.width + 44 - _collectionView.width, 0) animated:YES];
        
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPRecommentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.datas[indexPath.item];
    return cell;
}

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return self.datas.count;
}
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
            
            itemSize = CGSizeMake(ZYScreenWidth - 36,ZYScreenWidth + 100);
        }
        
        layout.itemSize = itemSize;
        layout.itemScale = 0.94;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ZYScreenWidth, itemSize.height + layout.sectionInset.top + layout.sectionInset.bottom) collectionViewLayout:layout];
        
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
