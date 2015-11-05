//
//  CPChatGroupDetailViewController.m
//  CarPlay
//
//  Created by jiang on 15/10/30.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPChatGroupDetailViewController.h"
#import "CPComeOnTipView.h"
#import "ChatViewController.h"
#import "CPRecommendModel.h"
#import "CPMySwitch.h"
#import "CPTaInfo.h"
@interface CPChatGroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate,GroupDetailDelegeta>
{
    NSInteger _limit;
    NSInteger _ignore;
    NSArray *idleImages;
    NSArray *pullingImages;
    NSArray *refreshingImages;
//    MJRefreshGifHeader *header;
    MJRefreshAutoGifFooter *footer;
}
@property (nonatomic, strong)UITableView *membersTableview;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)NSString *officialActivityId;

//记录邀请对方同去的index，如果邀请成功，把本地数据的“邀请同去”换成“邀请中”
@property (nonatomic,assign)NSInteger inviteIndex;
//用来判断，此群的群信息是否被屏蔽了
@property (nonatomic,assign)BOOL isBlocked;
@property (nonatomic,strong)CPMySwitch *myswitch;
@property (nonatomic,strong)UIView * bgview;//tableHeaderView

@end

@implementation CPChatGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:self.groupID completion:^(EMGroup *group, EMError *error) {
        self.isBlocked = group.isBlocked;
        _myswitch.on = self.isBlocked;
    } onQueue:dispatch_get_main_queue()];
    
    _limit = 10;
    _ignore   = 0;
    _inviteIndex = -1;
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.dataSource = [[NSMutableArray alloc]init];
    self.title = @"成员";
    [self initTableview];
    [self initRefreshImages];
    [self MJ];

    
    [self showLoading];
    [self getDetailMembersData];
    
    [ZYNotificationCenter addObserver:self selector:@selector(inviteSuccess) name:CPInvitedSuccessKey object:nil];
    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)MJ
{
    
    //头
//    header= [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDetailMembersData)];
//    // 设置普通状态的动画图片
//    [header setImages:idleImages forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [header setImages:pullingImages forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [header setImages:refreshingImages duration:0.5 forState:MJRefreshStateRefreshing];
//    // 设置header
//    self.membersTableview.header = header;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
    
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

        if ([[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue] == 0) {
            NSLog(@"res = %@",responseObject);
            [self.dataSource removeAllObjects];
            self.title  = [NSString stringWithFormat:@"成员(%ld人)",[[[responseObject objectForKey:@"data"] objectForKey:@"memberSize"] integerValue]];
            self.dataSource =[NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"members"]];
            self.officialActivityId = [[responseObject objectForKey:@"data"] objectForKey:@"officialActivityId"];
            [_membersTableview reloadData];
        }else{
            [self showInfo:@"加载失败"];
            

        }
       
    } failure:^(NSError *error) {


        [self showInfo:@"加载失败"];
    }];
}

