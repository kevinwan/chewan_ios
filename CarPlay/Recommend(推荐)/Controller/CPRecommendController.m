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
@end

@implementation CPRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self loadData];
}

/**
 *  加载网络数据
 */
- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[UserId] = CPUserId;
    params[Token] = CPToken;
    params[@"province"] = [ZYUserDefaults stringForKey:Province];
    params[@"city"] = [ZYUserDefaults stringForKey:City];
    params[@"district"] = [ZYUserDefaults stringForKey:District];
    params[@"limit"] = @10;
    [ZYNetWorkTool getWithUrl:@"official/activity/list" params:params success:^(id responseObject) {
        DLog(@"%@",responseObject);
        if (CPSuccess) {
            NSArray *arr = [CPRecommendModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datas addObjectsFromArray:arr];
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
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
    return 3;
//    return self.datas.count;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    CPRecommendCell *cell = (CPRecommendCell *)[flowView dequeueReusableCell];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPRecommendCell" owner:nil options:nil].lastObject;
//        cell.model = self.datas[index];
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
            CGRect frame = CGRectMake(x, y, w, h);
            frame;})];
        _collectionView.centerY = (ZYScreenHeight - 49 - 64) * 0.5 + 64;
        _collectionView.centerX = ZYScreenWidth * 0.5;
        _collectionView.orientation = PagedFlowViewOrientationHorizontal;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.minimumPageScale = 0.928;
        self.view.backgroundColor = [Tools getColor:@"efefef"];
        
        // 设置刷新控件
        ZYWeakSelf
        AAPullToRefresh *tv = [_collectionView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionLeft actionHandler:^(AAPullToRefresh *v){
            ZYStrongSelf
            [self.collectionView.scrollView setContentOffset:CGPointMake(-50, 0) animated:YES];
            [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1.0f];
        }];
        tv.imageIcon = [UIImage imageNamed:@"车轮"];
        tv.borderColor = [UIColor whiteColor];
        
        // bottom
        AAPullToRefresh *bv = [_collectionView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v){
            ZYStrongSelf
            [self.collectionView.scrollView setContentOffset:CGPointMake(_collectionView.scrollView.contentSize.width + 50 - _collectionView.scrollView.width, 0) animated:YES];
            [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1.0f];
        }];
        bv.imageIcon = [UIImage imageNamed:@"车轮"];
        bv.borderColor = [UIColor whiteColor];

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

@end
