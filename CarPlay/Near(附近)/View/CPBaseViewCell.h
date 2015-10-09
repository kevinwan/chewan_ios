//
//  CPNearViewCell.h
//  CarPlay
//
//  Created by chewan on 15/9/23.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPActivityModel.h"

#define CameraBtnClickKey   @"CameraBtnClickKey"
#define PhotoBtnClickKey    @"PhotoBtnClickKey"
#define DateBtnClickKey     @"DateBtnClickKey"
#define InvitedBtnClickKey  @"InvitedBtnClickKey"
#define IgnoreBtnClickKey   @"IgnoreBtnClickKey"
#define DistanceBtnClickKey @"DistanceBtnClickKey"
#define AddressBtnClickKey  @"AddressBtnClickKey"

@interface CPBaseViewCell : UIView
@property (nonatomic, strong) CPActivityModel *model;
@property (nonatomic, assign) BOOL oneType;
@end
