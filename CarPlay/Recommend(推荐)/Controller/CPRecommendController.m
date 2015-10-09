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

@interface CPRecommendController ()<PagedFlowViewDelegate, PagedFlowViewDataSource>
@property (nonatomic, strong) PagedFlowView *collectionView;
@end

@implementation CPRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
}

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if ([notifyName isEqualToString:RecommentAddressClickKey]) {
        NSLog(@"国家体育馆");
    }
}

- (PagedFlowView *)collectionView
{
    if (_collectionView == nil) {
//        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = 0;
//        layout.sectionInset = UIEdgeInsetsZero;
//        layout.itemSize = CGSizeMake(ZYScreenWidth - 40, 405 + ZYScreenWidth - 320);
//        ;
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat offset = (ZYScreenWidth - 320);
        _collectionView = [[PagedFlowView alloc] initWithFrame:({
                        CGFloat x = 0;
            
            CGFloat y = 84;
            if (iPhone4) {
                y = 64;
            }
                        CGFloat w = ZYScreenWidth;
                        CGFloat h = offset + 420;
                        CGRect frame = CGRectMake(x, y, w, h);
                        frame;
                    })];
        _collectionView.orientation = PagedFlowViewOrientationHorizontal;
//        _collectionView = [[PagedFlowView alloc] initWithFrame:({
//            CGFloat x = 40;
//            CGFloat y = 84;
//            CGFloat w = ZYScreenWidth - 80;
//            CGFloat h = ZYScreenHeight - 64 - 49 - 48;
//            CGRect frame = CGRectMake(x, y, w, h);
//            frame;
//        }) collectionViewLayout:layout];
//        _collectionView.clipsToBounds = NO;
//        _collectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 0);
//        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.minimumPageScale = 0.9;
//        [_collectionView registerNib:[UINib nibWithNibName:@"CPRecommendCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
        self.view.backgroundColor = [Tools getColor:@"efefef"];
//        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

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

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(ZYScreenWidth - 36,ZYScreenWidth + 100);
}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
//    [cell setCornerRadius:10];
//    return cell;
//}

@end
