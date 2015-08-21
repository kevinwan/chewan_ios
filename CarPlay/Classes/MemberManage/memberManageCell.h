//
//  memberCell.h
//  参与成员
//
//  Created by Jia Zhao on 15/7/15.
//  Copyright (c) 2015年 sun qiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "members.h"
#import <SWTableViewCell.h>
@interface memberManageCell : SWTableViewCell
@property (nonatomic, strong) members *models;

@property (weak, nonatomic) IBOutlet UIButton *memberIconButton;

@end
