//
//  CPRecommendController.m
//  CarPlay
//
//  Created by chewan on 10/8/15.
//  Copyright © 2015 chewan. All rights reserved.
//  推荐活动

#import "CPRecommendController.h"
#import "CPRecommendCell.h"

@interface CPRecommendController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation CPRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if ([notifyName isEqualToString:RecommentAddressClickKey]) {
        NSLog(@"国家体育馆");
    }
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 40;
        layout.itemSize = CGSizeMake(ZYScreenWidth - 50, 405 + ZYScreenWidth - 320);
        ;
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"CPRecommendCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
        _collectionView.backgroundColor = [Tools getColor:@"efefef"];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    [cell setCornerRadius:10];
    return cell;
}

@end
