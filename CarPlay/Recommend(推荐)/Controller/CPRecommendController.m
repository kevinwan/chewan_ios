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

@interface CPRecommendController ()<PagedFlowViewDelegate, PagedFlowViewDataSource>
@property (nonatomic, strong) PagedFlowView *collectionView;
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
    params[@"province"] = @"江苏省";
    params[@"city"] = @"南京市";
    params[@"district"] = @"玄武区";
    params[@"limit"] = @10;
    [ZYNetWorkTool getWithUrl:@"official/activity/list" params:params success:^(id responseObject) {
        DLog(@"%@",responseObject);
        if (CPSuccess) {
            
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
    return 10;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    CPRecommendCell *cell = (CPRecommendCell *)[flowView dequeueReusableCell];
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"CPRecommendCell" owner:nil options:nil].lastObject;
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
                        CGFloat x = 0;
            
            CGFloat y = 84;
            if (iPhone4) {
                y = 44;
            }
            CGFloat w = ZYScreenWidth;
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
    }
    return _collectionView;
}


@end
