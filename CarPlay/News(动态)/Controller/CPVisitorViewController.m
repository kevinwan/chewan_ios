//
//  CPVisitorViewController.m
//  CarPlay
//
//  Created by jiang on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPVisitorViewController.h"
#import "CPVisitorTableViewCell.h"
#import "NSDate+Category.h"
#import "CPTaInfo.h"
@interface CPVisitorViewController ()
{
    NSInteger _limit;
    NSInteger _ignore;
    NSArray *idleImages;
    NSArray *pullingImages;
    NSArray *refreshingImages;
    MJRefreshGifHeader *header;
    MJRefreshAutoGifFooter *footer;

}
@property (nonatomic, strong)UITableView *visitorTableview;
@property (nonatomic, strong)NSMutableArray *dataSource;


@end

@implementation CPVisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _limit = 20;
    _ignore = 0;
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.title = @"最近访客";
    [self initTableview];
    [self initRefreshImages];
    [self getVisitMeData];
    [self MJ];

}
- (void)MJ
{
    
    //头
    header= [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages duration:0.5 forState:MJRefreshStateRefreshing];
    // 设置header
    self.visitorTableview.header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    //尾巴
        footer= [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 设置刷新图片
        [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    [footer setImages:refreshingImages duration:0.5 forState:MJRefreshStateRefreshing];
        [footer setImages:refreshingImages forState:MJRefreshStatePulling];

        [footer setImages:idleImages forState:MJRefreshStateIdle];
        footer.stateLabel.hidden = YES;
        //使图片居中
        footer.refreshingTitleHidden = YES;
        // 设置尾部
        self.visitorTableview.footer = footer;
    
}
- (void)loadMoreData
{
    //如果回来的数据有零头，比如13条，那么认定没有数据了，不再发起请求。
    if (self.dataSource.count%20 != 0) {
        [footer endRefreshing];

        return;
    }
    [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/%@/view/history?token=%@&limit=%ld&ignore=%ld",CPUserId,CPToken,(long)_limit,self.dataSource.count] params:nil success:^(id responseObject) {
        [self disMiss];
        [footer endRefreshing];

        if (CPSuccess) {
            NSArray *arr =  [responseObject objectForKey:@"data"];
            if (arr.count>0) {
                [self.dataSource addObjectsFromArray: [responseObject objectForKey:@"data"]];
                [_visitorTableview reloadData];

            }
        }
    } failure:^(NSError *error) {
        [self disMiss];
        [footer endRefreshing];

    }];
    
}
- (void)loadNewData
{
    [self getVisitMeData];
}
- (void)getVisitMeData
{
    [self showLoading];
    [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/%@/view/history?token=%@&limit=20&ignore=0",CPUserId,CPToken] params:nil success:^(id responseObject) {
        [header endRefreshing];
        [self disMiss];
        if (CPSuccess) {
            [self.dataSource removeAllObjects];
            self.dataSource =[NSMutableArray arrayWithArray: [responseObject objectForKey:@"data"]];
            [_visitorTableview reloadData];
        }
    } failure:^(NSError *error) {
        [self disMiss];
        [header endRefreshing];

    }];

}
- (void)initRefreshImages
{
    //车轮的效果不好，可以换成切换图片的形式，明天跟UED商量。
    idleImages =[NSArray arrayWithObjects:[UIImage imageNamed:@"wheel0"], nil];
    pullingImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"wheel0"], nil];
    refreshingImages  = [NSArray arrayWithObjects:[UIImage imageNamed:@"wheel1"],[UIImage imageNamed:@"wheel2"],[UIImage imageNamed:@"wheel3"], [UIImage imageNamed:@"wheel4"],[UIImage imageNamed:@"wheel5"],[UIImage imageNamed:@"wheel6"],[UIImage imageNamed:@"wheel7"],[UIImage imageNamed:@"wheel8"],[UIImage imageNamed:@"wheel9"],[UIImage imageNamed:@"wheel10"],[UIImage imageNamed:@"wheel11"],[UIImage imageNamed:@"wheel12"],[UIImage imageNamed:@"wheel13"],nil];
    
}

- (void)initTableview
{
    self.visitorTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10) style:UITableViewStylePlain];
    _visitorTableview.delegate = self;
    _visitorTableview.dataSource  = self;
    [_visitorTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_visitorTableview];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CareMeCell";
    CPVisitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[CPVisitorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.row<self.dataSource.count) {
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        [cell.headIV zySetImageWithUrl:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        cell.nameLabel.text = [dic objectForKey:@"nickname"];
        cell.messageLabel.text = @"看过我";
        cell.sexView.age = [[dic objectForKey:@"age"] integerValue];
        cell.sexView.gender = [dic objectForKey:@"gender"];
        cell.distanceLabel.text =[self getDidstanceStrWithDistance:[[dic objectForKey:@"distance"] integerValue]];
        
        
        cell.timeLabel.text =[NSDate formattedTimeFromTimeInterval:[[dic objectForKey:@"viewTime"] longLongValue]];;
        
    }
    
    return cell;
}
- (NSString *)getDidstanceStrWithDistance:(NSInteger )distance
{
    if (distance<1000) {
        return [NSString stringWithFormat:@"%ld米",(long)distance];
    }else{
        return [NSString stringWithFormat:@"%.fkm",distance/1000.0];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    
    CPTaInfo *taVc = [UIStoryboard storyboardWithName:@"TaInfo" bundle:nil].instantiateInitialViewController;
    taVc.userId =[dic objectForKey:@"userId"];
    [self.navigationController pushViewController:taVc animated:YES];


}

@end
