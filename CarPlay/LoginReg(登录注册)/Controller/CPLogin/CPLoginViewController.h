//
//  CPLoginViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/9/24.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"

@interface CPLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)registerBtnClick:(id)sender;
- (IBAction)forgetPasswordBtnClick:(id)sender;
- (IBAction)thirdpartyLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet CustomSwitch *switchPassword;

@end
