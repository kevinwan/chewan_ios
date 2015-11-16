//
//  CPMessageNotification.h
//  CarPlay
//
//  Created by 公平价 on 15/11/16.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPMySwitch.h"

@interface CPMessageNotification : UITableViewController
@property (weak, nonatomic) IBOutlet CPMySwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet CPMySwitch *vibrationSwitch;

@end
