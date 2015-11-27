//
//  CPCarOwnersCertificationController.h
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCarOwnersCertificationController : UITableViewController
@property (nonatomic, strong) CPUser *user;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *bandName;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bandNameWidth;
@property (weak, nonatomic) IBOutlet UIButton *uploadDriverLicense;
@property (weak, nonatomic) IBOutlet UIButton *uploadDrivingLicense;
- (IBAction)upload:(UIButton *)sender;

@end
