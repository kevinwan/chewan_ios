//
//  CPMatchingPreview.m
//  CarPlay
//
//  Created by 公平价 on 15/11/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMatchingPreview.h"
#import "CPNearCollectionViewCell.h"
#import "CPTaInfo.h"


@interface CPMatchingPreview ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, assign) CGFloat offset;
@end

static NSString *ID = @"cell";

@implementation CPMatchingPreview

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    [self.view addSubview:self.tableView];
    [self.navigationItem setTitle:@"匹配活动预览"];
     [self setRightNavigationBarItemWithTitle:nil Image:@"share" highImage:@"share" target:self action:@selector(shareClick)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.view removeFromSuperview];
    [self.navigationController removeFromParentViewController];
}

- (UICollectionView *)tableView
{
    if (_tableView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 62, ZYScreenWidth - 20, 390+self.offset) collectionViewLayout:layout];
        _tableView.centerX = self.view.middleX;
        _tableView.centerY = self.view.middleY;
        _tableView.alwaysBounceVertical = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        CGSize itemSzie= CGSizeMake(ZYScreenWidth - 20, 390 + self.offset);
        layout.itemSize = itemSzie;
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        self.view.backgroundColor =  [Tools getColor:@"f7f7f7"];
        [_tableView registerClass:[CPNearCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _tableView.panGestureRecognizer.delaysTouchesBegan = _tableView.delaysContentTouches;
        
    }
    return _tableView;
}

#pragma mark - UICollectionViewDelegate &dataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPNearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.contentV.indexPath = indexPath;
    cell.contentV.model = _activity;
//    [cell.contentV.dateButton setHidden:YES];
//    [cell.contentV.dateAnim setHidden:YES];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
}

//匹配并分享
-(void)shareClick{
    
}
@end
