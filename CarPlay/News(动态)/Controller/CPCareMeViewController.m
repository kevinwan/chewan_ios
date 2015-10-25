//
//  CPCareMeViewController.m
//  CarPlay
//
//  Created by jiang on 15/10/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPCareMeViewController.h"
#import "CareMeTableViewCell.h"
#import "NSDate+Category.h"

@interface CPCareMeViewController ()
{
    NSArray *idleImages;
    NSArray *pullingImages;
    NSArray *refreshingImages;
    MJRefreshGifHeader *header;
    MJRefreshAutoGifFooter *footer;
}
@property (nonatomic, strong)UITableView *careMeTableview;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation CPCareMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GrayColor;
    self.title = @"谁关注我";
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self initTableview];
    [self getCareMeData];
    [self MJ];
    
}
- (void)MJ
{//车轮的效果不好，可以换成切换图片的形式，明天跟UED商量。
    idleImages =[NSArray arrayWithObjects:[UIImage imageNamed:@"车轮"], nil];
    pullingImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"call_tou_h"], nil];
    refreshingImages  = [NSArray arrayWithObjects:[UIImage imageNamed:@"call_silence_h"], nil];
    
    //头
    header= [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages duration:2 forState:MJRefreshStateRefreshing];
    // 设置header
    self.careMeTableview.header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    //尾巴
    footer= [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置刷新图片
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
    [footer setImages:refreshingImages forState:MJRefreshStateWillRefresh];
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    footer.stateLabel.hidden = YES;
    //使图片居中
    footer.refreshingTitleHidden = YES;
    // 设置尾部
    self.careMeTableview.footer = footer;

}
- (void)loadNewData
{
    NSLog(@"-=-=-=-=-=加载了");
}
- (void)loadMoreData
{
    NSLog(@"上啦加载了");
}
- (void)initTableview
{
    self.careMeTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,10, self.view.frame.size.width, self.view.frame.size.height-10) style:UITableViewStylePlain];
    _careMeTableview.delegate = self;
    
    _careMeTableview.tableFooterView = [[UIView alloc]init];
    _careMeTableview.backgroundColor = [UIColor whiteColor];
    _careMeTableview.dataSource  = self;
    [_careMeTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_careMeTableview];

}
- (void)getCareMeData
{
    [self showLoading];

    [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/%@/subscribe/history?token=%@",CPUserId,CPToken] params:nil success:^(id responseObject) {
        [self disMiss];
        if (CPSuccess) {
            self.dataSource = [responseObject objectForKey:@"data"];
            [_careMeTableview reloadData];
        }
    } failure:^(NSError *error) {
        [self disMiss];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CareMeCell";
    CareMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[CareMeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.row<self.dataSource.count) {
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        [cell.headIV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        cell.nameLabel.text = [dic objectForKey:@"nickname"];
        cell.sexView.age = [[dic objectForKey:@"age"] integerValue];
        cell.sexView.gender = [dic objectForKey:@"gender"];
        cell.distanceLabel.text =[self getDidstanceStrWithDistance:[[dic objectForKey:@"distance"] integerValue]];
        
        
        cell.timeLabel.text =[NSDate formattedTimeFromTimeInterval:[[dic objectForKey:@"subscribeTime"] longLongValue]];;

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
    NSLog(@"row = %d",indexPath.row);
    [header endRefreshing];
    [footer endRefreshing];
}
@end
