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
#define kActivityId @"55838b12-7039-41e5-9150-6dd154de961b"
#define kUserId @"846de312-306c-4916-91c1-a5e69b158014"
#define kToken @"750dd49c-6129-4a9a-9558-27fa74fc4ce7"


@interface MembersManageController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *memberTableView;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;

@property (weak, nonatomic) IBOutlet UIButton *downButton;
//downSearXib
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//遮盖
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) NSMutableArray *membersArray;
@property (nonatomic, strong) NSMutableArray *carsArray;
@property (nonatomic, assign) BOOL member;
@property (nonatomic, strong) NSString *tapUserID;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@end

@implementation MembersManageController
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"成员管理";
    [self setupFontAndColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"邀请" titleColor:[AppAppearance titleColor] font:[AppAppearance textLargeFont] target:self action:@selector(inviteFriend)];
    [self loadMessage];

}

//添加微信分享的语句
- (void)inviteFriend {
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/activity/%@/index.html",kActivityId];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://cwapi.gongpingjia.com/activity/%@/index.html",kActivityId];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:nil shareText:@"我刚创建了一个活动，小伙伴们快来加入吧" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToSms, nil] delegate:nil];
}

- (void) setupFontAndColor {
    
    self.seatLabel.font = [AppAppearance textLargeFont];
    self.seatLabel.textColor = [AppAppearance textMediumColor];
    self.memberTableView.separatorColor = [AppAppearance lineColor];
}
//管理 删除参与者
- (IBAction)memberCellDelete:(UIButton *)sender {
    [self.view showWait];
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/member/remove?userId=%@&token=%@",kActivityId,kUserId,kToken];
    SQLog(@"%tu",sender.tag);
    members *TapMember = self.membersArray[sender.tag];
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

}
//加载成员信息和car信息
- (void)loadMessage {
    //示例参数@"http://cwapi.gongpingjia.com/v1"
    [self.view showWait];
//        NSString *userId = [Tools getValueFromKey:@"userId"];
//        if (userId.length == 0) {
//            [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
//            return;
//        }
//        self.userId = userId;
//        NSString *token = [Tools getValueFromKey:@"token"];
//        if (token.length == 0) {
//            [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
//            return;
//        }
//        self.token = token;
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/members?userId=%@&token=%@",kActivityId,kUserId,kToken];
    [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self.view hideWait];
        SQLog(@"%@",responseObject);
        if ([responseObject operationSuccess]) {
            NSArray *memberModel = [members objectArrayWithKeyValuesArray:responseObject[@"data"][@"members"]];
            NSArray *carModel = [cars objectArrayWithKeyValuesArray:responseObject[@"data"][@"cars"]];
            [self.membersArray addObjectsFromArray:memberModel];
            [self.carsArray addObjectsFromArray:carModel];
            [self.memberTableView reloadData];
        
            
        } else {
            [self.view alertError:responseObject];
        }
    } failure:^(NSError *error) {
        [self.view alertError:error];
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
    if (sender.tag <= 1000) {
        seatIndex = @"1";
    }
    else if (sender.tag <=2000) {
        seatIndex = @"2";
    }
    else if (sender.tag <=3000) {
        seatIndex = @"3";
    }
    else if (sender.tag <=4000) {
        seatIndex = @"4";
    }
    else if (sender.tag <=5000) {
        seatIndex = @"5";
    }
    else if (sender.tag <=6000) {
        seatIndex = @"6";
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
    
    NSString *url = [NSString stringWithFormat:@"v1/activity/%@/seat/return?userId=%@&token=%@",kActivityId,kUserId,kToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"member"] = self.tapUserID;
    [self.view showWait];
    //图片置空
    [b setImage:nil forState:UIControlStateNormal];
    [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
        [self.view hideWait];
        if ([responseObject operationSuccess]) {
            //从新加载信息
            NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/members?userId=%@&token=%@",kActivityId,kUserId,kToken];
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
    return self.membersArray.count + self.carsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQLog(@"%@",self.carsArray);
    if (indexPath.row < self.carsArray.count) {
        carManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        cell.models = self.carsArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.seatone.tag = indexPath.row + 1000;
        cell.seatTwo.tag = indexPath.row +2000;
        cell.seatThree.tag = indexPath.row +3000;
        cell.seatLastThree.tag = indexPath.row +4000;
        cell.seatLastTwo.tag = indexPath.row + 5000;
        cell.seatLastOne.tag = indexPath.row + 6000;
        return cell;
        
    } else {

        memberManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"membercell"];
        cell.models = self.membersArray[indexPath.row - self.carsArray.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.deleteButton.tag = indexPath.row - self.carsArray.count;
        return cell;
    }
   
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