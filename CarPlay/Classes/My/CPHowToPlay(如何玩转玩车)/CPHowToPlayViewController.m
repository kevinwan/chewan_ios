//
//  CPHowToPlayViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/28.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPHowToPlayViewController.h"
#import "CPHowtoPlayCell.h"
#import "CPHowToPlayInfoViewController.h"

@interface CPHowToPlayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;
    NSArray *infoArray;
}
@end

@implementation CPHowToPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray=[[NSArray alloc]initWithObjects:@"1.发表活动指南",@"2.车主认证申请",@"3.活动规则",@"4.活动发起权限",@"5.车玩举报指南",@"6.车玩举报入口", nil];
    infoArray=[[NSArray alloc]initWithObjects:@"车玩是所有车友互助交流的公共平台，我们来自不同的城市，成长在不同的年代，喜爱不同的文化。在车玩，都应本着善意的态度参与讨论交流。\n\n首先，车玩对以下发帖内容严惩不贷。视情况予以移帖、删帖、关小黑屋、封号、封设备等处理。\n\n1.骚扰、辱骂、歧视等不尊重其他车友的行为；\n2.重复提交低质、同质内容的刷帖行为；\n3.软文、广告、微商；\n4.小黄文、小黄图，除车模外以女性身体为主题的图片；\n5.其他会引起车友不适或违反国家法律法规的内容。\n\n其次，车玩鼓励原创，请车友尊重各车玩会的主题。与各车玩会主题无关的非原创帖，将视内容移往各会闲聊区。\n\n管理员和车玩会会长不定时对帖子进行维护操作，如有疑义，请及时联系沟通。",@"认证标识\n认证车主头像上会显示车型标志图标，认证车主可以点亮爱车车标\n\n车主特权\n认证车主发布活动可以更容易吸引别人的参加，认证车主以后更容易吸引别人注意\n\n更多特权\n后续版本将不断增加认证车主特权\n\n",@"活动分车友活动和车玩会活动；\n所有用户都可以发起车友活动，每个用户最多只能发起三个未过期的活动，未指定活动时间的活动，将在15天后自动结束；\n\n车主和非车主都可以发布活动；\n活动发起者拥有活动管理权限；\n所有用户可以参加最多3个未过期的活动，过期的活动无法参加；\n\n活动参与者自动加入群聊，该群组聊天活动结束后60天后过期。",@"发起活动\n每个用户最多只能发起三个未过期的活动\n\n编辑活动\n活动开始和结束时间， 活动地点，标题，添加删除图片\n\n邀请车友\n车主可以邀请微信好友参与\n\n管理活动及群聊\n可以删除未开始的活动；移除活动和群聊的参与者",@"随着车玩的规模的壮大，车玩开始出现不少垃圾信息，并有爆发式增长的趋势，严重影响了大伙儿的使用和社区的发展。\n\n垃圾信息是指：以盈利为目的，发布影响用户体验、扰乱车玩秩序的信息的行为。过去1年多，车玩上出现了“找小姐”、“刷淘宝”、“卖动作片”、“微商”等多种垃圾信息。\n\n感谢通过举报、私信等各种形式帮助我们的车友，举报可以让垃圾信息更快的处理，直接减少其他车友被骚扰的情况。\n",@"车友个人主页右上角（针对使用不良信息作为头像的行为）;\n\n活动“举报”按钮（针对公开发布垃圾信息的行为）群聊及私聊状态，长按聊天内容，会弹出“举报”按钮（针对私下发布垃圾信息的行为）;\n\n同时，我们诚挚期待有更多车友加入车玩反垃圾小组，帮助我们做的更好", nil];
    self.tableView.bounces=NO;
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"CPHowtoPlayCell";
    CPHowtoPlayCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPHowtoPlayCell" owner:nil options:nil] lastObject];
    }
    cell.titleLable.text=[dataArray objectAtIndex:indexPath.row];
    [cell.titleLable setTextColor:[Tools getColor:@"434a54"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPHowToPlayInfoViewController *CPHowToPlayInfoVC=[[CPHowToPlayInfoViewController alloc]init];
    CPHowToPlayInfoVC.title=[dataArray objectAtIndex:indexPath.row];
    CPHowToPlayInfoVC.content=[infoArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:CPHowToPlayInfoVC animated:YES];
}

@end
