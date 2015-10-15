//
//  CPMyInfoController.h
//  CarPlay
//
//  Created by 公平价 on 15/10/12.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPickView.h"

@interface CPMyInfoController : UITableViewController
@property(nonatomic,strong)ZHPickView *pickview;
- (IBAction)headIconBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadIcon;
@property (weak, nonatomic) IBOutlet UITextField *nick;
@property (weak, nonatomic) IBOutlet UITextField *brithDay;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) CPUser *user;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
- (IBAction)manBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *womanBtn;
- (IBAction)womanBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *truePortraitLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@end
