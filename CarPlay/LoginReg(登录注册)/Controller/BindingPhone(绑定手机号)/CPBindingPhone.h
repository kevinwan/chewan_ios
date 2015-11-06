//
//  CPBindingPhone.h
//  CarPlay
//
//  Created by 公平价 on 15/11/6.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBindingPhone : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
- (IBAction)getVerificationCodeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;
- (IBAction)bindingBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verificationCodeWeight;
@property (weak, nonatomic) IBOutlet UIView *passWordView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bindingBtnTop;
@property (nonatomic, strong) CPUser *user;
@end
