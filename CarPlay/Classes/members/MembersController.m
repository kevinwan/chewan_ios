//
//  ViewController.m
//  参与成员
//
//  Created by Jia Zhao on 15/7/13.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//
#import "MembersController.h"
#import "AppAppearance.h"
#import "memberCell.h"
#import "carCell.h"
#import "UIView+Dealer.h"
#import "NSDictionary+Dealer.h"
#import "members.h"
#import "cars.h"
#import "users.h"
#import <MJExtension.h>
#import "ZYNetWorkTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CPTaDetailsController.h"
#import "ZHPickView.h"
#import "NSMutableArray+CPUtilityButtons.h"
#import "CPModelButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "ChatViewController.h"


@interface MembersController () <UITableViewDataSource,UITableViewDelegate,ZHPickViewDelegate,SWTableViewCellDelegate,ChatViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *memberTableView;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UIButton *beginChatButton;

@property (nonatomic, strong) NSMutableArray *membersArray;
@property (nonatomic, strong) NSMutableArray *carsArray;
@property (nonatomic, assign) BOOL member;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
//遮盖
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) UITextField *carxibTextFeild;
@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, assign) BOOL tapYes;
@property (nonatomic, strong) NSMutableArray *pickerArray;
@property (nonatomic, strong) NSString *createrId;
@property (nonatomic, strong) ZHPickView *picker;
@property (nonatomic, strong) UIButton *subButton;
@property (nonatomic, strong) NSString *chatGroupId;
@end

@implementation MembersController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CPGuideView showGuideViewWithImageName:@"memberGuide"];
    self.navigationItem.title = @"参与成员";
    [self setupFontAndColor];
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
- (void) setupFontAndColor {
    
    self.seatLabel.font = [AppAppearance textLargeFont];
    self.seatLabel.textColor = [AppAppearance textMediumColor];
    
    [self.addButton setTitle:@"加入活动" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    [self.addButton setBackgroundColor:[AppAppearance greenColor]];
    self.addButton.layer.cornerRadius = 3;
    [self.addButton clipsToBounds];
    [self.outButton setTitle:@"退出活动" forState:UIControlStateNormal];
    [self.outButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    [self.outButton setBackgroundColor:[AppAppearance redColor]];
    self.outButton.layer.cornerRadius = 3;
    [self.outButton clipsToBounds];
    [self.beginChatButton setTitle:@"开始畅聊" forState:UIControlStateNormal];
    [self.beginChatButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    [self.beginChatButton setBackgroundColor:[AppAppearance greenColor]];
    self.beginChatButton.layer.cornerRadius = 3;
    [self.beginChatButton clipsToBounds];
    //改tableView的线的颜色
    self.memberTableView.separatorColor = [AppAppearance lineColor];
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
    [self showLoading];
//    [self.view showWait];
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/members?userId=%@&token=%@",self.activityId,self.userId,self.token];
    [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self disMiss];
//        [self.view hideWait];
//        SQLog(@"%@",responseObject);
        if ([responseObject operationSuccess]) {
            NSArray *memberModel = [members objectArrayWithKeyValuesArray:responseObject[@"data"][@"members"]];
            NSArray *carModel = [cars objectArrayWithKeyValuesArray:responseObject[@"data"][@"cars"]];
            NSString *availableSeat = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"availableSeat"]];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%@个座位,还剩下%@个座位",responseObject[@"data"][@"totalSeat"],availableSeat]];
            self.chatGroupId = responseObject[@"data"][@"chatGroupId"];
            self.activityTitle = responseObject[@"data"][@"title"];
            SQLog(@"%@",self.chatGroupId);
            if (availableSeat.length == 1) {
                [str addAttribute:NSForegroundColorAttributeName value:[AppAppearance redColor] range:NSMakeRange(str.length -4, 2)];
            } else {
                [str addAttribute:NSForegroundColorAttributeName value:[AppAppearance redColor] range:NSMakeRange(str.length -5, 3)];
            }
            
            self.seatLabel.attributedText = str;
            [self.membersArray removeAllObjects];
            [self.membersArray addObjectsFromArray:memberModel];
            [self.carsArray removeAllObjects];
            [self.carsArray addObjectsFromArray:carModel];
            [self.memberTableView reloadData];
            //判断下是否是成员
            self.member = NO;
            for (members *member in self.membersArray) {
                if ([self.userId isEqualToString:member.userId]) {
                    self.member = YES;
                    break;
                }
            }
            SQLog(@"%tu",self.member);
            if (self.member) {
                //如果是成员 打开退出活动按钮
                self.outButton.hidden = NO;
                self.beginChatButton.hidden = NO;
                self.addButton.hidden = YES;
            } else  {
                self.outButton.hidden = YES;
                self.beginChatButton.hidden = YES;
                self.addButton.hidden = NO;
            }
            [self.memberTableView.header endRefreshing];
            [self.memberTableView.footer endRefreshing];
        } else {
            [self.view alertError:responseObject];
        }
            } failure:^(NSError *error) {
                [self.view alertError:error];
                [self.memberTableView.header endRefreshing];
                [self.memberTableView.footer endRefreshing];
    }];
    
    
}

