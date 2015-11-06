//
//  CPModifyPassword.h
//  CarPlay
//
//  Created by 公平价 on 15/11/6.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPModifyPassword : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confimPassword;
@property (weak, nonatomic) IBOutlet UIButton *confimBtn;
- (IBAction)confim:(id)sender;
@end
