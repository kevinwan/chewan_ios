//
//  CPSettingController.h
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSettingController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;
- (IBAction)loginOut:(id)sender;
@end
