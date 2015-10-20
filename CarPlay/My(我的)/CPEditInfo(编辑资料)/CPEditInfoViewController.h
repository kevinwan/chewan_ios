//
//  CPEditInfoViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/10/20.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPEditInfoViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *photoAuthStatus;
@property (weak, nonatomic) IBOutlet UILabel *licenseAuthStatus;
@end
