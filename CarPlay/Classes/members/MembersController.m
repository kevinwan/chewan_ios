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
    [self.view showWait];
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/members?userId=%@&token=%@",self.activityId,self.userId,self.token];
    [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
        [self.view hideWait];
//        SQLog(@"%@",responseObject);
        if ([responseObject operationSuccess]) {
            NSArray *memberModel = [members objectArrayWithKeyValuesArray:responseObject[@"data"][@"members"]];
            NSArray *carModel = [cars objectArrayWithKeyValuesArray:responseObject[@"data"][@"cars"]];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%@个座位,还剩下%@个座位",responseObject[@"data"][@"totalSeat"],responseObject[@"data"][@"availableSeat"]]];
            self.chatGroupId = responseObject[@"data"][@"chatGroupId"];
            SQLog(@"%@",self.chatGroupId);
            [str addAttribute:NSForegroundColorAttributeName value:[AppAppearance redColor] range:NSMakeRange(str.length -4, 2)];
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
- (IBAction)seatDIdClick:(UIButton *)sender {
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
        SQLog(@"%@",seatIndex);
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"seatIndex"] = seatIndex;
        if (carID.length!= 0) {
        params[@"carId"] = carID;
        } else {
        params[@"carId"] = @"";
        }
        [self.view showWait];
        [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
            [self.view hideWait];
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
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.memberTableView indexPathForCell:cell];
    UIButton *button = cell.rightUtilityButtons[index];
    UIButton *sub = (UIButton *)[button viewWithTag:1000];
    self.subButton = sub;
//    [(carCell *)cell setSubButton:sub];
    SQLog(@"%@",sub);
    if ([sub imageForState:UIControlStateNormal]!= nil) {
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
    //获取抢座按钮
    CPModelButton *getButton = (CPModelButton *)[carView viewWithTag:1000];
    getButton.index = index;
    getButton.path = cellIndexPath;
    [getButton addTarget:self action:@selector(getButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat carViewX = self.view.window.center.x;
    CGFloat carViewY = self.view.window.center.y - 100;
    carView.center = CGPointMake(carViewX, carViewY);
    self.getButton.backgroundColor = [AppAppearance greenColor];
    [self.getButton setTitleColor:[AppAppearance titleColor] forState:UIControlStateNormal];
    self.getButton.titleLabel.font = [AppAppearance titleFont];
    self.getButton.layer.cornerRadius = 3;
    [self.getButton clipsToBounds];
    self.carView = carView;
    [self.view.window addSubview:carView];
}
- (void)getButtonDidClick:(CPModelButton *)sender {
    [self coverClick];
    //米奇ID
    if (self.member) {
        NSString *url = [NSString stringWithFormat:@"v1/activity/%@/seat/take?userId=%@&token=%@",self.activityId,self.userId,self.token];
        NSString *seatIndex = [NSString stringWithFormat:@"%tu",sender.index + 4];
        SQLog(@"%@",seatIndex);
        cars *car = self.carsArray[sender.path.row];
        NSString *carID = car.carId;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"seatIndex"] = seatIndex;
        if (carID.length!= 0) {
            params[@"carId"] = carID;
        } else {
            params[@"carId"] = @"";
        }
        [self.view showWait];
        [ZYNetWorkTool postJsonWithUrl:url params:params success:^(id responseObject) {
            [self.view hideWait];
            SQLog(@"%@",responseObject);
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
    [self.view showWait];
    NSString *urlStr = [NSString stringWithFormat:@"v1/activity/%@/quit?userId=%@&token=%@",self.activityId,self.userId,self.token];
    [ZYNetWorkTool postWithUrl:urlStr params:nil success:^(id responseObject) {
        [self.view hideWait];
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
        
        memberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"membercell"];
        cell.models = self.membersArray[indexPath.row - self.carsArray.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.memberIconButton.tag = indexPath.row - self.carsArray.count;
        return cell;
    }
}
- (NSArray *)carRightButtons:(int)seatNumber
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    for (int  i = 0; i<seatNumber; i++) {
        [rightUtilityButtons sw_addUtilityButton];
    }
    
    return rightUtilityButtons;
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
    [ZYNetWorkTool getWithUrl:urlStr params:nil success:^(id responseObject) {
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
    chatController.title = @"测试";
 
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
