//
//  registerViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface registerViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getIdentifyingCode;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)getIdentifyingCodeClick:(id)sender;
- (IBAction)checkBtnClick:(id)sender;

- (IBAction)serviceTermsBtnClick:(id)sender;
- (IBAction)nextBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end
