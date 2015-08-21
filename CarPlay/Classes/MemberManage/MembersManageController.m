//
//  ViewController.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/13.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//
#import "MembersManageController.h"
#import "AppAppearance.h"
#import "memberManageCell.h"
#import "carManageCell.h"
#import "UIView+Dealer.h"
#import "SMFoundation.h"
#import "ZYNetWorkTool.h"
#import "NSDictionary+Dealer.h"
#import "UIView+Dealer.h"
#import "members.h"
#import "cars.h"
#import "users.h"
#import <MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UMSocial.h"
#import "UMSocialData.h"
#import "CPTaDetailsController.h"
#import <SWTableViewCell.h>
#import <SWUtilityButtonView.h>
#import "NSMutableArray+CPUtilityButtons.h"
#import "CPModelButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "ChatViewController.h"



@interface MembersManageController () <UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *memberTableView;

@property (weak, nonatomic) IBOutlet UIButton *downButton;
//downSearXib
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *begainChatButton;
//遮盖
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) NSMutableArray *membersArray;
@property (nonatomic, strong) NSMutableArray *carsArray;
@property (nonatomic, assign) BOOL member;
@property (nonatomic, strong) NSString *tapUserID;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) UIButton *subButton;
@property (nonatomic, strong) NSString *chatGroupId;
@end

@implementation MembersManageController
- (void)viewDidLoad {
    [super viewDidLoad];
    [CPGuideView showGuideViewWithImageName:@"memberGuide"];
    UIFont *font = [UIFont systemFontOfSize:17];
     self.navigationItem.title = @"成员管理";
    [self setupFontAndColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"邀请" titleColor:[AppAppearance titleColor] font:font target:self action:@selector(inviteFriend)];
    [self setUpRefresh];
    [self.memberTableView.header beginRefreshing];
    self.memberTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

}
- (void)setUpRefresh {
    __weak typeof(self) weakSelf = self;
    self.memberTableView.header = [CPRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadMessage];
    }];
    self.memberTableView.footer = [CPRefreshFooter  footerWithRefreshingBlock:^{
        [weakSelf loadMessage];
    }];
    
}

//添加微信分享的语句
- (void)inviteFriend {
    UIImage *image = nil;
    NSData *dataUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]];
    if (dataUrl!=nil) {
        image = [[UIImage alloc]initWithData:dataUrl];
    }
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
    [UMSocialSnsService presentSnsIconSheetView:self appKey:nil shareText:self.shareContent shareImage:image shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ, nil] delegate:nil];
}

