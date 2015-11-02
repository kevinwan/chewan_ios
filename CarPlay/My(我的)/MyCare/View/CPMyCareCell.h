//
//  CPMyCareCell.h
//  CarPlay
//
//  Created by 公平价 on 15/9/28.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPCareUser.h"
#import "ZYTableViewCell.h"

@interface CPMyCareCell : ZYTableViewCell

@property (nonatomic,strong) CPCareUser *careUser;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;
// 头像
@property (weak, nonatomic) IBOutlet UIButton *avatar;
+ (NSString *)identifier;


@end