//提交座位
- (void)offerSeatButton {
    NSString *userId = self.userId;
    NSString *token = self.token;
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/join?userId=%@&token=%@",self.activityId,userId,token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *seatStr = self.carxibTextFeild.text;
    if (seatStr.length!= 0) {
        parameters[@"seat"] = seatStr;
    } else {
        parameters[@"seat"] = @"0";
    }
    [self coverClick];
  [ZYNetWorkTool postJsonWithUrl:urlStr params:parameters success:^(id responseObject) {
      if ([responseObject operationSuccess]) {
          [self.view alert:@"请求成功,等待同意"];
      } else {
          [self.view alertError:responseObject];
      }
  } failed:^(NSError *error) {
      [self.view alertError:error];
  }];
    
}

//点击座位
- (void)seatDIdClick:(UIButton *)sender {
    if ([sender imageForState:UIControlStateNormal]!= nil) {
        [self.view alert:@"此座位已有人"];
        return;
    }
    // 遮盖
    UIButton *cover = [[UIButton alloc] init];
    self.cover = cover;
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = [UIScreen mainScreen].bounds;
    [self.view.window addSubview:cover];
    UIView *carView = [[[NSBundle mainBundle]loadNibNamed:@"emptySeat" owner:self options:nil]lastObject];
    CGFloat carViewX = self.view.window.center.x;
    CGFloat carViewY = self.view.window.center.y - 100;
    carView.center = CGPointMake(carViewX, carViewY);
    self.getButton.backgroundColor = [AppAppearance greenColor];
    [self.getButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    self.getButton.titleLabel.font = [AppAppearance titleFont];
    self.getButton.layer.cornerRadius = 3;
    [self.getButton clipsToBounds];
    self.carView = carView;
    self.getButton.tag = sender.tag;
    [self.view.window addSubview:carView];
    
}
//抢座按钮
- (IBAction)getSeatButtonClick:(UIButton *)sender {
    [self coverClick];
    //米奇ID
    if (self.member) {
        NSString *url = [NSString stringWithFormat:@"v1/activity/%@/seat/take?userId=%@&token=%@",self.activityId,self.userId,self.token];
        cars *car = self.carsArray[sender.tag % 1000];
        NSString *carID = car.carId;
        SQLog(@"%tu",sender.tag);
        SQLog(@"%@",carID);
        NSString *seatIndex = nil;
        if (sender.tag < 2000) {
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
        else if (sender.tag < 6000) {
            seatIndex = @"4";
        }
        else if (sender.tag < 7000) {
            seatIndex = @"5";
        }
        else if (sender.tag < 8000) {
            seatIndex = @"6";
        }
        SQLog(@"%@",seatIndex);
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"seatIndex"] = seatIndex;
        if (carID.length!= 0) {
        params[@"carId"] = carID;
        } else {
        params[@"carId"] = @"";
        }
        [self showLoading];
        [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
            [self disMiss];
            if ([responseObject operationSuccess]) {
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
        
    } else {
        [self.view alert:@"加入活动才能抢座，点击底部\"加入活动\"吧"];
    }
}
- (IBAction)cancelSeatButton:(UIButton *)sender {
    [self coverClick];
}


//退出活动
- (IBAction)outButtonDidClick:(UIButton *)sender {
    UIButton *cover = [[UIButton alloc] init];
    self.cover = cover;
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = [UIScreen mainScreen].bounds;
    [self.view.window addSubview:cover];
    UIView *carView = [[[NSBundle mainBundle]loadNibNamed:@"outActivity" owner:self options:nil]lastObject];
    CGFloat carViewX = self.view.window.center.x;
    CGFloat carViewY = self.view.window.center.y - 100;
    carView.center = CGPointMake(carViewX, carViewY);
    self.carView = carView;
    [self.view.window addSubview:carView];

    
}
- (IBAction)outActivityCancelButton:(UIButton *)sender {
    [self coverClick];
}
//退出活动确定按钮
- (IBAction)outActivitySureButton:(UIButton *)sender {
    [self coverClick];
    [self showLoading];
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/quit?userId=%@&token=%@",self.activityId,self.userId,self.token];
    [ZYNetWorkTool postWithUrl:urlStr params:nil success:^(id responseObject) {
        [self disMiss];
        SQLog(@"%@",responseObject);
        if ([responseObject operationSuccess]) {
            [self.membersArray removeAllObjects];
            [self.carsArray removeAllObjects];
            [self loadMessage];
            SQLog(@"%@",self.membersArray);
        } else {
            [self.view alertError:responseObject];
        }
    } failure:^(NSError *error) {
        [self.view alertError:error];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.carsArray.count + self.membersArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.carsArray.count) {
        carCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        cars *models = self.carsArray[indexPath.row];
        cell.models = models;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //防止点击状态栏不能回到顶部
        cell.seatScrollView.scrollsToTop = NO;
        //先清除button
        for (UIButton *button in cell.seatScrollView.subviews) {
            [button removeFromSuperview];
        }
        [self setUpScrollView:cell.totalSeat :indexPath :cell.seatScrollView];
        //显示座位的头像
        UIButton *button = nil;
        NSArray *userArray = models.users;
        for (users *user in userArray) {
            switch ([user.seatIndex intValue]) {
                case 0:
                    button = (UIButton *)[cell.seatScrollView viewWithTag:indexPath.row+ 1000];
                    [button sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [self getBackImageOfButton:button];
                    break;
                case 1:
                    button = (UIButton *)[cell.seatScrollView viewWithTag:indexPath.row+ 2000];
                    [button sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [self getBackImageOfButton:button];
                    break;
                case 2:
                    button = (UIButton *)[cell.seatScrollView viewWithTag:indexPath.row+ 3000];
                    [button sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [self getBackImageOfButton:button];
                    break;
                case 3:
                    button = (UIButton *)[cell.seatScrollView viewWithTag:indexPath.row+ 4000];
                    [button sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [self getBackImageOfButton:button];
                    break;
                case 4:
                    button = (UIButton *)[cell.seatScrollView viewWithTag:indexPath.row+ 5000];
                    [button sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [self getBackImageOfButton:button];
                    break;
                case 5:
                    button = (UIButton *)[cell.seatScrollView viewWithTag:indexPath.row+ 6000];
                    [button sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [self getBackImageOfButton:button];
                    break;
                case 6:
                    button = (UIButton *)[cell.seatScrollView viewWithTag:indexPath.row+ 7000];
                    [button sd_setImageWithURL:[NSURL URLWithString:user.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"member_seatIcon"]];
                    [self getBackImageOfButton:button];
                    break;
                    
                default:
                    break;
            }
            
        }
        
        return cell;
        
    } else {
        
        memberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"membercell"];
        cell.models = self.membersArray[indexPath.row - self.carsArray.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.memberIconButton.tag = indexPath.row - self.carsArray.count;
        return cell;
    }
}
- (void)getBackImageOfButton:(UIButton *)button {
    if ([button imageForState:UIControlStateNormal]) {
        [button setBackgroundImage:[UIImage imageNamed:@"member_mainSeat"] forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"member_seat"] forState:UIControlStateNormal];
    }
    
}

//在ScrollView里面建立button
- (void)setUpScrollView:(NSString *)totalSeat :(NSIndexPath *)path :(UIScrollView *) seatScrollView{
    CGFloat buttonW = 30;
    CGFloat buttonH = 30;
    CGFloat buttonY = 11;
    CGFloat magin = 15;
    for (int i = 0; i<[totalSeat integerValue]; i++) {
        // 创建图片容器
        UIButton *button = [[UIButton alloc]init];
        button.tag = path.row+1000*(i+1);
        CGFloat buttonX = i*(magin +buttonW);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 设置背景图片
        if ([button imageForState:UIControlStateNormal]) {
            [button setBackgroundImage:[UIImage imageNamed:@"member_mainSeat"] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"member_seat"] forState:UIControlStateNormal];
        }
        //设置座位头像图片
        button.imageView.layer.cornerRadius = 12;
        [button clipsToBounds];
        button.imageEdgeInsets = UIEdgeInsetsMake(-4, 3, 10, 3);
        //一开始置空
        [button setImage:nil forState:UIControlStateNormal];
        //添加按钮事件
        [button addTarget:self action:@selector(seatDIdClick:) forControlEvents:UIControlEventTouchUpInside];
        [seatScrollView addSubview:button];
    }
    CGFloat contentW = [totalSeat integerValue]*(magin +buttonW);
    seatScrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 3.隐藏水平滚动条
    seatScrollView.showsHorizontalScrollIndicator = NO;
}


- (IBAction)tapIconButton:(UIButton *)sender {
    members *member = self.membersArray[sender.tag];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CPTaDetailsController" bundle:nil];
    
    CPTaDetailsController *taViewController = sb.instantiateInitialViewController;
    taViewController.targetUserId = member.userId;
    
    [self.navigationController pushViewController:taViewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.carsArray.count) {
        return 52;
    } else {
        return 70;
    }
}
- (void)coverClick {
    [_cover removeFromSuperview];
    _cover = nil;
    
    [_carView removeFromSuperview];
    _carView = nil;
    [_picker removeFromSuperview];
    _picker = nil;
}
#pragma mark - 我也要加入
//点击加入按钮
- (IBAction)addButtonClick:(UIButton *)sender {
   NSString *urlStr = [NSString stringWithFormat:@"v1/user/%@/seats?token=%@&activityId=%@",self.userId,self.token,self.activityId];
    //主车提供后台返回的车 非车主最多提供两辆车
    [self showLoading];
    [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self disMiss];
        if ([responseObject operationSuccess]) {
            SQLog(@"%@",responseObject);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            NSString *str = [formatter stringFromNumber:responseObject[@"data"][@"isAuthenticated"]];
            if ([str isEqualToString:@"1"]) {
                // 遮盖
                UIButton *cover = [[UIButton alloc] init];
                self.cover = cover;
                cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
                cover.frame = [UIScreen mainScreen].bounds;
                [self.view.window addSubview:cover];
                UIView *carView = [[[NSBundle mainBundle]loadNibNamed:@"offerCar" owner:self options:nil]lastObject];
                CGFloat carViewX = self.view.window.center.x;
                CGFloat carViewY = self.view.window.center.y - 100;
                carView.center = CGPointMake(carViewX, carViewY);
                self.carView = carView;
                [self.view.window addSubview:carView];
                //注意加载之后才有xib
                UIButton *noButton = (UIButton *)[carView viewWithTag:1000];
                self.noButton = noButton;
                UIButton *yeButton = (UIButton *)[carView viewWithTag:2000];
                
                self.yesButton = yeButton;
                [noButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
                [yeButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
                UIButton * offerButton = (UIButton *)[carView viewWithTag:3000];
                UITextField * carxibTextFeild = (UITextField *)[carView viewWithTag:4000];
                self.carxibTextFeild = carxibTextFeild;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
                [carView addGestureRecognizer:tap];
                [offerButton addTarget:self action:@selector(offerSeatButton) forControlEvents:UIControlEventTouchUpInside];
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                int maxSeat = [[formatter stringFromNumber:responseObject[@"data"][@"maxValue"]] intValue];
                int minSeat = [[formatter stringFromNumber:responseObject[@"data"][@"minValue"]] intValue];
                [self.pickerArray removeAllObjects];
                for (int i = minSeat; i <= maxSeat; i++) {
                    NSString *seat = [NSString stringWithFormat:@"%tu",i];
                    [self.pickerArray addObject:seat];
                }
                ZHPickView *picker = [[ZHPickView alloc]initPickviewWithArray:self.pickerArray isHaveNavControler:NO];
                picker.delegate = self;
                self.picker = picker;
                
                self.carxibTextFeild.font = [AppAppearance textMediumFont];
                self.carxibTextFeild.textColor = [AppAppearance textDarkColor];

            } else {
                NSString *userId = self.userId;
                NSString *token = self.token;
                NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/join?userId=%@&token=%@",self.activityId,userId,token];
                [ZYNetWorkTool postJsonWithUrl:urlStr params:nil success:^(id responseObject) {
                    if ([responseObject operationSuccess]) {
                        [self.view alert:@"请求成功,等待同意"];
                    } else {
                        [self.view alertError:responseObject];
                    }
                } failed:^(NSError *error) {
                    [self.view alertError:error];
                }];

             }

        } else {
            [self.view alertError:responseObject];
        }
    } failure:^(NSError *error) {
        [self.view alertError:error];
    }];
 
}
#pragma mark - ZHPickViewDelegate
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    self.carxibTextFeild.text = resultString;
}

- (void)tap{
    if (!self.tapYes) {
        [self.picker show];
        self.picker.y = kScreenHeight - 256;
        self.yesButton.selected = YES;
        self.noButton.selected = NO;
        self.tapYes = YES;
    } else {
        [self.picker remove];
        self.yesButton.selected = NO;
        self.noButton.selected = YES;
        self.tapYes = NO;
        self.carxibTextFeild.text = nil;
    }

}
- (void)dealloc
{
    [CPNotificationCenter removeObserver:self];
    if (self.picker) {
        [self.picker removeFromSuperview];
    }
}
//开始群聊
- (IBAction)beginChatButonDidClick:(UIButton *)sender {
    ChatViewController *chatController;

    chatController = [[ChatViewController alloc] initWithChatter:self.chatGroupId conversationType:eConversationTypeGroupChat];
    chatController.delelgate = self;
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
- (NSMutableArray *)pickerArray {
    if (!_pickerArray) {
        _pickerArray = [[NSMutableArray alloc]init];
    }
    return _pickerArray;
}
@end