- (void) setupFontAndColor {
    self.memberTableView.separatorColor = [AppAppearance lineColor];
    [self.begainChatButton setTitle:@"开始畅聊" forState:UIControlStateNormal];
    [self.begainChatButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    [self.begainChatButton setBackgroundColor:[AppAppearance greenColor]];
    self.begainChatButton.layer.cornerRadius = 3;
    [self.begainChatButton clipsToBounds];

}

//加载成员信息和car信息
- (void)loadMessage {
    //示例参数@"http://cwapi.gongpingjia.com/v1"
        NSString *userId = [Tools getValueFromKey:@"userId"];
        if (userId.length == 0) {
            [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
            return;
        }
        self.userId = userId;
        NSString *token = [Tools getValueFromKey:@"token"];
        if (token.length == 0) {
            [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
            return;
        }
        self.token = token;
    [self.view showWait];
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/members?userId=%@&token=%@",self.activityId,self.userId,self.token];
    [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self.view hideWait];
        SQLog(@"%@",responseObject);
        if ([responseObject operationSuccess]) {
            NSArray *memberModel = [members objectArrayWithKeyValuesArray:responseObject[@"data"][@"members"]];
            NSArray *carModel = [cars objectArrayWithKeyValuesArray:responseObject[@"data"][@"cars"]];
            self.shareContent = responseObject[@"data"][@"shareContent"];
            self.shareTitle = responseObject[@"data"][@"shareTitle"];
            self.shareUrl = responseObject[@"data"][@"shareUrl"];
            self.imgUrl = responseObject[@"data"][@"imgUrl"];
            self.chatGroupId = responseObject[@"data"][@"chatGroupId"];
            self.activityTitle = responseObject[@"data"][@"title"];

            [self.membersArray removeAllObjects];
            [self.membersArray addObjectsFromArray:memberModel];
            [self.carsArray removeAllObjects];
            [self.carsArray addObjectsFromArray:carModel];
            [self.memberTableView.header endRefreshing];
            [self.memberTableView.footer endRefreshing];
            [self.memberTableView reloadData];
            
        } else {
            [self.view alertError:responseObject];
        }
    } failure:^(NSError *error) {
        [self.view alertError:error];
        [self.memberTableView.header endRefreshing];
        [self.memberTableView.footer endRefreshing];

    }];
    
    
}
//点击座位
- (IBAction)seatDIdClick:(UIButton *)sender {
    SQLog(@"%tu",sender.tag);
    if ([sender imageForState:UIControlStateNormal] == nil) {
        [self.view alert:@"该座位为空座"];
        return;
    }
    // 遮盖
    UIButton *cover = [[UIButton alloc] init];
    self.cover = cover;
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = [UIScreen mainScreen].bounds;
    [self.view.window addSubview:cover];
    UIView *carView = [[[NSBundle mainBundle]loadNibNamed:@"downSeat" owner:self options:nil]lastObject];
    CGFloat carViewX = self.view.window.center.x;
    CGFloat carViewY = self.view.window.center.y - 100;
    carView.center = CGPointMake(carViewX, carViewY);
    self.downButton.backgroundColor = [AppAppearance greenColor];
    [self.downButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    self.downButton.titleLabel.font = [AppAppearance titleFont];
    self.downButton.layer.cornerRadius = 3;
    [self.downButton clipsToBounds];
    self.carView = carView;
    self.nameLabel.font = [AppAppearance textLargeFont];
    self.nameLabel.textColor = [AppAppearance textDarkColor];
    [self.ageButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    self.ageButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.ageButton setBackgroundImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    self.ageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.ageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
    //获取座位的tag
    self.downButton.tag = sender.tag;
    //获取car
    cars *car = self.carsArray[sender.tag % 1000];
    NSString *seatIndex = nil;
    if (sender.tag <  2000) {
        seatIndex = @"0";
    }
    else if (sender.tag < 3000) {
        seatIndex = @"1";
    }
    else if (sender.tag < 4000) {
        seatIndex = @"2";
    }
    else if (sender.tag < 5000) {
        seatIndex = @"3";
    }
    SQLog(@"%@",seatIndex);
    NSArray *usersArray = car.users;
    users *tapUser = nil;
    for (users *user in usersArray) {
        if ([user.seatIndex isEqualToString:seatIndex]) {
            //通过seatIndex获取user
            tapUser = user;
            break;
        }
    }
    //获取点击人得userID
    self.tapUserID = tapUser.userId;
    [self.ageButton setTitle:tapUser.age forState:UIControlStateNormal];
    if ([tapUser.gender isEqualToString:@"男"]) {
        [self.ageButton setBackgroundImage:[UIImage imageNamed:@"member_man"] forState:UIControlStateNormal];
    } else {
        [self.ageButton setBackgroundImage:[UIImage imageNamed:@"member_women"] forState:UIControlStateNormal];
    }
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:tapUser.photo]];
    self.iconImage.layer.cornerRadius = 31.5;
    self.iconImage.layer.masksToBounds = YES;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",tapUser.nickname];
   
    [self.view.window addSubview:carView];
    
   
}
//拉下座位
- (IBAction)downSeatButtonClick:(UIButton *)sender {
    [self coverClick];
    UITableViewCell *c = [self.memberTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag%100 inSection:0]];
    UIButton *b = (UIButton *)[c.contentView viewWithTag:sender.tag];
    
    NSString *url = [NSString stringWithFormat:@"v1/activity/%@/seat/return?userId=%@&token=%@",self.activityId,self.userId,self.token];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"member"] = self.tapUserID;
    [self.view showWait];
    [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        [self.view hideWait];
        if ([responseObject operationSuccess]) {
            //图片置空
            [b setImage:nil forState:UIControlStateNormal];
            //从新加载信息
            NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/members?userId=%@&token=%@",self.activityId,self.userId,self.token];
            [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
                if ([responseObject operationSuccess]) {
                    NSArray *carModel = [cars objectArrayWithKeyValuesArray:responseObject[@"data"][@"cars"]];
                    //将车数组里面全部数据删除从新加载
                    [self.carsArray removeAllObjects];
                    [self.carsArray addObjectsFromArray:carModel];
                    [self.memberTableView reloadData];
                }
            } failure:^(NSError *error) {
                [self.view alertError:error];
            }];
        } else {
            [self.view alertError:responseObject];
        }
    } failed:^(NSError *error) {
        [self.view alertError:error];
    }];
    
    
}
- (IBAction)cancelSeatButton:(UIButton *)sender {
    [self coverClick];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.carsArray.count + self.membersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.carsArray.count) {
        carManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        cars *models = self.carsArray[indexPath.row];
        cell.models = models;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.seatMain.tag = indexPath.row +1000;
        cell.seatone.tag = indexPath.row +2000;
        cell.seatTwo.tag = indexPath.row + 3000;
        cell.seatThree.tag = indexPath.row + 4000;
        [cell setRightUtilityButtons:[self carRightButtons:[cell.totalSeat intValue] - 4] WithButtonWidth:45];
        cell.delegate = self;
//        SWUtilityButtonView *buttonView = [cell valueForKey:@"rightUtilityButtonsView"];
        NSArray *userArray = models.users;
        for (users *user in userArray ) {
            SQLog(@"%@",user.seatIndex);
            if ([user.seatIndex intValue] >= 4 ) {
                if ([user.seatIndex intValue] == 4) {
                    UIButton *subButton = (UIButton *)[cell.rightUtilityButtons[0] viewWithTag:1000];
                    [subButton sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [subButton setBackgroundImage:[UIImage imageNamed:@"member_mainSeat"] forState:UIControlStateNormal];
                }
                if ([user.seatIndex intValue] == 5) {
                    UIButton *subButton = (UIButton *)[cell.rightUtilityButtons[1] viewWithTag:1000];
                    [subButton sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [subButton setBackgroundImage:[UIImage imageNamed:@"member_mainSeat"] forState:UIControlStateNormal];
                }
                if ([user.seatIndex intValue] == 6) {
                    UIButton *subButton = (UIButton *)[cell.rightUtilityButtons[2] viewWithTag:1000];
                    [subButton sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [subButton setBackgroundImage:[UIImage imageNamed:@"member_mainSeat"] forState:UIControlStateNormal];
                }
                
            }
        }
        return cell;
        
    } else {

        memberManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"membercell"];
        cell.models = self.membersArray[indexPath.row - self.carsArray.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.memberIconButton.tag = indexPath.row - self.carsArray.count;
        cell.delegate = self;
        [cell setRightUtilityButtons:[self memberRightButtons] WithButtonWidth:60];
        
        return cell;
    }
   
}
//SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if ([cell isKindOfClass:[memberManageCell class]]) {
        NSIndexPath *cellIndexPath = [self.memberTableView indexPathForCell:cell];
        SQLog(@"%tu",cellIndexPath.row);
        [self.view showWait];
        NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/member/remove?userId=%@&token=%@",self.activityId,self.userId,self.token];
        members *TapMember = self.membersArray[cellIndexPath.row - self.carsArray.count];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"member"] = TapMember.userId;
        [ZYNetWorkTool postJsonWithUrl:urlStr params:params success:^(id responseObject) {
            [self.view hideWait];
            if ([responseObject operationSuccess]) {
                //把相关座位也要删除
                [self.carsArray removeAllObjects];
                [self.membersArray removeAllObjects];
                [self loadMessage];
                [self.view alert:@"删除成功"];
            } else {
                [self.view alertError:responseObject];
            }
        } failed:^(NSError *error) {
            [self.view alertError:error];
        }];
    }  else {
        //点击座位
        NSIndexPath *cellIndexPath = [self.memberTableView indexPathForCell:cell];
        UIButton *button = cell.rightUtilityButtons[index];
        UIButton *sub = (UIButton *)[button viewWithTag:1000];
        self.subButton = sub;
        if ([sub imageForState:UIControlStateNormal] == nil) {
            [self.view alert:@"该座位为空座"];
            return;
        }
        // 遮盖
        UIButton *cover = [[UIButton alloc] init];
        self.cover = cover;
        cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
        cover.frame = [UIScreen mainScreen].bounds;
        [self.view.window addSubview:cover];
        UIView *carView = [[[NSBundle mainBundle]loadNibNamed:@"downSeat" owner:self options:nil]lastObject];
        CGFloat carViewX = self.view.window.center.x;
        CGFloat carViewY = self.view.window.center.y - 100;
        carView.center = CGPointMake(carViewX, carViewY);
        //拉下座位按钮
         UIButton *downButton = (UIButton *)[carView viewWithTag:1000];
        [downButton addTarget:self action:@selector(downButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.downButton.backgroundColor = [AppAppearance greenColor];
        [self.downButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
        self.downButton.titleLabel.font = [AppAppearance titleFont];
        self.downButton.layer.cornerRadius = 3;
        [self.downButton clipsToBounds];
        self.carView = carView;
        self.nameLabel.font = [AppAppearance textLargeFont];
        self.nameLabel.textColor = [AppAppearance textDarkColor];
        [self.ageButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
        self.ageButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.ageButton setBackgroundImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
        self.ageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.ageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
        //获取座位的tag
//        self.downButton.tag = sender.tag;
        //获取car
        cars *car = self.carsArray[cellIndexPath.row];
        NSString *seatIndex = [NSString stringWithFormat:@"%tu",index + 4];
        SQLog(@"%@",seatIndex);
        NSArray *usersArray = car.users;
        users *tapUser = nil;
        for (users *user in usersArray) {
            if ([user.seatIndex isEqualToString:seatIndex]) {
                //通过seatIndex获取user
                tapUser = user;
                break;
            }
        }
        //获取点击人得userID
        self.tapUserID = tapUser.userId;
        [self.ageButton setTitle:tapUser.age forState:UIControlStateNormal];
        if ([tapUser.gender isEqualToString:@"男"]) {
            [self.ageButton setBackgroundImage:[UIImage imageNamed:@"member_man"] forState:UIControlStateNormal];
        } else {
            [self.ageButton setBackgroundImage:[UIImage imageNamed:@"member_women"] forState:UIControlStateNormal];
        }
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:tapUser.photo]];
        self.iconImage.layer.cornerRadius = 31.5;
        self.iconImage.layer.masksToBounds = YES;
        self.nameLabel.text = [NSString stringWithFormat:@"%@",tapUser.nickname];
        
        [self.view.window addSubview:carView];
        

    }

}
//点击拉下座位
- (void)downButtonDidClick{
    
    [self coverClick];
    NSString *url = [NSString stringWithFormat:@"v1/activity/%@/seat/return?userId=%@&token=%@",self.activityId,self.userId,self.token];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"member"] = self.tapUserID;
    [self.view showWait];
    [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        [self.view hideWait];
        if ([responseObject operationSuccess]) {
            //图片置空
            [self.subButton setImage:nil forState:UIControlStateNormal];
            //从新加载信息
            NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/members?userId=%@&token=%@",self.activityId,self.userId,self.token];
            [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
                if ([responseObject operationSuccess]) {
                    NSArray *carModel = [cars objectArrayWithKeyValuesArray:responseObject[@"data"][@"cars"]];
                    //将车数组里面全部数据删除从新加载
                    [self.carsArray removeAllObjects];
                    [self.carsArray addObjectsFromArray:carModel];
                    [self.memberTableView reloadData];
                }
            } failure:^(NSError *error) {
                [self.view alertError:error];
            }];
        } else {
            [self.view alertError:responseObject];
        }
    } failed:^(NSError *error) {
        [self.view alertError:error];
    }];

}
- (NSArray *)carRightButtons:(int)seatNumber
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    for (int  i = 0; i<seatNumber; i++) {
        [rightUtilityButtons sw_addUtilityButton];
    }
    
    return rightUtilityButtons;
}
- (NSArray *)memberRightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [AppAppearance redColor] title:@"删除"];
    return rightUtilityButtons;
}
- (IBAction)tapIconButton:(UIButton *)sender {
    members *member = self.membersArray[sender.tag];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil];

    CPTaDetailsController *taViewController = sb.instantiateInitialViewController;
    taViewController.targetUserId = member.userId;

    [self.navigationController pushViewController:taViewController animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.carsArray.count) {
        return 52;
    } else {
        return 70;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)coverClick {
    [_cover removeFromSuperview];
    _cover = nil;
    
    [_carView removeFromSuperview];
    _carView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//开始畅聊
- (IBAction)begainChatButtonDIdCLick:(UIButton *)sender {
    ChatViewController *chatController;
    
    chatController = [[ChatViewController alloc] initWithChatter:self.chatGroupId conversationType:eConversationTypeGroupChat];
    chatController.title = self.activityTitle;
    
    EMError *error = nil;
    EMGroup *group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:self.chatGroupId error:&error];
    if (group) {
        chatController.group = group;
        [self.navigationController pushViewController:chatController animated:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误，请稍候再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - lazy
- (NSMutableArray *)membersArray {
    if (!_membersArray) {
        _membersArray = [[NSMutableArray alloc]init];
    }
    return _membersArray;
}
- (NSMutableArray *)carsArray {
    if (!_carsArray) {
        _carsArray = [[NSMutableArray alloc]init];
    }
    return _carsArray;
}
@end
