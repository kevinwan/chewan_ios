//
//  memberCell.h
//  参与成员
//
//  Created by Jia Zhao on 15/7/15.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "members.h"
@interface memberManageCell : UITableViewCell
@property (nonatomic, strong) members *models;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *memberIconImageView;
@end
