//
//  CPNewPassWordViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface CPNewPassWordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSString *pwd;
@property (strong, nonatomic) NSString *phone;
@end
