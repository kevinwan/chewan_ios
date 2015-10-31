//
//  CPChatGroupDetailViewController.m
//  CarPlay
//
//  Created by jiang on 15/10/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPChatGroupDetailViewController.h"

@interface CPChatGroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate,GroupDetailDelegeta>
{
    NSInteger _limit;
    NSInteger _ignore;
    NSArray *idleImages;
    NSArray *pullingImages;
    NSArray *refreshingImages;
    MJRefreshGifHeader *header;
    MJRefreshAutoGifFooter *footer;
}
@property (nonatomic, strong)UITableView *membersTableview;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation CPChatGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _limit = 10;
    _ignore   = 0;
    self.view.backgroundColor = GrayColor;
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.dataSource = [[NSMutableArray alloc]init];
    self.title = @"成员";
    [self initTableview];
    [self initRefreshImages];
    [self MJ];

    
    [self showLoading];
    [self getDetailMembersData];
    
 
    
    
}
- (void)MJ
{
    
    //头
    header= [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDetailMembersData)];
    // 设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages duration:0.5 forState:MJRefreshStateRefreshing];
    // 设置header
    self.membersTableview.header = header;
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
    self.membersTableview.footer = footer;
    
}
- (void)loadMoreData
{
    //如果回来的数据有零头，比如13条，那么认定没有数据了，不再发起请求。
    if (self.dataSource.count%20 != 0) {
        [footer endRefreshing];
        
        return;
    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"official/activity/%ld/members?userId=%@&token=%@&limit=20&ignore=0&idType=1",(long)[self.groupID integerValue],CPUserId,CPToken];
    [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self disMiss];
        [footer endRefreshing];
        
        if ([[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue] == 0) {
            NSLog(@"res = %@",responseObject);
            NSArray *arr   =[[responseObject objectForKey:@"data"] objectForKey:@"members"];
            if (arr.count>0) {
                [self.dataSource addObjectsFromArray:arr];
                [_membersTableview reloadData];

            }

        }else{
            [self showInfo:@"加载失败"];
            
            
        }
        
    } failure:^(NSError *error) {
        [footer endRefreshing];
        
        [self showInfo:@"加载失败"];
    }];
    
}
- (void)initRefreshImages
{
    //车轮的效果不好，可以换成切换图片的形式，明天跟UED商量。
    idleImages =[NSArray arrayWithObjects:[UIImage imageNamed:@"wheel0"], nil];
    pullingImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"wheel0"], nil];
    refreshingImages  = [NSArray arrayWithObjects:[UIImage imageNamed:@"wheel1"],[UIImage imageNamed:@"wheel2"],[UIImage imageNamed:@"wheel3"], [UIImage imageNamed:@"wheel4"],[UIImage imageNamed:@"wheel5"],[UIImage imageNamed:@"wheel6"],[UIImage imageNamed:@"wheel7"],[UIImage imageNamed:@"wheel8"],[UIImage imageNamed:@"wheel9"],[UIImage imageNamed:@"wheel10"],[UIImage imageNamed:@"wheel11"],[UIImage imageNamed:@"wheel12"],[UIImage imageNamed:@"wheel13"],nil];
    
}

- (void)getDetailMembersData
{
    NSString *urlStr = [NSString stringWithFormat:@"official/activity/%ld/members?userId=%@&token=%@&limit=20&ignore=0&idType=1",(long)[self.groupID integerValue],CPUserId,CPToken];
    [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self disMiss];
        [header endRefreshing];

        if ([[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue] == 0) {
            NSLog(@"res = %@",responseObject);
            [self.dataSource removeAllObjects];
            self.dataSource =[NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"members"]];
            [_membersTableview reloadData];
        }else{
            [self showInfo:@"加载失败"];
            

        }
       
    } failure:^(NSError *error) {
        [header endRefreshing];

        [self showInfo:@"加载失败"];
    }];
}

- (void)initTableview
{
    self.membersTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10) style:UITableViewStylePlain];
    _membersTableview.delegate = self;
    _membersTableview.dataSource  = self;

    [_membersTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_membersTableview];
    
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
    CPGroupDetailTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[CPGroupDetailTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (indexPath.row<self.dataSource.count) {
        NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
        [cell.headIV zySetImageWithUrl:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        cell.nameLabel.text = [dic objectForKey:@"nickname"];
        cell.sexView.age = [[dic objectForKey:@"age"] integerValue];
        cell.sexView.gender = [dic objectForKey:@"gender"];
        cell.distanceLabel.text =[self getDidstanceStrWithDistance:[[dic objectForKey:@"distance"] integerValue]];
        switch ([[dic objectForKey:@"inviteStatus"] integerValue ]) {
            case 0:
                [cell.inviteBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
                break;
            case 1:
                [cell.inviteBtn setTitle:@"邀请中" forState:UIControlStateNormal];
                break;
            case 2:
                cell.inviteBtn.hidden = YES;
                cell.SendMessageBtn.hidden = NO;
                cell.TelBtn.hidden  = NO;
                break;
            case 3:
                [cell.inviteBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                cell.inviteBtn.backgroundColor = UIColorFromRGB(0x999999);
                break;
                
            default:
                break;
        }
        //        cell.timeLabel.text =[NSDate formattedTimeFromTimeInterval:[[dic objectForKey:@"subscribeTime"] longLongValue]];;
        
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
    
    
}

- (void)groupDetailButton:(UIButton *)button
{
//    1.邀请同去，2，信息，3，电话
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [_membersTableview indexPathForCell:cell];
    NSLog(@"---%d",indexPath.row);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
