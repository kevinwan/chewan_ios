//
//  CPEditUsernameViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/7/16.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "BaseViewController.h"

@interface CPEditUsernameViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nicknameLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
@property (weak, nonatomic) NSString *fromEdit;
@end
