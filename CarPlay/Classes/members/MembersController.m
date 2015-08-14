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


@interface MembersController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *memberTableView;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet UIButton *outButton;
//xib
@property (weak, nonatomic) IBOutlet UIView *carxibYesView;
@property (weak, nonatomic) IBOutlet UIView *carxibNoVIew;
@property (weak, nonatomic) IBOutlet UITextField *carxibTextFeild;
@property (nonatomic, strong) NSMutableArray *pickerArray;


//遮盖
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) UIView *carView;

@property (nonatomic, strong) NSMutableArray *membersArray;
@property (nonatomic, strong) NSMutableArray *carsArray;
@property (nonatomic, assign) BOOL member;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@end

@implementation MembersController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"参与成员";
    [self setupFontAndColor];
    [self loadMessage];
    
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
            [str addAttribute:NSForegroundColorAttributeName value:[AppAppearance redColor] range:NSMakeRange(str.length -4, 2)];
            self.seatLabel.attributedText = str;
            [self.membersArray addObjectsFromArray:memberModel];
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
                self.addButton.hidden = YES;
            } else  {
                self.outButton.hidden = YES;
                self.addButton.hidden = NO;
            }
            
        } else {
            [self.view alertError:responseObject];
        }
            } failure:^(NSError *error) {
                [self.view alertError:error];
    }];
    
    
}

//我也要加入
- (IBAction)carxibButtonClick:(UIButton *)sender {
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
//抢座
- (IBAction)getSeatButtonClick:(UIButton *)sender {
    //
    [self coverClick];
    //米奇ID
    if (self.member) {
        NSString *url = [NSString stringWithFormat:@"v1/activity/%@/seat/take?userId=%@&token=%@",self.activityId,self.userId,self.token];
        cars *car = self.carsArray[sender.tag % 1000];
        NSString *carID = car.carId;
        SQLog(@"%tu",sender.tag);
        SQLog(@"%@",carID);
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
        cell.seatone.tag = indexPath.row + 1000;
        cell.seatTwo.tag = indexPath.row +2000;
        cell.seatThree.tag = indexPath.row +3000;
        cell.seatLastThree.tag = indexPath.row +4000;
        cell.seatLastTwo.tag = indexPath.row + 5000;
        cell.seatLastOne.tag = indexPath.row + 6000;
        cell.models = self.carsArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        memberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"membercell"];
        cell.models = self.membersArray[indexPath.row - self.carsArray.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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
}
#pragma mark - 我也要加入
//点击加入按钮
- (IBAction)addButtonClick:(UIButton *)sender {
  

    NSString *urlStr = [NSString stringWithFormat:@"v1/user/%@/seats?token=%@",self.userId,self.token];
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
                UITapGestureRecognizer *tapYes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapYes)];
                [self.carxibYesView addGestureRecognizer:tapYes];
                UITapGestureRecognizer *tapNo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNo)];
                [self.carxibNoVIew addGestureRecognizer:tapNo];
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                int maxSeat = [[formatter stringFromNumber:responseObject[@"data"][@"maxValue"]] intValue];
                int minSeat = [[formatter stringFromNumber:responseObject[@"data"][@"minValue"]] intValue];
                [self.pickerArray removeAllObjects];
                for (int i = minSeat; i <= maxSeat; i++) {
                    NSString *seat = [NSString stringWithFormat:@"%tu",i];
                    [self.pickerArray addObject:seat];
                }
                UIPickerView *picker = [[UIPickerView alloc]init];
                picker.delegate = self;
                picker.dataSource = self;
                self.carxibTextFeild.inputView = picker;
                self.carxibTextFeild.delegate = self;
                self.carxibTextFeild.font = [AppAppearance textMediumFont];
                self.carxibTextFeild.textColor = [AppAppearance textDarkColor];
                [self tapYes];

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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.carxibTextFeild.text = [NSString stringWithFormat:@"%@",self.pickerArray[row]];
}


- (void)tapYes {
    
    self.carxibTextFeild.enabled = YES;
    [self.carxibTextFeild becomeFirstResponder];
}
- (void)tapNo {
    self.carxibTextFeild.enabled = NO;
    [self.carxibTextFeild resignFirstResponder];
    self.carxibTextFeild.text = nil;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 这两个都是限制6位就不区分了
    return [[textField.text stringByReplacingCharactersInRange:range withString:string] length] <= 1;
}
// 配合上面的
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
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
