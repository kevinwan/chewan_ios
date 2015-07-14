//
//  CPForgetPasswordViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/10.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface CPForgetPasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneLable;
@property (weak, nonatomic) IBOutlet UITextField *identifyingCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getIdentifyingCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)getIdentifyingCodeBtnClick:(id)sender;
- (IBAction)nextBtnClick:(id)sender;

@end
