//
//  CPTakeALookResultController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPTakeALookResultController.h"
#import "CPNearCollectionViewCell.h"
#import "CPTaInfo.h"

@interface CPTakeALookResultController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *tableView;
@property (nonatomic, assign) CGFloat offset;
@end

static NSString *ID = @"cell";
@implementation CPTakeALookResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offset = (ZYScreenWidth - 20) * 5.0 / 6.0 - 250;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionView *)tableView
{
    if (_tableView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
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
//        layout.itemScale = 1;
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        self.view.backgroundColor = [Tools getColor:@"efefef"];
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
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (void)superViewWillRecive:(NSString *)notifyName info:(id)userInfo
{
    if([notifyName isEqualToString:DateBtnClickKey]){
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
//    ZYAsyncThead(^{
//        
//        NSMutableArray *indexPaths = [NSMutableArray array];
//        
//        for (int i = 0;i < self.datas.count; i++) {
//            CPActivityModel *obj = self.datas[i];
//            if ([obj.organizer.userId isEqualToString:model.organizer.userId] && ![obj.activityId isEqualToString:model.activityId]) {
//                obj.organizer.subscribeFlag = model.organizer.subscribeFlag;
//                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
//            }
//            
//        }
//        ZYMainThread(^{
//            [self.tableView reloadItemsAtIndexPaths:indexPaths];
//        });
//        
//    });
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
    NSString *url = [NSString stringWithFormat:@"activity/%@/join",_activity.activityId];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"destPoint"] = @{@"longitude" : @(CPLongitude),
                             @"latitude" : @(CPLatitude)};
    params[@"transfer"] = @(_activity.transfer);
    params[@"type"] = _activity.type;
    params[@"pay"] = _activity.pay;
    params[@"destination"] = _activity.destination;
    params[UserId] = CPUserId;
    params[Token] = CPToken;
    [self showLoading];
    [CPNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        if (CPSuccess) {
            [self showInfo:@"邀请已发出"];
            _activity.applyFlag = 1;
            [self.tableView reloadItemsAtIndexPaths:@[indexPath]];
        }else if ([CPErrorMsg contains:@"申请中"]){
            [self showInfo:@"正在申请中"];
        }
    } failed:^(NSError *error) {
        [self showInfo:@"邀请失败"];
    }];
    
}


@end
