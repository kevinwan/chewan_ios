//
//  CPEditUsername.h
//  CarPlay
//
//  Created by 公平价 on 15/10/20.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPUser.h"

@interface CPEditUsername : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (nonatomic, strong) CPUser *user;
@end