- (void)initTableview
{
    self.membersTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-10) style:UITableViewStyleGrouped];
    _membersTableview.delegate = self;
    _membersTableview.dataSource  = self;
    [_membersTableview setBackgroundColor:UIColorFromRGB(0xefefef)];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.bgview == nil) {
        self.bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 54)];
        _bgview.backgroundColor = UIColorFromRGB(0xefefef);
        
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
        cellView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 120, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = @"消息免打扰";
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setFont:[UIFont systemFontOfSize:17]];
        [label setTextColor:UIColorFromRGB(0x333333)];
        [cellView addSubview:label];
        
        self.myswitch=  [[CPMySwitch alloc]initWithFrame:CGRectMake(kDeviceWidth-15-52, 12, 54, 22)];
        [_myswitch setOnImage:[UIImage imageNamed:@"nodistrube"]];
        [_myswitch setOffImage:[UIImage imageNamed:@"nodistrube_gray"]];
        [_myswitch addTarget:self action:@selector(noDistrube:) forControlEvents:UIControlEventTouchUpInside];
        _myswitch.on = self.isBlocked;
        [cellView addSubview:_myswitch];
        
        [_bgview addSubview:cellView];
    }
    
    return _bgview;
}
- (void)noDistrube:(CPMySwitch *)sender
{
    
    if (sender.on == YES) {
        NSLog(@"关掉");
       [[EaseMob sharedInstance].chatManager asyncUnblockGroup:self.groupID completion:^(EMGroup *group, EMError *error) {
           if (error) {
               [self showInfo:@"网络出错，请稍后重试"];
               return ;
           }
       } onQueue:nil];
        
    }else{
        NSLog(@"开启免打扰");
        [[EaseMob sharedInstance].chatManager asyncBlockGroup:self.groupID completion:^(EMGroup *group, EMError *error) {
            if (error) {
                [self showInfo:@"网络出错，请稍后重试"];
                return ;
            }
        } onQueue:nil];

    }
    sender.on = !sender.on;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
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
        [cell.inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        /*
         inviteStatus        当前登录用户 邀请 该用户的 状态；
         0 没有邀请过           1 邀请中
         2 邀请同意             3 邀请被拒绝
         beInvitedStatus      该用户是否邀请过 登录用户
         0 没有邀请过           1 邀请中
         2 邀请同意             3 邀请被拒绝
         */
        //双方有任何有个是2，就显示聊天，否则再去判断
        if ([[dic objectForKey:@"inviteStatus"] integerValue ] == 2 || [[dic objectForKey:@"beInvitedStatus"] integerValue ] ==2) {
            cell.inviteBtn.hidden = YES;
            cell.SendMessageBtn.hidden = NO;
            cell.TelBtn.hidden  = NO;
        }else{
            switch ([[dic objectForKey:@"inviteStatus"] integerValue ]) {
                case 0:
                {//inviteStatus如果是0，就看beInvitedStatus的值。
                    switch ([[dic objectForKey:@"beInvitedStatus"] integerValue ]) {
                        case 0:
                            [cell.inviteBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
                            cell.inviteBtn.backgroundColor = UIColorFromRGB(0x74ced6);
                            break;
                        case 1:
                            //这个时候点击按钮的话，提示去动态处理
                            [cell.inviteBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
                            cell.inviteBtn.backgroundColor = UIColorFromRGB(0x74ced6);
                            break;
                            
                        case 2:
                            cell.inviteBtn.hidden = YES;
                            cell.SendMessageBtn.hidden = NO;
                            cell.TelBtn.hidden  = NO;
                            break;
                            
                        case 3:
                            [cell.inviteBtn setTitle:@"邀请同去" forState:UIControlStateNormal];
                            cell.inviteBtn.backgroundColor = UIColorFromRGB(0x74ced6);
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                    break;
                case 1:
                    [cell.inviteBtn setTitle:@"邀请中" forState:UIControlStateNormal];
                    cell.inviteBtn.backgroundColor = UIColorFromRGB(0x74ced6);
                    
                    break;
                case 2:
                    cell.inviteBtn.hidden = YES;
                    cell.SendMessageBtn.hidden = NO;
                    cell.TelBtn.hidden  = NO;
                    break;
                case 3:
                    [cell.inviteBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                    cell.inviteBtn.backgroundColor = [UIColor clearColor];
                    [cell.inviteBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
        }
        
        
        if ([[dic objectForKey:@"userId"] isEqualToString:CPUserId]) {
            cell.inviteBtn.hidden =YES;
            cell.SendMessageBtn.hidden = YES;
            cell.TelBtn.hidden = YES;
        }
        
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

- (void)groupDetailButton:(UIButton *)button
{
//    1.邀请同去，2，信息，3，电话
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [_membersTableview indexPathForCell:cell];
    NSLog(@"---%d",indexPath.row);
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    switch (button.tag) {
        case 1:
        {
            if ([[dic objectForKey:@"beInvitedStatus"] integerValue ] == 1) {
                [self showInfo:[NSString stringWithFormat:@"%@已邀请你，去活动动态里处理邀请",[dic objectForKey:@"nickname"]]];
            }else if([button.titleLabel.text isEqualToString:@"邀请同去"]){
                NSLog(@"可以了");
                CPPartMember *model = [[CPPartMember alloc]init];
                model.userId =[dic objectForKey:@"userId"];
                self.inviteIndex = indexPath.row;
                [CPComeOnTipView showWithActivityId:self.officialActivityId partMemberModel:model];
            }
        }
            break;
        case 2:
        {
            ChatViewController *ChatVc = [[ChatViewController alloc]initWithChatter:[Tools md5EncryptWithString:[dic objectForKey:@"userId"]] conversationType:eConversationTypeChat];
            ChatVc.title = [dic objectForKey:@"nickname"];
            [self.navigationController pushViewController:ChatVc animated:YES];
        }
            break;
        case 3:
        {
            [ZYUserDefaults setValue:[dic objectForKey:@"avatar"] forKey:kReceiverHeadUrl];
            [ZYUserDefaults setValue:[dic objectForKey:@"nickname"] forKey:kReceiverNickName];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":[Tools md5EncryptWithString:[dic objectForKey:@"userId"]], @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)inviteSuccess
{
    if (self.inviteIndex>=0) {
        NSMutableDictionary *dic = [self.dataSource objectAtIndex:self.inviteIndex];
        [dic setObject:@"1" forKey:@"inviteStatus"];
        [self.membersTableview reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
