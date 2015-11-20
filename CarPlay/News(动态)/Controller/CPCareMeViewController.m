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
#import "CPTaInfo.h"
@interface CPCareMeViewController ()<careBtnClickdelegete>
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
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    self.title = @"谁关注我";
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self initTableview];
    [self initRefreshImages];
    [self getCareMeData];
    [self MJ];
    
}
- (void)initRefreshImages
{
    //车轮的效果不好，可以换成切换图片的形式，明天跟UED商量。
    idleImages =[NSArray arrayWithObjects:[UIImage imageNamed:@"wheel0"], nil];
    pullingImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"wheel0"], nil];
    refreshingImages  = [NSArray arrayWithObjects:[UIImage imageNamed:@"wheel1"],[UIImage imageNamed:@"wheel2"],[UIImage imageNamed:@"wheel3"], [UIImage imageNamed:@"wheel4"],[UIImage imageNamed:@"wheel5"],[UIImage imageNamed:@"wheel6"],[UIImage imageNamed:@"wheel7"],[UIImage imageNamed:@"wheel8"],[UIImage imageNamed:@"wheel9"],[UIImage imageNamed:@"wheel10"],[UIImage imageNamed:@"wheel11"],[UIImage imageNamed:@"wheel12"],[UIImage imageNamed:@"wheel13"],nil];

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
    self.careMeTableview.header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    //尾巴
//    footer= [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    // 设置刷新图片
//    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
//    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
//    [footer setImages:refreshingImages forState:MJRefreshStateWillRefresh];
//    [footer setImages:idleImages forState:MJRefreshStateIdle];
//    footer.stateLabel.hidden = YES;
//    //使图片居中
//    footer.refreshingTitleHidden = YES;
//    // 设置尾部
//    self.careMeTableview.footer = footer;

}
- (void)loadNewData
{
    
    NSLog(@"上啦加载了");
    [ZYNetWorkTool getWithUrl:[NSString stringWithFormat:@"user/%@/subscribe/history?token=%@",CPUserId,CPToken] params:nil success:^(id responseObject) {
        [self disMiss];
        [header endRefreshing];

        if (CPSuccess) {
            self.dataSource = [responseObject objectForKey:@"data"];
            [_careMeTableview reloadData];
        }
    } failure:^(NSError *error) {
        [self disMiss];
        [header endRefreshing];

    }];
}
- (void)initTableview
{
    self.careMeTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,10, self.view.frame.size.width, self.view.frame.size.height-10-64) style:UITableViewStylePlain];
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
        cell.delegate = self;
    }
    if (indexPath.row<self.dataSource.count) {
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        
        [cell.headIV zySetImageWithUrl:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        cell.nameLabel.text = [dic objectForKey:@"nickname"];
        cell.sexView.age = [[dic objectForKey:@"age"] integerValue];
        cell.sexView.gender = [dic objectForKey:@"gender"];
//        subscribeFlag  相互关注信息 true表示我关注了该用户，false表示没有关注
        cell.careBtn.tag = indexPath.row;
        if ([[dic objectForKey:@"subscribeFlag"] boolValue]) {
            [cell.careBtn setImage:[UIImage imageNamed:@"互相关注"] forState:UIControlStateNormal];

        }else{
            [cell.careBtn setImage:[UIImage imageNamed:@"关注我的"] forState:UIControlStateNormal];
        }
        
        cell.timeAndDistanceLabel.text = [NSString stringWithFormat:@"%@ | %@",[NSDate formattedTimeFromTimeInterval:[[dic objectForKey:@"subscribeTime"] longLongValue]],[self getDidstanceStrWithDistance:[[dic objectForKey:@"distance"] integerValue]]];
        if ([[dic objectForKey:@"photoAuthStatus"] isEqualToString:@"认证通过"]) {
            cell.phohtAuthIV.hidden = NO;
        }else{
            cell.phohtAuthIV.hidden = YES;
        }
        
        if ([[dic objectForKey:@"licenseAuthStatus"] isEqualToString:@"认证通过"]) {
            cell.carAuthIV.hidden = NO;
            [cell.carAuthIV zySetImageWithUrl:[[dic objectForKey:@"car"] objectForKey:@"logo"] placeholderImage:nil];
        }else{
            cell.carAuthIV.hidden = YES;
        }

        
    }
    
    return cell;
}
- (NSString *)getDidstanceStrWithDistance:(NSInteger )distance
{
    if (distance<1000) {
        return [NSString stringWithFormat:@"%ldm",(long)distance];
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
#pragma mark 关注按钮的点击
- (void)careBtnClicked:(UIButton *)button
{
    NSDictionary *dic = [self.dataSource objectAtIndex:button.tag];
    if ([[dic objectForKey:@"subscribeFlag"] boolValue]) {
        //如果相互关注的，就取消关注
        [self showLoading];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObject:[dic objectForKey:@"userId"] forKey:@"targetUserId"];
        [ZYNetWorkTool postJsonWithUrl:[NSString stringWithFormat:@"user/%@/unlisten?token=%@",CPUserId,CPToken] params:paramsDic success:^(id responseObject) {
            [self disMiss];
            if (CPSuccess) {
                [button setImage:[UIImage imageNamed:@"关注我的"] forState:UIControlStateNormal];
                [dic setValue:@"0" forKey:@"subscribeFlag"];
            }
        } failed:^(NSError *error) {
            [self disMiss];
            NSLog(@"error = %@",error);
        }];

    }else{
        //我为观众对方的，发请求去关注对方
        [self showLoading];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObject:[dic objectForKey:@"userId"] forKey:@"targetUserId"];

        [ZYNetWorkTool postJsonWithUrl:[NSString stringWithFormat:@"user/%@/listen?token=%@",CPUserId,CPToken] params:paramsDic success:^(id responseObject) {
            [self disMiss];
            if (CPSuccess) {
                [button setImage:[UIImage imageNamed:@"互相关注"] forState:UIControlStateNormal];
                [dic setValue:@"1" forKey:@"subscribeFlag"];

            }
        } failed:^(NSError *error) {
            [self disMiss];
            NSLog(@"error = %@",error);

        }];
    }
    
}


@end
